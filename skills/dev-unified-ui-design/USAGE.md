# Dev Unified UI Design 使用指南

## 1. 概述与核心设计哲学

`dev-unified-ui-design` 是一套面向所有跨平台项目（Web、iOS、Android、Windows、macOS、Linux、Flutter、React Native、Compose Multiplatform、Electron、Tauri 等）的系统化 UI/UX 设计、开发与规范落地工作流。

### 核心设计哲学
1. **页面只负责组织内容，设计系统负责决定内容长什么样**：业务页面严禁自行捏造样式。所有字号、颜色、间距、圆角、高度必须来自全局 Design Tokens。
2. **同一种组件，全端同一语义**：在所有页面和所有平台上，同一种组件必须保持相同的视觉语义、尺寸体系、交互逻辑和信息层级。
3. **抗脆弱自适应**：界面必须在 320px 窄屏、4K 超宽屏、150% 系统字体放大、超长国际化文案及软键盘弹出时依然保持稳健不破版。

---

## 2. 触发方式与交互场景

### 命令行触发
```bash
/dev-unified-ui-design
```

### 典型任务交互指令
```bash
# 场景 1：新页面开发（遵循信息层级与响应式布局）
/dev-unified-ui-design 实现一个跨平台设置页面，包含用户基础信息、通知设置分组、数据同步开关和底部危险操作区

# 场景 2：治理现有混乱页面（消除 Magic Number 与组件统一）
/dev-unified-ui-design 重构 DashboardView，清理所有裸写 13px/17px 与硬编码颜色，改用 Design System 标准 Card 与 ListItem

# 场景 3：基础组件库基建
/dev-unified-ui-design 搭建跨平台 Button 和 Dialog 组件，支持 Primary/Secondary/Danger 变体，并在小屏下自动处理防折行与纵向自适应

# 场景 4：边界与无障碍弹性修复
/dev-unified-ui-design 审查并修复登录页面在移动端键盘弹出时的输入框遮挡问题，以及 150% 字体放大下的按钮高度异常拉伸
```

---

## 3. 跨平台 Design System 推荐项目结构

无论使用哪种前端或跨端技术栈，均建议建立清晰的分层结构：

```text
design-system/
├── tokens/               # 跨端基础设计变量
│   ├── colors.ts / .dart / .kt       # 语义色彩体系 (Brand, Surface, Text, State)
│   ├── typography.ts / .dart / .kt   # 字体排版体系 (Display, Headline, Title, Body, Label)
│   ├── spacing.ts / .dart / .kt      # 4/8 基础栅格间距体系
│   ├── radius.ts / .dart / .kt       # 5 级圆角体系 (XS, Small, Medium, Large, XLarge, Full)
│   ├── sizes.ts / .dart / .kt        # 控件尺寸体系 (Button, Input, Touch Target)
│   ├── elevation.ts / .dart / .kt    # 阴影与层级体系
│   ├── breakpoints.ts / .dart / .kt  # 响应式断点体系
│   └── z-index.ts / .dart / .kt      # 统一层叠上下文体系
│
├── components/           # Foundation 基础组件库
│   ├── Button/           # 主/次/线框/文本/危险按钮
│   ├── IconButton/       # 40/44/48 触控标准图标按钮
│   ├── TextField/        # 统一高度单行输入框、多行文本域
│   ├── Card/             # 标准分组与状态容器卡片
│   ├── Dialog/           # 响应式弹窗（Header/Content/Footer 三段式）
│   ├── BottomSheet/      # 移动端底部抽屉
│   ├── ListItem/         # 标准列表项与设置项（Leading + Text + Trailing）
│   ├── Table/            # 响应式表格与列宽优先级
│   ├── Tabs/             # 单行固定高选项卡
│   ├── Chip/             # 紧凑标签与筛选器
│   ├── Navigation/       # 顶部 Header、侧边栏 Sidebar、底部导航 BottomNav
│   ├── Divider/          # 1px/1dp 语义分割线
│   └── Feedback/         # Snackbar, Toast, Loading, EmptyState, ErrorState
│
└── layouts/              # 响应式布局容器
    ├── PageShell/        # 统一页面外壳（处理 Safe Area、Header 与滚动容器）
    ├── Section/          # 标准区块（Title + Description + 间距）
    └── AdaptiveLayout/   # Compact / Medium / Expanded 断点自适应容器
```

---

## 4. 全局 Design Tokens 标准参考

### 4.1 4 / 8 基础网格间距体系 (Spacing)

所有页面间距必须从网格 Token 中选取，严禁出现奇数与未定义数字：

| Token | 数值 (px/dp) | 推荐使用场景 |
|-------|------------|-------------|
| `Spacing.micro` | 2 | 极小视觉对齐微调、文字与角标微移 |
| `Spacing.xs` | 4 | 紧凑元素内边距、图标与文字紧凑间隙 |
| `Spacing.sm` | 8 | 元素内部标准间隙、小控件内边距 |
| `Spacing.compact` | 12 | 紧凑表单间距、关联元素间距 |
| `Spacing.md` | 16 | **全局基础步长**：页面默认外边距、Card 标准内边距、列表项横向边距 |
| `Spacing.comfortable` | 20 | 重点卡片内边距、中等模块留白 |
| `Spacing.lg` | 24 | **Section 区块留白**、桌面端页面外边距、弹窗内边距 |
| `Spacing.xl` | 32 | 大区块留白、大弹窗外边距 |
| `Spacing.2xl` | 40 | 页面首屏头部留白 |
| `Spacing.3xl` | 48 | 超大区块间距、标准触控最小高 |
| `Spacing.section` | 64 | 桌面端大篇章分割留白 |

### 4.2 圆角分级体系 (Radius)

全项目严格限制在 **最多 5 级圆角**：

| Token | 数值 (px/dp) | 适用组件 |
|-------|------------|---------|
| `Radius.xs` | 4 | 极小微标签、数值 Badge、紧凑 Tooltip |
| `Radius.sm` | 8 | Chip 筛选标签、小按钮、代码块容器 |
| `Radius.md` | 12 | **标准控件圆角**：TextField 输入框、Button 按钮、Dropdown 浮层 |
| `Radius.lg` | 16 | **内容容器圆角**：Card 卡片、Modal 浮层面板 |
| `Radius.xl` | 20 ~ 24 | **重量级面板圆角**：Dialog 对话框、BottomSheet 底部面板上圆角 |
| `Radius.full` | 9999 | Avatar 头像、圆形图标按钮、Pill 状态胶囊 |

### 4.3 Typography 字体体系

整个项目只能维护一套 Typography，单个页面常规字体等级建议最多出现 **3~5 种**：

| Token | 字号 (px/sp) | 行高 | 推荐字重 | 使用场景 |
|-------|-------------|------|---------|---------|
| `Display.large` | 32 ~ 40 | 1.2x | SemiBold | 桌面端极度突出的大标题、核心数据主指标 |
| `Headline.large` | 28 ~ 32 | 1.25x | SemiBold | 页面一级主标题、登录注册大标题 |
| `Headline.medium`| 24 ~ 28 | 1.3x | Medium / SemiBold | 模块主标题、模态大弹窗标题 |
| `Title.large` | 20 ~ 22 | 1.35x | Medium / SemiBold | 移动端页面标题、核心卡片标题 |
| `Title.medium` | 18 | 1.4x | Medium | 标准弹窗标题、Section 区块大标题 |
| `Title.small` | 16 | 1.4x | Medium | 子模块标题、列表项粗体标题 |
| `Body.large` | 16 | 1.5x | Regular | 重点正文、常规列表主文本 |
| `Body.medium` | 14 | 1.5x | Regular | **全局基准正文**：标准表单内容、说明段落 |
| `Body.small` | 12 | 1.5x | Regular | 辅助次要文本、时间戳、表单底部错误说明 |
| `Label.large` | 14 | 1.2x | Medium | 主按钮文字、主选项卡文字 |
| `Label.medium` | 12 | 1.2x | Medium | 次按钮文字、Chip 标签文本 |
| `Label.small` | 11 | 1.2x | Medium | Badge 角标数字、微型状态标注 |

> **字重红线**：仅使用 `Regular (400)`, `Medium (500)`, `SemiBold (600)`。**禁止滥用 Bold (700+)**（仅用于核心金额和关键数值）。严禁用粗体充当层级替代手段。

### 4.4 色彩系统与状态语义

所有色彩严格使用语义 Token，绝对禁止裸写十六进制常量：

```text
Brand:       Primary, PrimaryHover, PrimaryPressed, PrimaryMuted
Surface:     Background, Surface, SurfaceElevated, SurfaceMuted
Text:        TextPrimary, TextSecondary, TextTertiary, TextDisabled, TextInverse
Border:      BorderDefault, BorderFocus, BorderError, Divider
State:       Success (绿), Warning (黄/橙), Error (红), Info (蓝)
Overlay:     Scrim (半透明遮罩), ShadowElevation
```

- **全端状态色彩一致**：无论在 Web、iOS、Android 还是桌面端，`Success` 必须是绿色系，`Error` 必须是红色系，`Warning` 必须是黄色/橙色系，`Info` 必须是蓝色系。
- **全量 Dark Mode 支持**：每个语义 Token 必须同时具备 Light 和 Dark 映射值。

### 4.5 响应式断点体系 (Breakpoints)

| 断点名称 | 视口宽度 | 推荐布局模式 |
|---------|---------|-------------|
| `Compact` | `< 600px` | 单栏流式、Bottom Navigation、按钮可拉通 Full Width |
| `Medium` | `600px ~ 839px` | 适度双栏排布、Navigation Rail、宽容器展示 |
| `Expanded`| `840px ~ 1199px`| 侧边栏 Sidebar、Master-Detail 双栏排版、限制主内容宽度 |
| `Large` | `1200px ~ 1439px`| 完整桌面三栏/宽屏布局、限制内容最大宽度 `1200~1440px` |
| `UltraWide`| `≥ 1440px` | 保持内容最大宽度居中对齐，留出两侧均等呼吸空间 |

---

## 5. 核心组件规范与实现范例

### 5.1 按钮统一规范（绝对红线）

#### 规格体系
- `Button Large`: 高度 `48~52px`，Padding `0 24px`，Label `16px/14px Medium`
- `Button Medium`: 高度 `40~44px`，Padding `0 16px`，Label `14px Medium`
- `Button Small`: 高度 `32~36px`，Padding `0 12px`，Label `12px Medium`
- `IconButton`: 视觉图标 `20~24px`，**触控区域必须保留至少 40×40px，推荐 44×44px 或 48×48px**

#### 按钮防折行与降级法则（The Fallback Cascade）
1. 按钮文字强制设置单行不换行：
   - Web: `white-space: nowrap; overflow: hidden; text-overflow: ellipsis;`
   - Flutter: `Text(..., maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false)`
   - Compose: `Text(..., maxLines = 1, overflow = TextOverflow.Ellipsis, softWrap = false)`
2. 空间受限时的解决梯次：
   - **Step 1: 精简文案**（动词 + 对象，如“立即开始设备连接”精简为“连接设备”，控制在 2~6 个汉字以内）
   - **Step 2: 扩大可用宽度**（横向设置 `flex-grow: 1 / weight(1f)`）
   - **Step 3: 改变排列形态**（由横向 `Row` 转换为纵向 `Column` 单列堆叠）
   - **Step 4: 适度减小左右 Padding**（如 `16px → 12px`）
   - **Step 5: 文字截断并显示省略号**
   - ❌ **严禁行为**：文字换行折成两行、按钮高度突增、极端缩小子号到不可读。

#### 代码范例（React / CSS 模式）：
```tsx
// ✅ 正确：严格遵循 Token 与防折行规范的 Button
interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'outlined' | 'danger';
  size?: 'small' | 'medium' | 'large';
  children: React.ReactNode;
}

export const Button: React.FC<ButtonProps> = ({
  variant = 'primary',
  size = 'medium',
  children,
  className = '',
  disabled,
  ...props
}) => {
  // 高度由规格严格决定：large=48px, medium=44px, small=36px
  const sizeClasses = {
    small: 'h-9 px-3 text-xs',
    medium: 'h-11 px-4 text-sm',
    large: 'h-12 px-6 text-base',
  }[size];

  const variantClasses = {
    primary: 'bg-primary text-on-primary hover:bg-primary-hover active:bg-primary-pressed',
    secondary: 'bg-surface-elevated text-text-primary hover:bg-surface-muted',
    outlined: 'border border-border text-text-primary hover:bg-surface-muted',
    danger: 'bg-error text-on-error hover:bg-error-hover active:bg-error-pressed',
  }[variant];

  return (
    <button
      disabled={disabled}
      className={`inline-flex items-center justify-center font-medium rounded-md transition-colors
        whitespace-nowrap overflow-hidden text-ellipsis min-w-[72px] select-none
        focus-visible:outline-2 focus-visible:outline-focus focus-visible:outline-offset-2
        disabled:opacity-40 disabled:cursor-not-allowed
        ${sizeClasses} ${variantClasses} ${className}`}
      {...props}
    >
      <span className="truncate">{children}</span>
    </button>
  );
};
```

---

### 5.2 弹窗对话框规范（Dialog）

#### 尺寸与排版约束
- **最大宽度限制**：Small (`320~400px`), Medium (`400~560px`), Large (`560~720px`)。禁止弹窗在桌面端拉满整个视口。
- **安全边距**：移动端小屏下，弹窗两侧必须保留至少 `16px` 安全距离（`max-width: calc(100vw - 32px)`）。
- **三段式架构与内容滚动分离**：
  - `Dialog Header`：固定置顶，标题与关闭按钮单行展示。
  - `Dialog Content`：独立滚动区域，具有 `max-height`（如 `calc(80vh - 140px)`），禁止整个弹窗随内容无限向下延伸超出屏幕。
  - `Dialog Footer`：固定置底，操作按钮常驻可见。小屏宽度不足时自动转为 `flex-col-reverse` 纵向排列。

#### 代码范例（响应式 Footer 排布）：
```tsx
// ✅ 正确：具备小屏纵向自适应与固定 Footer 的弹窗骨架
export const DialogFooter: React.FC<{
  onCancel: () => void;
  onConfirm: () => void;
  cancelText?: string;
  confirmText?: string;
  isDanger?: boolean;
}> = ({
  onCancel,
  onConfirm,
  cancelText = '取消',
  confirmText = '确认',
  isDanger = false,
}) => {
  return (
    // 宽屏横向排列，窄屏自动切换为纵向，主按钮位于最上方
    <div className="flex flex-col-reverse sm:flex-row sm:justify-end gap-3 pt-4 border-t border-divider">
      <Button variant="outlined" size="medium" onClick={onCancel} className="w-full sm:w-auto">
        {cancelText}
      </Button>
      <Button
        variant={isDanger ? 'danger' : 'primary'}
        size="medium"
        onClick={onConfirm}
        className="w-full sm:w-auto"
      >
        {confirmText}
      </Button>
    </div>
  );
};
```

---

### 5.3 列表项与横向排布规范（ListItem & Shrink Priority）

#### 标准三段式与挤压优先级
在横向行布局中，元素可能面对空间压缩。必须遵循 **Shrink Priority**：
```text
[固定尺寸 Leading Icon]  +  [弹性压缩并截断 Flexible Title/Subtitle]  +  [固定尺寸 Trailing Action]
(flex-shrink: 0)            (flex-grow: 1, min-width: 0, truncate)      (flex-shrink: 0)
```

- **单行标准项高度**：`48~56px`
- **双行标准项高度**：`64~72px`
- **富媒体列表项高度**：`72~88px`
- 严禁出现标题内容把右侧 Switch 开关或 Chevrons 挤出屏幕的情况。

#### 代码范例：
```tsx
// ✅ 正确：严守 Shrink Priority 的列表项
export const ListItem: React.FC<{
  icon?: React.ReactNode;
  title: string;
  subtitle?: string;
  action?: React.ReactNode;
  onClick?: () => void;
}> = ({ icon, title, subtitle, action, onClick }) => {
  return (
    <div
      onClick={onClick}
      className="flex items-center min-h-[56px] px-4 py-3 gap-3 rounded-lg hover:bg-surface-muted transition-colors cursor-pointer"
    >
      {/* 1. Leading: 固定不挤压 */}
      {icon && <div className="shrink-0 text-text-secondary">{icon}</div>}

      {/* 2. Middle: 弹性伸缩，超出截断 */}
      <div className="flex-1 min-w-0">
        <div className="text-body-medium text-text-primary font-medium truncate">
          {title}
        </div>
        {subtitle && (
          <div className="text-body-small text-text-secondary truncate mt-0.5">
            {subtitle}
          </div>
        )}
      </div>

      {/* 3. Trailing: 固定不挤压 */}
      {action && <div className="shrink-0 ml-2">{action}</div>}
    </div>
  );
};
```

---

## 6. 响应式与防御性布局硬性法则

### 6.1 超宽桌面端内容最大宽度约束
在桌面与超大显示器上，必须防止内容无限横向拉伸：
- **普通综合内容页面**：最大宽度 `1200px ~ 1440px`，居中对齐（`margin: 0 auto;`）。
- **设置页面、表单输入、长文章阅读**：最大宽度限制为 `640px ~ 840px`。

### 6.2 移动端 Safe Area 与键盘弹出遮挡防御
1. **Safe Area 避让**：
   - 顶部预留状态栏/刘海屏距离（`env(safe-area-inset-top)` / `WindowInsets.statusBars`）。
   - 底部操作栏预留手势横条距离（`env(safe-area-inset-bottom)` / `WindowInsets.navigationBars`）。
2. **底部粘性操作栏的列表尾部避让**：
   - 当页面底部存在固定操作栏（Sticky / Fixed BottomBar）时，滚动列表的最底部必须设置 `padding-bottom: calc(BottomBarHeight + Spacing + SafeAreaBottom)`，彻底避免最后一行列表项被底部栏遮挡。
3. **软键盘自适应**：
   - 移动端输入框聚焦时，必须配合 `scrollIntoView()` 机制使当前输入项浮入可视区，禁止软键盘永久遮挡输入框。

### 6.3 字体缩放（100% ~ 150%）防御
- 禁止使用 `ignore font scale`。
- 正文区域使用自然高度流（`min-height` 替代死高 `height`），允许文字向上撑开卡片；
- 但 **Button、Header、Tab、Navigation** 必须严格受控，文字截断单行展示，不得造成整个布局撕裂破损。

### 6.4 浮层边界安全（Dropdown & Tooltip）
- 所有下拉菜单与浮动提示必须具备视口边缘检测（Viewport Collision Detection）；
- 当靠近屏幕底部或右侧时，必须自动向上或向左反转展开，严禁被页面外框裁剪。

---

## 7. 好坏代码对照表

### 案例 1：按钮实现对比
❌ **坏代码（反面教材）**：
```tsx
// ❌ 错误：硬编码数值，无防换行，文字多时按钮高度失控，无统一点击区域
<button
  style={{
    padding: '13px 19px', // ❌ Magic Numbers
    fontSize: '15px',     // ❌ 随意字号
    backgroundColor: '#007aff', // ❌ 写死色彩，不支持深色模式
    borderRadius: '7px',  // ❌ 异构圆角
  }}
>
  点击这里立即同步云端全部数据
</button>
```

✅ **好代码（符合规范）**：
```tsx
// ✅ 正确：引用 Token，高度受控恒定，文字单行防折行，精简文案
<Button
  variant="primary"
  size="medium" // 44px 恒定高度，12px 圆角，语义 Theme 色彩
  onClick={handleSync}
>
  同步数据
</Button>
```

---

### 案例 2：设置列表项与卡片对比
❌ **坏代码（反面教材）**：
```tsx
// ❌ 错误：每个设置项都做成独立 Card（页面碎片化）；右侧开关被长标题挤扁；裸写间距与阴影
<div style={{ margin: '10px', boxShadow: '0 2px 9px rgba(0,0,0,0.1)' }}>
  <div style={{ display: 'flex', width: '300px' }}>
    <span>这是一个非常非常长的设置选项说明文字可能会把开关挤出屏幕</span>
    <input type="checkbox" />
  </div>
</div>
```

✅ **好代码（符合规范）**：
```tsx
// ✅ 正确：单个 Section 卡片聚合多个 ListItem，1px 分割线，遵循 Shrink Priority
<AppSection title="通知设置">
  <AppCard>
    <ListItem
      icon={<BellIcon />}
      title="新消息推送"
      subtitle="接收来自团队成员的实时通知"
      action={<AppSwitch checked={enabled} onChange={setEnabled} />}
    />
    <Divider />
    <ListItem
      icon={<MailIcon />}
      title="邮件摘要"
      subtitle="每周一发送项目进展周报"
      action={<AppSwitch checked={mailEnabled} onChange={setMailEnabled} />}
    />
  </AppCard>
</AppSection>
```

---

## 8. 执行检查速查口诀

```text
一查 Token：无裸写数值与颜色，全局间距对齐四八格。
二查按钮：高度恒定单行守，空间不足文案先精简。
三查聚合：避免卡片满天飞，列表三段挤压有顺序。
四查端点：窄屏三百二不破，超宽内容控在千四内。
五查边界：避让安全底栏空，键盘弹出焦点进视区。
六查主题：深浅明暗对比足，状态色彩全端保如一。
```
