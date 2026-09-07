# 逆向工程与接口分析报告模板

本模板用于指导逆向工程产物归档。分析完成后，请按照以下结构生成规范文档，并保存至：
- `docs/decompile/{应用名称}/README.md`（逆向工程综合报告）
- `docs/decompile/{应用名称}/API_INVENTORY.md`（API 接口规格清单）

根据实际包体情况可适度裁剪或合并章节，**严禁编造不存在的逻辑或未找到的接口**。无法确定的项明确标注 `【代码中未发现】` 或 `【待抓包验证】`。

---

# 模版一：逆向工程综合报告 (`README.md`)

```markdown
# 逆向工程分析报告：{应用名称 / 包名}

- **分析时间**：{YYYY-MM-DD HH:mm}
- **目标文件**：`{目标文件名.apk / .xapk}`
- **反编译引擎**：jadx {版本} / Vineflower {版本}
- **反编译源码路径**：`{decompiled-dir}/sources/`

---

## 1. 包体基础信息与指纹

| 项目 | 详情 | 备注 |
|---|---|---|
| **应用包名 (Package Name)** | `com.example.app` | 来自 AndroidManifest.xml |
| **版本名称 (Version Name)** | `1.0.0` | 来自 AndroidManifest.xml |
| **版本代码 (Version Code)** | `100` | 来自 AndroidManifest.xml |
| **最低支持 SDK (minSdkVersion)** | `24 (Android 7.0)` | |
| **目标 SDK (targetSdkVersion)** | `34 (Android 14)` | |
| **核心技术栈 (Framework)** | 原生 Kotlin + Jetpack Compose | 或 Flutter / React Native 等 |
| **网络协议栈 (HTTP Stack)** | Retrofit 2 + OkHttp 4 | |
| **混淆状态 (Obfuscation)** | 高混淆 (R8) / 低混淆 / 未混淆 | 单字母包名占比 |
| **符号还原率** | 约 42% (核心 Repository/ViewModel 100% 还原) | 见 mapping/ 目录 |

### 原生动态库 (.so 架构)
- `arm64-v8a`: `libnative-lib.so`, `libcrypto.so`, `...`
- `armeabi-v7a`: `...`

### 第三方 SDK 清单
- **基础支撑**：Firebase Analytics, Crashlytics
- **风控/推送**：AppsFlyer, Sentry, JPush
- **业务/支付**：WeChat Pay, Alipay, Stripe

---

## 2. 架构概览与核心组件

### 2.1 整体架构设计
- **架构模式**：MVVM + Clean Architecture / MVI / MVP
- **分层特征**：
  - `presentation` / `ui`：界面展示与 ViewModel 状态管理
  - `domain`：业务用例 (UseCases / Interactors)
  - `data`：数据仓储 (Repository)、本地数据库 (Room/SQLDelight)、远程网络源

### 2.2 核心组件清单
- **自定义 Application**：`com.example.app.MainApplication`
  - *初始化行为*：初始化 OkHttp 拦截器、初始化 DI (Hilt/Koin)、注册推送
- **主启动 Activity**：`com.example.app.ui.MainActivity`
- **主要 Activity**：
  - `com.example.app.ui.login.LoginActivity` — 登录认证
  - `com.example.app.ui.home.HomeActivity` — 首页信息流
- **核心 Service / Receiver**：
  - `com.example.app.service.PushService` — 推送接收

### 2.3 关键权限列表
- `android.permission.INTERNET`：网络访问
- `android.permission.ACCESS_FINE_LOCATION`：精确地理位置

---

## 3. 敏感信息与配置审计

### 3.1 BuildConfig 常量泄漏
在 `BuildConfig.java` 中提取的环境变量与常量：
- `DEBUG`: `false`
- `BUILD_TYPE`: `release`
- `FLAVOR`: `production`
- `BASE_URL`: `https://api.example.com/v2/`
- `BUGLY_APP_ID`: `90000xxxx`

### 3.2 硬编码密钥与敏感凭证
> [!WARNING]
> 以下为源码中提取的硬编码信息，需关注安全风险：

| 类型 | 键名/标识 | 提取值/样例 | 所在文件与行号 | 风险等级 |
|---|---|---|---|---|
| AES 密钥 | `AES_KEY` | `4f8a9b...` (16 bytes) | `CryptoUtil.java:23` | **高危 (硬编码对称密钥)** |
| 第三方 Key | `MAP_API_KEY` | `AIzaSy...` | `AndroidManifest.xml:58` | 中危 |
| 测试环境域名 | `TEST_SERVER` | `https://staging-api.internal/` | `Config.java:12` | 低危 |

---

## 4. 关键业务调用链分析

### 4.1 用户登录认证调用链
```text
LoginActivity (用户点击登录按钮)
   ↓ 触发
LoginViewModel.login(username, password)
   ↓ 调用
LoginRepositoryImpl.authenticate(credentials)
   ↓ 转换 / 数据包装
AuthApiService.login(@Body LoginRequest)  [POST /api/v1/auth/login]
   ↓ 拦截器处理 (AuthInterceptor 添加 Device-ID 与 Timestamp 签名)
OkHttpClient.newCall().execute()
   ↓ 收到响应 (LoginResponse: token, refreshToken)
TokenManager.saveToken(token) (写入 EncryptedSharedPreferences)
```

### 4.2 核心业务数据加载流程
```text
HomeFragment / HomeComposable
   ↓ 观察 StateFlow
HomeViewModel.fetchFeedList()
   ↓
FeedRepository.getFeeds(page, limit)
   ↓ 先读本地缓存
FeedDao.queryRecent()
   ↓ 远端拉取更新
FeedApiService.getFeedList(page, limit)  [GET /api/v1/feeds]
   ↓ 写入数据库
FeedDao.insertAll(feeds)
```

---

## 5. 后续建议与逆向深入方向

1. **抓包验证**：由于应用启用了证书锁定（Certificate Pinning），建议配合 Frida 脚本 `ssl-unpinning.js` 进行动态流量抓取。
2. **符号对照**：已生成 `mapping/mapping.tsv`，阅读代码时若遇 `a.b.c.d` 类，可在映射表中检索对应的原始名称。
3. **接口调试**：完整 API 列表见 [API_INVENTORY.md](API_INVENTORY.md)。
```

---

# 模版二：API 接口清单与规格 (`API_INVENTORY.md`)

```markdown
# API 接口规格清单：{应用名称}

本文档记录从安装包中提取的全量 HTTP/WebSocket/GraphQL 接口，分为：
- **Tier 1：全量端点速览表格**（快速检索所有接口）
- **Tier 2：核心高价值端点详细规格**（认证、支付、核心业务等深度分析）

---

## Tier 1：全量接口速览清单

| 序号 | 协议/Host | Method | 路径 (Path) | 鉴权方式 | 说明/功能 | 声明源文件 |
|---|---|---|---|---|---|---|
| 1 | `api.example.com` | POST | `/v1/auth/login` | None | 用户账号密码登录 | `AuthApi.java:15` |
| 2 | `api.example.com` | POST | `/v1/auth/refresh` | RefreshToken | 刷新访问令牌 | `AuthApi.java:22` |
| 3 | `api.example.com` | GET | `/v1/users/profile` | Bearer Token | 获取当前用户信息 | `UserApi.java:18` |
| 4 | `api.example.com` | GET | `/v1/feeds` | Bearer Token | 获取首页推荐信息流 | `FeedApi.java:30` |
| 5 | `api.example.com` | POST | `/v1/orders/create` | Bearer + HMAC | 创建订单 | `OrderApi.java:45` |
| 6 | `upload.example.com`| POST | `/v1/media/upload` | Bearer Token | 文件图片上传 | `UploadApi.java:12`|

*(共提取发现 N 个端点)*

---

## Tier 2：核心高价值接口详述

### 1. `POST /v1/auth/login` — 账号登录

- **接口定位**：用户身份验证与 Token 获取
- **接口源码**：`com.example.api.AuthApi.login` (`AuthApi.java:15`)
- **Base URL**：`https://api.example.com`
- **认证方式**：无需鉴权 (Public)
- **请求头 (Headers)**：
  - `Content-Type`: `application/json`
  - `X-App-Version`: `1.0.0`
  - `X-Device-ID`: `{设备指纹}`
- **请求参数 (Body)**：
  ```json
  {
    "username": "string",
    "password": "string(md5/sha256)",
    "captcha_token": "string (可选)"
  }
  ```
- **响应体 (Response)**：
  ```json
  {
    "code": 200,
    "message": "success",
    "data": {
      "access_token": "string (JWT)",
      "refresh_token": "string",
      "expires_in": 7200,
      "user_id": 123456
    }
  }
  ```
- **调用入口**：`LoginActivity → LoginViewModel.login() → UserRepositoryImpl → AuthApi`

---

### 2. `POST /v1/orders/create` — 订单创建

- **接口定位**：业务核心下单接口，包含自定义请求签名保护
- **接口源码**：`com.example.api.OrderApi.createOrder` (`OrderApi.java:45`)
- **Base URL**：`https://api.example.com`
- **认证方式**：`Authorization: Bearer <access_token>`
- **请求头 (Headers)**：
  - `X-Signature`: `{HMAC-SHA256(Body + Timestamp + AppSecret)}`
  - `X-Timestamp`: `1710000000`
- **请求参数 (Body)**：
  ```json
  {
    "sku_id": "string",
    "quantity": 1,
    "coupon_id": "string (可选)",
    "shipping_address_id": "string"
  }
  ```
- **签名算法还原**：
  位于 `com.example.net.SignInterceptor`：
  `Signature = Hex(HmacSHA256(Path + "\n" + Body + "\n" + Timestamp, "secret_key_xxxx"))`
- **调用入口**：`CheckoutActivity → CheckoutViewModel.submit() → OrderRepository → OrderApi`
```
