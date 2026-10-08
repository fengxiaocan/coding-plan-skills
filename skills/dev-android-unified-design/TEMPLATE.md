# Android UI 设计系统对齐与交付核对模板

本模板用于在使用 `dev-android-unified-design` 完成 Android 页面创建、重构、组件封装或视觉审查后，生成规范化的交付报告与核对清单。

---

# [页面/模块名称] UI 设计规范对齐报告

## 1. 模块基本信息

- **页面/组件名称**：`[例如：NetworkSpeedScreen / AppPrimaryButton]`
- **目标源文件**：`[例如：ui/features/speed/NetworkSpeedScreen.kt]`
- **界面职责**：`[简要说明该页面或组件在应用中的核心定位与业务功能]`
- **交互类型**：`[全屏页面 / 底部弹窗 BottomSheet / 确认弹窗 Dialog / 独立通用组件]`

---

## 2. 界面信息架构与组件复用清单

### 2.1 内容层级树状图
```text
TopBar: [AppTopBar] 页面标题 + 导航操作
 ↓
核心展示区: [AppCard] 仪表盘 / 核心状态卡片
 ↓
主要操作区: [AppPrimaryButton] 核心操作按钮 (48dp 恒定高度)
 ↓
功能配置区: [AppSection] 标题 + [AppCard] (多个 AppListItem + 1dp AppDivider)
 ↓
次要说明: [Text - AppTypography.bodySmall] 辅助合规与版本信息
```

### 2.2 复用组件对照表
| 界面视觉元素 | 复用公共组件 | 参数配置 | 是否新建组件 |
|-------------|-------------|---------|-------------|
| 顶部导航栏 | `AppTopBar` | `title = "网络测速", onBack = { ... }` | 否（复用） |
| 开始测试按钮 | `AppPrimaryButton` | `size = Medium, text = "开始测速"` | 否（复用） |
| 设置分组容器 | `AppSection` + `AppCard` | `title = "高级设置"` | 否（复用） |
| WLAN 开关项 | `AppListItem` | `trailing = { AppSwitch(...) }` | 否（复用） |
| 确认放弃弹窗 | `AppConfirmDialog` | 双按钮横向/小屏纵向自适应 | 否（复用） |

---

## 3. Design Tokens 对齐表

| 设计维度 | 规范要求 | 实际代码应用 | 校验结果 |
|---------|---------|-------------|---------|
| **Typography** | 页面字体不超过 3~4 种；字重克制 | `AppTypography.titleLarge`, `bodyMedium`, `labelLarge` | ✅ 符合 |
| **Grid 间距** | 4dp 栅格体系 (8/12/16/20/24dp) | 外边距 16dp，卡片间距 24dp，元素间距 12dp | ✅ 符合 |
| **圆角分级** | 严格遵循 8/12/16/20/Full 体系 | Card 16dp, 输入框 12dp, 按钮 12dp | ✅ 符合 |
| **色彩语义** | 严禁硬编码色彩，兼容 Dark Mode | 全部引用 `MaterialTheme.colorScheme.*` 语义颜色 | ✅ 符合 |
| **按钮高度** | Large 52dp / Medium 48dp / Small 36dp | 统一采用 `AppDimensions.buttonHeightMedium (48dp)` | ✅ 符合 |
| **触控区域** | 所有可点击元素尺寸 ≥ 48×48dp | 所有图标按钮统一包裹于 48dp 靶心容器中 | ✅ 符合 |

---

## 4. 极端场景与弹性测试核对表

- [ ] **按钮防折行测试**：
  - [ ] 按钮声明了 `maxLines = 1`, `softWrap = false`, `overflow = TextOverflow.Ellipsis`
  - [ ] 按钮文字长度控制在 2~6 个汉字以内，无多余冗长描述
  - [ ] 按钮未因文本过长或字体放大导致高度由 48dp 变为 70dp+
- [ ] **屏幕尺寸测试**：
  - [ ] `320dp` 极小屏幕：横向操作栏自适应换行或纵向单列排列，无水平溢出破损
  - [ ] `360dp ~ 411dp` 主流屏幕：布局留白协调，符合 16dp 边距
  - [ ] `600dp+` 平板与大屏：核心内容区限制了最大宽度（如 600dp / 840dp），居中排布
- [ ] **系统字体缩放测试**：
  - [ ] 在 `130%` 和 `150%` 字体放大比例下，主要功能正常可用，容器无死锁重叠
- [ ] **长文本截断测试**：
  - [ ] 页面大标题最多 1 行，列表副标题最多 2 行，描述文案最多 3 行
- [ ] **深色模式（Dark Mode）**：
  - [ ] 深浅模式切换时，文字与背景对比度清晰，无不可读的死黑/死白

---

## 5. 审查结论与交付说明

### 核心亮点
- `[例如：消除了旧页面中 14 处硬编码 Magic Number，统一对齐至 AppDimensions]`
- `[例如：重构了横向按钮 Row，增加了小屏空间不足时的权重自适应与防折行策略]`

### 待后续支持/待确认项
- `【待确认】[如有跨模块公共组件待抽离或服务端下发长文案待产品确认]`
