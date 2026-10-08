# Dev Android Design — 现代 Android 统一设计系统工作流

本 Skill 用于约束和指导 Android 项目的 UI/UX 设计与代码实现，整体设计风格参考 **Google Stitch** 现代移动端设计语言（简洁、清晰、高信息层级、适量留白、统一圆角、统一字体体系、统一组件高度、克制色彩与多屏幕自适应）。

**核心一句话法则**：
> UI 页面负责“组合组件”，Design System 负责“决定组件长什么样”。业务页面严禁自行发明视觉样式。

---

## 触发命令

在 Claude Code / 智能助手对话中输入：

```
/dev-android-design
```

或附带具体页面/需求说明：

```
/dev-android-design 创建一个个人中心与系统设置页面
```

```
/dev-android-design 审查并重构当前 NetworkSpeedScreen 的 Compose 界面样式
```

```
/dev-android-design 搭建一套基础 Stitch 风格的 Design System 公共组件库
```

也可以通过自然语言触发：
- "帮我按照统一设计系统实现这个 Android 页面"
- "重构界面的 Compose 代码，消除 Magic Number 并统一圆角和高度"
- "审查当前 Android UI 是否符合 Stitch 设计规范"

---

## 核心设计原则

1. **零 Magic Number**：严禁出现 `17.sp`, `13.dp`, `47.dp` 等无设计系统依据的数值，严格通过 `AppTypography`, `AppShapes`, `AppDimensions` 引用。
2. **复用优先于新建**：页面开发前优先盘点已有公共组件（`AppButton`, `AppCard`, `AppListItem`, `AppDialog`），严禁为单个业务页面新建异构样式组件。
3. **按钮高度恒定与防换行**：标准按钮高度统一（Large 52dp / Medium 48dp / Small 36~40dp），按钮文字强制单行不换行，文字超长按“缩短文案 > 扩宽 > 缩减 Padding > 省略号”梯次处理。
4. **4dp 栅格体系**：页面全局边距 16dp（大屏 24dp），区块间距 24dp，间距全部采用 4dp 栅格。
5. **触控安全与小屏自适应**：点击区域保留至少 48×48dp；页面必须适配 320dp 极小屏与 130%~150% 系统字体缩放。
6. **语义颜色与深色模式**：禁止硬编码 `Color.Red` / `Color.White`，全走 Theme 语义色彩，原生兼容 Light / Dark Theme。

---

## 工作流程（5 阶段）

```text
阶段 1: 资产扫描与盘点 → 检查工程 ui/theme/ Tokens 与 ui/components/ 公共组件
阶段 2: 架构规划与复用 → 规划信息层级（标题→卡片→主操作），阻断重复造轮子
阶段 3: 严格规范实现   → 严格应用 Token、4dp 栅格、按钮防折行、48dp 触控区域
阶段 4: 边界自适应校验 → 验证 320dp 小屏、长文本防御、130% 字体放大、Dark Mode
阶段 5: 审查清单与交付 → 输出 5 大维度审查报告与规范对齐清单
```

---

## 文件结构

```text
skills/dev-android-design/
├── SKILL.md       # 技能核心定义（元数据、行为指令、硬性红线与 5 阶段工作流）
├── README.md      # 本文件：快速概览与入口说明
├── USAGE.md       # 使用文档：设计 Token 代码范例、核心组件封装、页面实战、对比与避坑指南
└── TEMPLATE.md    # UI 交付核对清单与页面设计规范模板
```

---

## 推荐阅读

- [使用详解与代码规范 (USAGE.md)](USAGE.md)
- [UI 审查核对模板 (TEMPLATE.md)](TEMPLATE.md)
