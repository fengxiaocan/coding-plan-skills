# Dev Decompile — Android 反编译与逆向工程工作流

本 Skill 用于 **Android 安装包 (APK/XAPK) 及 Java/Android 依赖库 (JAR/AAR) 的自动化反编译、架构分析、混淆还原、业务调用链追踪与 HTTP API 接口提取**，并将逆向产物与分析结论结构化沉淀至项目文档。

---

## 触发命令

在 Claude Code / 终端对话中输入：

```
/dev-decompile
```

或直接附加安装包路径：

```
/dev-decompile path/to/app.apk
/dev-decompile path/to/app-bundle.xapk
/dev-decompile path/to/library.aar
```

或自然语言触发：
- "反编译这个 APK"
- "逆向分析这个安卓应用"
- "提取这个包里的所有 HTTP 接口"
- "分析该 APK 的架构和调用链"
- "还原这个混淆包里的 Kotlin 代码"

---

## 核心能力

| 能力 | 说明 |
|---|---|
| **指纹先行 (Phase 0 Triage)** | 秒级探测包体架构（Flutter / React Native / Cordova / Xamarin / 原生 Kotlin & Compose），探测 HTTP 栈、混淆级别、原生 `.so` 库，避免在非原生包上盲目反编译 |
| **多引擎解包反编译** | 支持 `jadx`（通用、带资源解码）与 `Fernflower/Vineflower`（复杂泛型/Lambda更高质量），支持 `both` 双引擎并行比对，原生支持 XAPK 拆解与 Split APK 自动重定向 |
| **Kotlin 混淆还原** | 针对 R8 强混淆的 Kotlin 应用，利用 `@DebugMetadata` 与 `@Metadata` 恢复原始 `*Repository` / `*ViewModel` / `*UseCase` 真实类名 |
| **API 接口深度提取** | 支持 Retrofit 注解、OkHttp 客户端、Ktor (KMP)、Apollo GraphQL 以及硬编码 URL / IP 提取，自动梳理认证鉴权 (Bearer / HMAC 签名) |
| **业务调用链追踪** | 贯穿 Android 四大组件、UI 监听事件、ViewModel、Repository 至底层网络请求的端到端调用流 |
| **敏感凭据安全审计** | 自动扫描硬编码密钥（AES/RSA/DES 密钥与 IV）、云服务 Secret（AWS/阿里云/Firebase）、内网测试域名与调试开关 |
| **规范化文档沉淀** | 按模板统一沉淀输出至 `docs/decompile/{应用名称}/` 目录下，形成长期可查的逆向工程报告 |

---

## 工作流程

```
[输入安装包]
    │
    ▼
【阶段 1: 目标获取与环境自检】 ── 检查 Java 17+、jadx、vineflower，缺失时支持一键自动安装
    │
    ▼
【阶段 2: 包体指纹与架构侦测】 ── 识别技术栈（Flutter/RN/Native），非原生包精准分流
    │
    ▼
【阶段 3: 多引擎解包与反编译】 ── jadx / vineflower / both 引擎反编译，自动处理 XAPK / Bundle
    │
    ▼
【阶段 4: 架构剖析与关键入口】 ── 解析 AndroidManifest 四大组件、BuildConfig 未混淆常量与架构
    │
    ▼
【阶段 5: 符号还原与调用链】   ── Kotlin 元数据恢复(@DebugMetadata)，梳理 UI → 业务 → 接口调用链
    │
    ▼
【阶段 6: 接口提取与安全审计】 ── 扫描全量 API（Tier 1 表格 + Tier 2 重点详述）、审计硬编码密钥
    │
    ▼
【阶段 7: 逆向文档生成与交付】 ── 按照 TEMPLATE.md 生成 README.md 与 API_INVENTORY.md
```

详细操作手册见 [USAGE.md](USAGE.md)，文档模板见 [TEMPLATE.md](TEMPLATE.md)。

---

## 目录结构

```
skills/dev-decompile/
├── SKILL.md            # 技能定义（Claude Code / AI 规范指令与流程）
├── README.md           # 本文件：快速概览与入口
├── USAGE.md            # 使用指南：详细操作步骤、多平台命令与常见问题
├── TEMPLATE.md         # 逆向工程分析报告与 API 清单输出模板
├── scripts/            # 跨平台自动化工具脚本（PowerShell + Bash + Python）
│   ├── check-deps.ps1 / .sh          # 依赖环境检测
│   ├── install-dep.ps1 / .sh         # 依赖一键安装
│   ├── decompile.ps1 / .sh           # 多引擎反编译包装器
│   ├── fingerprint.ps1 / .sh         # 技术栈与指纹秒级探测
│   ├── find-api-calls.ps1 / .sh      # 接口与硬编码扫描器
│   ├── recover-kotlin-names.py / .ps1 / .sh # Kotlin 混淆元数据还原
│   └── lookup-name.py / .ps1 / .sh   # 映射反查与代码标注检索
└── references/         # 逆向工程参考手册与规则库
    ├── setup-guide.md                # 依赖手动安装与排障指南
    ├── jadx-usage.md                 # jadx 命令行高级选项
    ├── fernflower-usage.md           # Fernflower / Vineflower 高级用法
    ├── api-extraction-patterns.md    # 网络库匹配模式与规则
    ├── call-flow-analysis.md         # 调用链分析与追踪策略
    ├── kotlin-name-recovery.md       # Kotlin R8 混淆还原原理解析
    └── third_party_hosts.txt         # 常见第三方 SDK 域名白名单/黑名单
```
