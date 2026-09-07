# Dev Decompile 使用文档

## 1. 用途与定位

`dev-decompile` 是面向 **Android 安装包 (APK/XAPK/APKS) 与 Java/Android 依赖库 (JAR/AAR) 的全自动化、结构化反编译与逆向工程工作流**。

它帮助研发与安全分析人员：
1. **秒级识别包体技术栈**：准确区分原生 Native (Kotlin/Java) 与跨平台 (Flutter / React Native / Xamarin / Cordova / Unity)，避免在非原生包上走弯路。
2. **高质量多引擎反编译**：集成 `jadx` 与 `Fernflower/Vineflower`，兼顾资源解码与复杂 Lambda/泛型字节码的高保真还原，原生支持 XAPK 与 Split APK 分卷包。
3. **突破 R8/ProGuard 混淆**：从 Kotlin 运行时元数据 (`@DebugMetadata` 与 `@Metadata`) 自动化恢复原始类名（覆盖 100% 的 Repository / ViewModel / UseCase）。
4. **全量提取网络接口 (API)**：深度解析 Retrofit、OkHttp、Ktor (KMP)、Apollo GraphQL、硬编码 URL 及认证头、HMAC 签名算法。
5. **审计敏感凭据与泄露**：挖掘硬编码 AES 密钥、云服务 Secret、未混淆 BuildConfig 常量。
6. **标准化成果沉淀**：自动生成结构化逆向工程报告与 API 清单文档，便于团队协作与长期维护。

**核心理念**：指纹先行、严禁臆测、分层提取、证据闭环、规范沉淀。

---

## 2. 触发方式

在 Claude Code / 终端对话中输入命令：

```
/dev-decompile
```

支持直接提供目标文件路径：

```
/dev-decompile app-release.apk
/dev-decompile path/to/target.xapk
/dev-decompile libs/framework.aar
```

或自然语言提问触发：
- "帮我反编译这个 APK"
- "逆向分析这个安卓包，看看它调用了哪些接口"
- "这个混淆过的包是用什么技术写的？帮我还原一下类名"
- "提取这个 AAR 里的网络请求逻辑"

---

## 3. 工作流程概览（7 阶段）

```
阶段 1: 目标获取与环境自检  ──→ 验证输入文件，检测 Java 17+、jadx、vineflower 并引导安装
阶段 2: 包体指纹与架构侦测  ──→ 秒级探测技术栈(Flutter/RN/Native)、HTTP协议栈、混淆级别
阶段 3: 多引擎解包与反编译  ──→ 选用 jadx / fernflower / both，自动拆解 XAPK / Split APK
阶段 4: 架构剖析与关键入口  ──→ 解析 AndroidManifest 四大组件、扫描 BuildConfig 未混淆常数
阶段 5: 符号还原与调用链    ──→ 挖掘 @DebugMetadata 还原类名，追踪 UI → 业务 → 接口链路
阶段 6: 接口提取与安全审计  ──→ 提取全量 HTTP/GraphQL 接口，审计硬编码 Key 与加密算法
阶段 7: 逆向文档生成与交付  ──→ 按照 TEMPLATE.md 生成 README.md 与 API_INVENTORY.md
```

---

## 4. 详细操作步骤

### 阶段 1：目标获取与环境自检

#### 1.1 确认目标输入
支持的文件格式：
- `.apk`：标准 Android 应用包
- `.xapk` / `.apks`：包含分卷 Split APK（base + config.abi + config.locale）的安装包
- `.jar`：标准 Java 归档
- `.aar`：Android 库组件（包含 classes.jar 与资源）

#### 1.2 依赖检测
- **Windows (PowerShell)**:
  ```powershell
  & "skills/dev-decompile/scripts/check-deps.ps1"
  ```
- **Linux / macOS (Bash)**:
  ```bash
  bash skills/dev-decompile/scripts/check-deps.sh
  ```

脚本会返回：
- `[OK] Java 17+ detected`
- `[OK] jadx detected`
- `[OK] vineflower detected` (可选，复杂代码推荐)
- `[OK] dex2jar detected` (可选，配合 vineflower 解析 APK 必需)

#### 1.3 自动化安装缺失依赖
若提示缺失依赖，可一键安装：
- **Windows**:
  ```powershell
  & "skills/dev-decompile/scripts/install-dep.ps1" java
  & "skills/dev-decompile/scripts/install-dep.ps1" jadx
  & "skills/dev-decompile/scripts/install-dep.ps1" vineflower
  ```
- **Linux / macOS**:
  ```bash
  bash skills/dev-decompile/scripts/install-dep.sh java
  bash skills/dev-decompile/scripts/install-dep.sh jadx
  bash skills/dev-decompile/scripts/install-dep.sh vineflower
  ```

---

### 阶段 2：包体指纹与架构侦测

在耗费时间进行 Java 逆向前，必须执行指纹特征分析：

- **Windows (PowerShell)**:
  ```powershell
  & "skills/dev-decompile/scripts/fingerprint.ps1" <target-file>
  ```
- **Linux / macOS (Bash)**:
  ```bash
  bash skills/dev-decompile/scripts/fingerprint.sh <target-file>
  ```

#### 探测输出样例：
```text
=== APK Fingerprint: sample.apk ===

Framework:        Native Android (Kotlin + Jetpack Compose)
  Rationale:      androidx.compose.* libraries detected
Obfuscation:      HIGH (58 short root dirs)

HTTP stack:       Retrofit OkHttp
DI:               Hilt
Serialization:    kotlinx.serialization Gson
BuildConfig:      present (grep BuildConfig.java after decompile)

Third-party SDKs: Firebase AppsFlyer Sentry
Native libraries:
  lib/arm64-v8a/libcrypto.so
  lib/arm64-v8a/libapp-jni.so

Recommended next step:
  Proceed with Phase 3: decompile.ps1 sample.apk
```

#### 分流处置规则：
- **Flutter**：核心 Dart 逻辑在 `lib/<abi>/libapp.so`。jadx 只能看到 FlutterActivity 空壳。建议提示用户使用 `blutter` 或对 `libapp.so` 提取字符串。
- **React Native**：代码在 `assets/index.android.bundle`。如果包含 `libhermes.so`，说明使用了 Hermes 字节码（需使用 `hbctool` 反汇编）；若为普通 JS，直接格式化搜索。
- **Cordova / Capacitor**：代码在 `assets/www/index.html`，无需反编译 Java，直接解压查看。
- **原生应用**：进入阶段 3 正常反编译。

---

### 阶段 3：多引擎解包与反编译

运行反编译包装脚本：

- **Windows (PowerShell)**:
  ```powershell
  & "skills/dev-decompile/scripts/decompile.ps1" [OPTIONS] <file>
  ```
- **Linux / macOS (Bash)**:
  ```bash
  bash skills/dev-decompile/scripts/decompile.sh [OPTIONS] <file>
  ```

#### 常用参数说明：
| 参数 | 简写 | 含义 | 默认值 | 适用场景 |
|---|---|---|---|---|
| `-Output <dir>` | `-o` | 指定反编译产物目录 | `<文件名>-decompiled` | 自定义归档目录 |
| `-Deobf` | `--deobf` | 启用反混淆重命名（生成 `deobf-mapping.txt`） | 关 | 混淆严重的应用强烈推荐 |
| `-NoRes` | `--no-res` | 跳过资源解码，仅反编译代码 | 关 | 快速查看代码，提速 300% |
| `-Engine <jadx\|fernflower\|both>` | `--engine` | 选择反编译引擎 | `jadx` | 详见下方引擎选择策略 |

#### 引擎选择策略：
- `jadx`：速度快，内置资源解码器（解析 XML、清单），支持直接处理 APK/XAPK/AAR。
- `fernflower` (Vineflower)：在复杂的 Java 泛型、Java 8+ Stream、Lambda 表达式还原上优于 jadx。处理 APK 时会自动借助 `dex2jar` 先转换为 JAR。
- `both`：双引擎并行输出至 `jadx/` 与 `fernflower/`，末尾输出对比摘要，方便逐类对照。

---

### 阶段 4：架构剖析与关键入口识别

1. **分析 AndroidManifest.xml**（位于 `<output>/resources/AndroidManifest.xml`）：
   - 主启动 Activity：搜索 `action.MAIN` 和 `category.LAUNCHER`
   - 自定义 Application 类：提取 `android:name`
   - 组件与权限盘点
2. **扫描 BuildConfig.java**：
   - Windows:
     ```powershell
     Get-ChildItem -Path "<output>/sources" -Filter "BuildConfig.java" -Recurse | Select-String "="
     ```
   - Linux:
     ```bash
     find <output>/sources -name BuildConfig.java -exec grep -H '=' {} \;
     ```
   - 提取常数：`BASE_URL`、`FLAVOR`、`API_KEY`、调试开关等。
3. **梳理目录结构与架构分层**：
   - 区分业务代码与第三方库（例如跳过 `com/google`, `androidx`, `com/facebook` 等）。

---

### 阶段 5：Kotlin 混淆还原与调用链追踪

#### 5.1 还原真实 Kotlin 类名
在 R8 混淆后的包中，运行元数据挖掘脚本：

```bash
python skills/dev-decompile/scripts/recover-kotlin-names.py <output>/sources <output>/mapping
```

输出：
- `<output>/mapping/mapping.tsv`：制表符分隔的 `混淆全称 -> 真实全称 -> 源码文件`
- `<output>/mapping/mapping.json`：便于代码调用的 JSON 格式
- `<output>/mapping/by_package/`：按真实业务模块整理的包索引

#### 5.2 带真实符号的精准检索
使用 `lookup-name` 工具在搜索代码的同时附带真实类名注释：
```bash
python skills/dev-decompile/scripts/lookup-name.py <output>/mapping --grep '"/api/v1/' <output>/sources
```
输出效果：
```text
a/b/c.java:42:  @POST("/api/v1/auth/login")  // com.example.app.api.AuthApiService
```

#### 5.3 追踪核心业务调用链
梳理核心链路：
1. **启动初始化链**：`Application.onCreate()` → 基础网络配置 (OkHttpClient / BaseURL) → DI 容器装配
2. **用户认证链**：`LoginActivity` 按钮点击 → `ViewModel.login()` → `Repository.login()` → 网络接口调用 → 拦截器添加 Token 缓存
3. **核心数据链**：列表页面初始化 → 本地 DB 缓存命中 → 远端 API 下发刷新

---

### 阶段 6：API 接口提取与安全审计

运行接口自动提取工具：

- **Windows (PowerShell)**:
  ```powershell
  & "skills/dev-decompile/scripts/find-api-calls.ps1" <output>/sources/
  ```
- **Linux / macOS (Bash)**:
  ```bash
  bash skills/dev-decompile/scripts/find-api-calls.sh <output>/sources/
  ```

#### 专项过滤选项：
- `-Retrofit` / `--retrofit`：提取 `@GET`, `@POST`, `@Headers`, `@Query`
- `-OkHttp` / `--okhttp`：提取 `Request.Builder`, `HttpUrl`, `addInterceptor`
- `-Ktor` / `--ktor`：提取 `client.get`, `client.post`, `BearerTokens`
- `-Apollo` / `--apollo`：提取 Apollo GraphQL 查询
- `-Urls` / `--urls`：提取硬编码 `https://`, `http://`, IP 地址
- `-Paths` / `--paths`：提取形如 `"/api/v1/..."` 的接口路径字面量（在调用点被激进内联时极有效）
- `-Auth` / `--auth`：提取 Bearer Token、Authorization Header、HMAC 签名关键字

#### 敏感信息审计：
- 硬编码对称加密密钥（AES/DES Key, IV）
- 云存储凭据（AWS S3 AccessKey, 阿里云 OSS Secret）
- 微信/支付宝/第三方开放平台 AppSecret
- 内网测试服务器与 Staging 接口地址

---

### 阶段 7：逆向文档生成与交付

按照 [TEMPLATE.md](TEMPLATE.md) 生成文档并保存：

```
docs/decompile/{应用名称}/README.md          # 逆向工程综合报告
docs/decompile/{应用名称}/API_INVENTORY.md   # API 接口清单与详细规格
```

交付给用户的内容包括：
1. **反编译源码与资源目录定位**
2. **包体技术栈指纹总结**
3. **架构与关键调用流图解**
4. **接口清单统计（Tier 1 全量表 + Tier 2 高价值接口）**
5. **安全审计发现（潜在风险凭据）**
6. **后续分析或动态抓包指引**

---

## 5. 常见问题与解决方案 (FAQ)

### Q1: jadx 反编译大包时出现 `OutOfMemoryError`？
**解决方式**：增加 Java 堆内存，例如：
```bash
jadx -Xmx8g -d output app.apk
```
或在 PowerShell 中临时设置：
```powershell
$env:JAVA_OPTS = "-Xmx8g"
```

### Q2: 反编译出来的源码很少（只有十几个类），没有实际业务逻辑？
**原因**：这通常是一个 XAPK 分卷包或 Bundle 壳 APK（真实的逻辑在 `base.apk` 或其他 split 分卷中）。
**解决方式**：`decompile.ps1` 和 `decompile.sh` 已内置自动检测机制。如果检测到此类情况，会自动重新定位并解包内部的 `base.apk`。请检查 `<output>/base/sources/` 目录。

### Q3: 代码混淆严重，类名全是 `a.b.c` 怎么办？
**解决方式**：
1. 反编译时加上 `--deobf` 参数，jadx 会重命名类和方法为唯一标识符。
2. 针对 Kotlin 应用，运行阶段 5 的 `recover-kotlin-names.py`，从元数据中还原 100% 的 Repository 和 ViewModel 原始名称。

### Q4: 指纹检测出应用是 Flutter 或 React Native？
**解决方式**：
- 不要死磕 Java 反编译。Java 只是一个容器 Activity。
- **Flutter**：使用 `blutter` 分析 `lib/<abi>/libapp.so`，或通过 `strings` 命令提取字符串和 URL。
- **React Native**：解压查看 `assets/index.android.bundle`，配合 `hbctool` 查看 Hermes 字节码。
