# Dev Unified UI Design — 跨平台统一设计系统工作流

本 Skill 用于约束和指导所有跨平台项目（Web、iOS、Android、Windows、macOS、Linux、Flutter、React Native、Compose Multiplatform、Electron、Tauri 等）的 UI/UX 设计与代码实现。

**核心一句话法则**：
> 页面只负责组织内容，设计系统负责决定内容长什么样。业务页面严禁自行发明视觉样式。

同一种组件，在所有页面和所有平台上，应保持相同的视觉语义、尺寸体系、交互逻辑和信息层级。

---

## 触发命令

在 Claude Code / 智能助手对话中输入：

```bash
/dev-unified-ui-design
```

或附带具体页面、模块或重构需求说明：

```bash
# 需求开发：实现规范化业务页面
/dev-unified-ui-design 创建一个跨平台个人中心与系统设置页面，适配移动端与桌面端宽屏

# 样式重构：治理老旧混乱的 UI
/dev-unified-ui-design 重构 UserProfileView，消除裸写 px/dp，统一按钮高度并修复小屏下溢出遮挡

# 设计系统基建：搭建基础组件库
/dev-unified-ui-design 为项目搭建一套跨端 Design System 基础 Tokens（色彩/间距/排印/圆角）与核心组件（Button/Card/Dialog/Input）
```

也可以通过自然语言意图触发：
- “帮我按照统一设计系统规范实现这个跨平台页面”
- “审查当前界面的排版与组件，消除 Magic Number 并统一圆角与按钮高度”
- “优化页面的响应式布局，解决在小屏或 150% 字体放大下的破版和按钮换行”
- “统一 Web 和移动端的色彩与弹框风格，支持深色模式”

---

## 核心设计原则

1. **零 Magic Number**：严禁出现 `13px`, `17px`, `19px`, `27px`, `37px`, `43px` 等随意数值，所有参数严格引用 Design Tokens。
2. **复用优先于新建**：严禁私造 `CustomButton`, `SpecialCard`, `NewDialog`，所有页面 100% 复用 Foundation 组件库，仅通过 Variant 和 Size 扩展。
3. **按钮高度恒定与防折行**：按钮高度由规格决定（Large 48~52, Medium 40~44, Small 32~36），文字强制单行不换行，超长按“精简文案 > 扩宽 > 换列 > 缩减内边距 > 省略号”梯次处理。
4. **4 / 8 基础网格体系**：全局外边距 16（移动端）/ 24（桌面端），Section 间距 24~32，严格限制宽屏内容最大宽度（1200~1440，表单 640~840）。
5. **触控安全与边界防御**：点击区域保留至少 40×40（推荐 44~48）；防御 320px 窄屏、150% 字体缩放、Safe Area、键盘弹出与底部导航遮挡。
6. **语义色彩与全端一致性**：严禁裸写纯色与色号，全部引用语义 Theme Token，状态色彩（成功绿、警告黄、错误红、信息蓝）全平台语义严密一致。
7. **横向挤压优先级（Shrink Priority）**：固定图标 → 弹性文本（优先截断） → 固定操作控件，杜绝控件被挤出屏幕或文字覆盖图标。

---

## 工作流程（5 阶段）

```text
阶段 1: 资产扫描与盘点 → 检查已有 Tokens、Theme、Foundation 组件与布局 Shell
阶段 2: 架构规划与复用 → 确立信息层级（Header→Core Card→Primary Action→Sections），阻断重复造轮子
阶段 3: 严格规范实现   → 严格应用 Token、4/8 栅格、按钮防折行、恒定高度、语义色彩
阶段 4: 极端场景与弹性 → 验证响应式断点、320px 窄屏、150% 字体放大、长文本截断、遮挡检测
阶段 5: 审查清单与交付 → 输出 8 大维度审查表与 17 项全票通过验收报告
```

---

## 目录结构

```text
skills/dev-unified-ui-design/
├── SKILL.md       # 技能核心定义（元数据、行为指令、红线、决策优先级与 5 阶段工作流）
├── README.md      # 本文件：快速概览与入口说明
├── USAGE.md       # 使用文档：跨端 Token 体系、组件封装范例、自适应排版、防御性设计与好坏代码对比
└── TEMPLATE.md    # UI 审查交付模板与 17 项全票验收清单
```

---

## 推荐阅读

- [使用详解与跨端代码规范 (USAGE.md)](USAGE.md)
- [UI 审查核对模板与交付清单 (TEMPLATE.md)](TEMPLATE.md)
