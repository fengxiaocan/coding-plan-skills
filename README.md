# Skills 开发工作流库

本项目是一组结构化开发工作流技能，用于规范 AI 辅助开发过程，覆盖 **问题修复 → 需求规划 → 变更归档** 完整链路。

---

## 工作流概览

```
[发现问题]    ── /fix-plan  ──→ 信息收集 → 分析 → 修复
[新需求]      ── /dev-plan  ──→ 需求采访 → 计划 → 开发
[任务完成]    ── /dev-change ─→ 生成 CHANGELOG → 归档
```

---

## Skills 列表

| Skill | 触发命令 | 用途 | 阶段/章节 |
|-------|---------|------|----------|
| [fix-plan](fix-plan/) | `/fix-plan` | 修复 Bug、排查异常、分析故障 | 7 阶段 |
| [dev-plan](dev-plan/) | `/dev-plan` | 新需求开发、功能实现 | 6 阶段 |
| [dev-change](dev-change/) | `/dev-change` | 任务完成后变更记录 | 10 章节 |
| [dev-coding](dev-coding/) | `/fix-plan` `/dev-plan` `/dev-change` | 三个技能的集合库 | — |

---

## 核心设计原则

1. **禁止提前编码**：未完成信息收集/规划前，禁止写任何代码
2. **逐步确认**：每阶段结束需用户确认后才能进入下一阶段
3. **诚实记录**：禁止编造验证结果，未验证内容必须标记
4. **渐进式提问**：每轮最多 2~3 个问题，逐步推进

---

## 安装

将本目录复制到 Claude Code 的 skills 目录：

```bash
# Claude Code skills 目录
~/.claude/skills/

# 或项目级 skills 目录
./.claude/skills/
```

---

## 使用方式

在对话中输入对应命令触发：

```
/fix-plan   # 开始修复问题的信息收集流程
/dev-plan   # 开始新需求的规划流程
/dev-change # 生成本次变更的 CHANGELOG
```

---

## 目录结构

```
skills/
├── README.md                 # 本文档
├── fix-plan/
│   ├── SKILL.md              # 技能定义
│   └── USAGE.md              # 使用文档
├── dev-plan/
│   ├── SKILL.md              # 技能定义
│   └── USAGE.md              # 使用文档
├── dev-change/
│   ├── SKILL.md              # 技能定义
│   └── USAGE.md              # 使用文档
└── dev-coding/
    ├── SKILL.md              # 集合库入口
    ├── fix-plan.md           # 修复流程详情
    ├── dev-plan.md           # 规划流程详情
    ├── dev-change.md         # 变更记录详情
    └── USAGE.md              # 使用文档
```

---

## 适用场景

- **团队开发**：统一 AI 辅助开发的工作流程
- **代码审计**：变更记录可追溯、可审计
- **新成员交接**：通过 CHANGELOG 快速了解历史变更
- **问题追踪**：结构化的调试访谈确保不遗漏关键信息
