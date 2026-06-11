---
name: dev-coding
description: Structured development workflow library covering bug fixing, feature planning, and change documentation. Contains three commands: /fix-plan for structured debug interviews, /dev-plan for development planning before coding, and /dev-change for generating change logs after task completion. Use when fixing bugs, building features, or documenting completed work.
---

# Dev Coding — Development Workflow Library

本技能库提供完整的开发工作流，覆盖 **修复问题 → 开发规划 → 变更归档** 三个环节。

## 工作流概览

```
[发现问题] ── /fix-plan ──→ [收集信息 → 分析 → 修复 → 完成]
[新需求]   ── /dev-plan ──→ [采访需求 → 制定计划 → 验收 → 完成]
[完成后]   ── /dev-change ─→ [生成 CHANGELOG → 归档]
```

---

## 命令速查

| 命令 | 场景 | 阶段数 | 说明 |
|------|------|--------|------|
| `/fix-plan` | 修复 Bug、排查异常 | 7阶段 | 严格信息收集后才能写代码 |
| `/dev-plan` | 新需求开发 | 6阶段 | 需求采访 → 计划 → 验收确认后编码 |
| `/dev-change` | 任务完成后 | 10章节 | 自动生成 CHANGELOG 归档 |

---

## 详细说明

- [/fix-plan](fix-plan.md) — 调试访谈流程
- [/dev-plan](dev-plan.md) — 开发规划流程
- [/dev-change](dev-change.md) — 变更记录流程

---

## 全局原则

- 禁止在信息/规划完成前写代码
- 禁止编造未验证的内容
- 每轮对话最多提 2~3 个问题
- 进入下一阶段前必须得到用户确认
