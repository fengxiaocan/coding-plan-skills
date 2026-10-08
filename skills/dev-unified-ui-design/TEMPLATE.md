# 跨平台统一 UI 设计系统对齐与交付核对模板

本模板用于在使用 `dev-unified-ui-design` 完成跨平台页面创建、UI 重构、公共组件封装或设计规范审查后，生成标准化的交付报告与验收核对清单。

---

# [页面/模块名称] 统一 UI 设计规范对齐报告

## 1. 模块基本信息

- **页面/组件名称**：`[例如：SettingsPage / AppPrimaryButton / UserProfileScreen]`
- **覆盖平台**：`[Web / iOS / Android / Desktop (macOS/Win/Linux) / Flutter / React Native / Compose]`
- **目标源文件**：`[例如：src/views/settings/SettingsPage.tsx / lib/pages/settings_page.dart]`
- **界面核心职责**：`[简要说明该页面或组件在应用中的核心定位与业务功能]`
- **交互类型**：`[全屏页面 / 模态弹窗 Dialog / 抽屉 Drawer / 底部面板 BottomSheet / 独立公共组件]`

---

## 2. 界面信息架构与组件复用清单

### 2.1 内容层级树状结构
```text
Page Header: [PageHeader] 标题 + 辅助描述 + 顶部辅助操作
 ↓
核心状态区: [AppCard] 仪表盘 / 当前核心状态高亮
 ↓
主要操作区: [PrimaryButton] 核心行为主操作 (恒定高度，防换行)
 ↓
分组内容区: [SectionGroup] Section Title + [AppCard] (多个 ListItem + 1px/1dp Divider)
 ↓
辅助操作/页脚: [Footnote / SecondaryButton] 次要说明、隐私与合规信息
```

### 2.2 复用组件对照表
| 界面视觉元素 | 复用公共组件 | 参数与 Variant 配置 | 是否新建组件 |
|-------------|-------------|-------------------|-------------|
| 顶部导航栏 | `AppHeader / PageShell` | `title = "系统设置", showBack = true` | 否（复用） |
| 保存修改按钮 | `PrimaryButton` | `size = "medium", text = "保存设置"` | 否（复用） |
| 危险重置操作 | `DangerButton` | `size = "medium", text = "重置全部"` | 否（复用） |
| 设置分组容器 | `AppSection` + `AppCard` | `title = "通知偏好"` | 否（复用） |
| 通知开关列表项 | `AppListItem` | `leading = Icon, trailing = AppSwitch` | 否（复用） |
| 账号输入框 | `AppTextField` | `label = "用户名", helperText = ...` | 否（复用） |
| 放弃修改弹窗 | `AppConfirmDialog` | 双操作横向，小屏自适应转纵向 | 否（复用） |

---

## 3. Design Tokens 对齐表

| 设计维度 | 规范要求 | 实际代码应用 | 校验结果 |
|---------|---------|-------------|---------|
| **Typography** | 页面字体等级 ≤ 3~5 种；字重克制（Bold 仅限核心数据） | 全部引用 `Typography.titleLarge`, `bodyMedium`, `labelLarge` | ✅ 符合 |
| **Grid 间距** | 4 / 8 基础栅格体系 (8/12/16/20/24/32) | 移动端 Padding 16，桌面端 24，Section 间距 24，元素间距 12 | ✅ 符合 |
| **圆角分级** | 严格遵循 4/8/12/16/20/Full 5 级体系 | Card 16，Button 12，Dialog 20，Avatar Full | ✅ 符合 |
| **色彩语义** | 严禁硬编码色彩，全平台语义一致，兼容 Dark Mode | 全部引用 `Colors.surface`, `Colors.textPrimary`, `Colors.success` | ✅ 符合 |
| **按钮高度** | Large 48~52 / Medium 40~44 / Small 32~36 恒定高度 | 统一采用 Medium (44px/dp)，不随文字长度改变高度 | ✅ 符合 |
| **触控区域** | 所有可交互元素触控尺寸 ≥ 40×40（推荐 44~48） | 图标按钮触控盒限制为 44×44，中心居中放置 20px 图标 | ✅ 符合 |
| **最大宽度** | 超宽屏内容区受控（标准 1200~1440，表单 640~840） | 表单容器设置 `max-width: 720px; margin: 0 auto;` | ✅ 符合 |
| **分割线** | 统一 1px/1dp Hairline 分割线与 Divider Token | 统一采用 `Divider(thickness = 1px, color = Colors.divider)` | ✅ 符合 |

---

## 4. 极端场景与弹性测试核对表

- [ ] **按钮防折行与自适应测试**：
  - [ ] 按钮声明了防换行属性（`white-space: nowrap` / `maxLines = 1, softWrap = false`）
  - [ ] 按钮文字精简为“动词 + 对象”（2~6 个汉字），无冗长叙述
  - [ ] 空间不足时遵循优先级：缩短文案 > 扩宽 > 转为纵向 Column > 缩减 Padding > 省略号 Ellipsis
  - [ ] 按钮未因文本过长或字体放大出现多行折行或高度突增
- [ ] **多屏幕与多端断点测试**：
  - [ ] `320px` 极窄屏：横向按钮自动切换为纵向堆叠，列表标题单行省略，无水平横向破版
  - [ ] `Compact (<600)`：单栏流式，主要操作清晰
  - [ ] `Medium (600~839)`：适度双栏与宽内容区
  - [ ] `Expanded / Large (≥840)`：侧边栏排布与 Master-Detail，核心内容区限制最大宽度
  - [ ] 低高度窗口（600/720px）：Dialog 与底部 Action 操作区不被遮挡
- [ ] **系统字体与浏览器缩放测试**：
  - [ ] 在 `125%` 与 `150%` 字体放大比例下，正文自然向下延伸，关键操作与导航容器无重叠破损
  - [ ] 在浏览器 `80%` ~ `150%` 页面缩放比例下，响应式网格平稳重排
- [ ] **遮挡防御与边界安全**：
  - [ ] 处理 Safe Area（Notch、系统状态栏、手势底条、窗口控制按钮）
  - [ ] 移动端输入框聚焦弹出软键盘时，当前输入项自适应 Scroll Into View
  - [ ] 滚动视图末尾预留了 BottomBar 高度与安全边距，最后一项内容未被悬浮操作栏遮挡
  - [ ] Dropdown 与 Tooltip 在屏幕边缘时自动向上反转或重新定位，未被视口截断
- [ ] **横向挤压优先级（Shrink Priority）**：
  - [ ] 横向容器遵循：Fixed Icon → Flexible Text (Ellipsis) → Fixed Action
  - [ ] 列表右侧的 Switch 开关或 Chevrons 未被长标题挤出视口
- [ ] **状态完整性与 Layout Shift**：
  - [ ] 所有交互控件具备明确的 Hover、Focus、Pressed、Disabled 状态
  - [ ] Loading 态与骨架屏尺寸与最终内容对齐，无跳动式 Layout Shift
  - [ ] 深浅模式切换时对比度符合无障碍标准，无死黑/死白

---

## 5. 17 项全票通过法则（Final Acceptance Checklist）

UI 只有在全部满足以下 17 项标准时方可视为交付完成：

- [ ] 1. 视觉与排版统一：字号、行高全部来源于单一 Typography Token
- [ ] 2. 颜色统一：全部使用语义色彩，状态色语义全端一致
- [ ] 3. 按钮统一：尺寸分级恒定，文字单行不换行，空间不足按标准梯次处理
- [ ] 4. 组件统一：无临时私造组件，全部复用 Foundation 组件
- [ ] 5. 间距统一：严格对齐 4/8 栅格，无异构 Magic Number
- [ ] 6. 响应式正常：不同分辨率与窗口尺寸下自适应排版
- [ ] 7. 小屏不破版：320px 窄屏无水平溢出破损
- [ ] 8. 大屏不失控：超宽屏内容区域设置合理最大宽度
- [ ] 9. 字体放大不重叠：150% 字体缩放下正文自适应且关键控件不锁死
- [ ] 10. 按钮高度不失控：不随文字折行，高度始终恒定
- [ ] 11. 内容不被遮挡：无 Header/Footer/Floating 元素遮挡正文
- [ ] 12. 弹窗不超出屏幕：超出时 Header/Footer 固定，中间滚动
- [ ] 13. 导航不遮挡操作：底部栏与滚动列表预留充足 Padding 避让
- [ ] 14. 键盘不遮挡输入：聚焦输入框自动进入可视区
- [ ] 15. 下拉与浮层不被裁剪：Dropdown/Tooltip 自适应视口边界
- [ ] 16. Dark Mode 表现正常：深浅主题切换对比度达标
- [ ] 17. 跨平台体验一致：在不同系统下保持相同产品的品牌与视觉语义

---

## 6. 审查结论与交付说明

### 核心亮点
- `[例如：消除了原页面中 23 处硬编码 Magic Number，全部对齐至 Design Tokens]`
- `[例如：统一了 Dialog 和 BottomSheet 在小屏下的双按钮纵向自适应机制]`
- `[例如：为超宽桌面端配置了 840px 表单居中最大宽度，彻底解决大屏拉伸失真]`

### 待后续支持/待产品确认项
- `【待确认】[如有跨端平台特定功能或服务端下发超长国际化文案待产品确认]`
