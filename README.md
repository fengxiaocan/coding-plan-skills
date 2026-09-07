# Skills 开发工作流库

本项目是一组结构化开发工作流技能，用于规范 AI 辅助开发过程，覆盖 **问题修复 → 需求规划 → 代码理解 → 变更归档 → 提交推送** 完整链路。

---

## 工作流概览

```
[发现问题]    ── /dev-fix    ──→ 信息收集 → 分析 → 修复
[新需求]      ── /dev-plan   ──→ 需求采访 → 计划 → 开发
[代码理解]    ── /dev-analysis ─→ 阅读代码 → 生成文档
[逆向反编译]  ── /dev-decompile ─→ 指纹识别 → 反编译 → 接口与架构沉淀
[变更记录]    ── /dev-change ──→ 生成 CHANGELOG → 归档
[提交推送]    ── /dev-commit ──→ 暂存 → 规范提交 → 安全推送
```

---

## Skills 列表

| Skill | 触发命令 | 用途 | 阶段/章节 |
|-------|---------|------|----------|
| [dev-fix](skills/dev-fix/) | `/dev-fix` | 修复 Bug 时信息收集 | 7阶段 |
| [dev-plan](skills/dev-plan/) | `/dev-plan` | 新需求开发前规划 | 6阶段 |
| [dev-analysis](skills/dev-analysis/) | `/dev-analysis` | 已有代码功能分析与文档沉淀 | 3阶段 |
| [dev-decompile](skills/dev-decompile/) | `/dev-decompile` | 安装包与库反编译、架构分析与接口提取 | 7阶段 |
| [dev-change](skills/dev-change/) | `/dev-change` | 任务完成后变更记录 | 10章节 |
| [dev-commit](skills/dev-commit/) | `/dev-commit` | 自动暂存、规范提交并安全推送 | 5阶段 |

---

## 核心设计原则

1. **禁止提前编码**：未完成信息收集/规划前，禁止写任何代码
2. **逐步确认**：每阶段结束需用户确认后才能进入下一阶段
3. **诚实记录**：禁止编造验证结果，未验证内容必须标记
4. **渐进式提问**：每轮最多 2~3 个问题，逐步推进
5. **安全提交推送**：规范化提交信息，杜绝强推破坏代码历史

---

## 安装

将需要的 skill 目录复制到 Claude Code 的 skills 目录：

```bash
# Claude Code skills 目录（全局）
~/.claude/skills/

# 或项目级 skills 目录
./.claude/skills/
```

可以只安装需要的 skill，也可以全部安装：

```bash
cp -r dev-fix dev-plan dev-analysis dev-decompile dev-change dev-commit ~/.claude/skills/
```

---

## 使用方式

在对话中输入对应命令触发：

```
/dev-fix        # 开始修复问题的信息收集流程
/dev-plan       # 开始新需求的规划流程
/dev-analysis   # 开始分析已有功能并生成功能文档
/dev-decompile  # 开始安装包/依赖库反编译与逆向分析
/dev-change     # 生成本次变更的 CHANGELOG
/dev-commit     # 自动暂存、生成规范 Commit 并安全推送
```

---

## 目录结构

```
skills/
├── README.md                 # 本文档
├── GITHUB_INTRO.md           # GitHub 英文简介
├── dev-fix/
│   ├── SKILL.md              # 技能定义
│   ├── README.md             # 快速入口
│   └── USAGE.md              # 使用文档
├── dev-plan/
│   ├── SKILL.md              # 技能定义
│   ├── README.md             # 快速入口
│   └── USAGE.md              # 使用文档
├── dev-analysis/
│   ├── SKILL.md              # 技能定义
│   ├── README.md             # 快速入口
│   ├── USAGE.md              # 使用文档
│   └── TEMPLATE.md           # 文档模板
├── dev-decompile/
│   ├── SKILL.md              # 技能定义
│   ├── README.md             # 快速入口
│   ├── USAGE.md              # 使用文档
│   ├── TEMPLATE.md           # 文档模板
│   ├── scripts/              # 跨平台逆向工具脚本
│   └── references/           # 逆向参考手册与规则库
├── dev-change/
│   ├── SKILL.md              # 技能定义
│   ├── README.md             # 快速入口
│   └── USAGE.md              # 使用文档
└── dev-commit/
    ├── SKILL.md              # 技能定义
    ├── README.md             # 快速入口
    └── USAGE.md              # 使用文档
```

---

## 适用场景

- **团队开发**：统一 AI 辅助开发的工作流程
- **代码审计**：变更记录可追溯、可审计
- **新成员交接**：通过 CHANGELOG 快速了解历史变更
- **问题追踪**：结构化的调试访谈确保不遗漏关键信息
