# Dev Commit — 规范化 Git 提交与安全推送

本 Skill 用于**自动暂存工作区变更、生成符合规范的 Commit Message、提交至本地分支并安全推送到远程对应分支**。

---

## 触发命令

在 Claude Code 对话中输入：

```
/dev-commit
```

或附加提交说明：

```
/dev-commit 修复了用户登录超时的问题
```

---

## 核心能力

1. **自动暂存**：检查工作区状态，过滤敏感文件，自动执行 `git add`
2. **规范提交信息**：遵循 Conventional Commits（`feat`, `fix`, `docs`, `refactor` 等）自动生成高可读性提交说明
3. **安全提交与推送**：自动提交本地，安全推送到远程对应分支，杜绝危险强推

---

## 工作流程

```
阶段 1: 检查状态与分支 → 检查改动与当前分支
阶段 2: 敏感检查与暂存 → 扫描敏感文件，git add 暂存
阶段 3: 生成规范信息   → 遵循 Conventional Commits 生成提交说明
阶段 4: 执行本地提交   → git commit 提交本地
阶段 5: 安全推送到远程 → 安全 git push 并输出统计报告
```

详细说明见 [USAGE.md](USAGE.md)。

---

## 文件结构

```
skills/dev-commit/
├── SKILL.md      # 技能定义（Claude Code 元数据 + 行为指令）
├── README.md     # 本文件：快速入口
└── USAGE.md      # 使用文档：完整流程、规范详解、示例、安全规则
```
