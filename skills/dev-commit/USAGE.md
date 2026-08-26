# Dev Commit 使用文档

## 用途

`dev-commit` 用于**自动化工作区代码的暂存、规范化 Commit Message 生成、本地提交及安全推送（Push）到远程对应分支**。

**核心理念**：让每次提交都有迹可循、符合规范；自动化繁琐的 Git 命令，同时严格保证代码与分支推送的安全性。

---

## 触发方式

在 Claude Code 对话中输入：

```
/dev-commit
```

或者附带本次提交的简要说明/意图：

```
/dev-commit 完成了用户注册与登录接口
```

```
/dev-commit 修复了购物车结算金额计算错误
```

也可以在完成任何功能开发、Bug 修复或文档编写后，通过自然语言触发：
- "帮我提交代码并推送到远程"
- "把刚才的改动 git commit 并 push 一下"

---

## 工作流程（5 阶段）

```
阶段 1: 检查状态与分支 → 执行 git status 确认改动，识别当前所在分支及保护状态
阶段 2: 敏感检查与暂存 → 扫描排查敏感文件/临时文件，执行 git add 暂存有效变更
阶段 3: 生成规范信息   → 基于 diff 分析生成符合 Conventional Commits 的提交信息
阶段 4: 执行本地提交   → 执行 git commit 生成本地提交，获取 Commit SHA
阶段 5: 安全推送到远程 → 检查远程追踪分支，安全执行 git push，输出完整报告
```

---

## Commit Message 规范详解

生成的信息严格遵循 **Conventional Commits** 约定式提交规范：

### 1. 结构

```
<type>(<scope>): <subject>

[可选 body]

[可选 footer]
```

### 2. Type 类型对照表

| 类型 | 说明 | 适用示例 |
|------|------|---------|
| `feat` | 新增功能 (Feature) | `feat(auth): 新增 GitHub OAuth 第三方登录` |
| `fix` | 修复缺陷 (Bug Fix) | `fix(cart): 修复优惠券折扣金额溢出问题` |
| `docs` | 文档变更 (Documentation) | `docs(readme): 更新开发环境搭建说明` |
| `style` | 格式调整 (Formatting) | `style(ui): 调整按钮内边距与代码缩进` |
| `refactor` | 代码重构 (Refactoring) | `refactor(parser): 重构数据解析器以提高可读性` |
| `perf` | 性能提升 (Performance) | `perf(image): 增加图片懒加载与 WebP 压缩` |
| `test` | 测试用例 (Tests) | `test(order): 增加订单状态流转单元测试` |
| `build` | 构建系统与外部依赖 | `build(deps): 升级 spring-boot 至 3.2.0` |
| `ci` | CI/CD 自动化与脚本 | `ci(github): 增加 PR 自动运行单元测试工作流` |
| `chore` | 辅助事务、杂项改动 | `chore(git): 更新 .gitignore 忽略临时产物` |
| `revert` | 撤销提交 | `revert: 撤销提交 9a8b7c6` |

---

## 使用示例

### 示例 1：常规功能提交与推送

**用户输入：**
```
/dev-commit
```

**AI 响应：**
```markdown
正在检查工作区并暂存改动...
检测到 3 个文件修改，已完成暂存。

## 🚀 Git 提交与推送完成

- **当前分支**：`feature/user-profile`
- **提交哈希**：`7d2e4f1`
- **远程状态**：已成功推送至 `origin/feature/user-profile`

### 📝 Commit Message
```
feat(profile): 新增用户个人资料编辑与头像上传功能

- 新增 UserProfileController 处理资料修改请求
- 新增 AvatarUploader 组件支持本地与 OSS 存储
- 完善资料表单前端验证与错误提示
```

### 📂 变更文件统计
- **新增**：`src/components/AvatarUploader.vue`
- **修改**：`src/api/user.ts`, `src/views/Profile.vue`
```

---

### 示例 2：带附加说明的 Bug 修复提交

**用户输入：**
```
/dev-commit 修复了 Token 过期时请求无限重试的 Bug
```

**AI 响应：**
```markdown
已暂存并分析相关改动。

## 🚀 Git 提交与推送完成

- **当前分支**：`fix/token-refresh`
- **提交哈希**：`a1b2c3d`
- **远程状态**：已成功推送至 `origin/fix/token-refresh`

### 📝 Commit Message
```
fix(auth): 修复 Token 过期时请求拦截器无限重试问题

- 在 Axios 拦截器中增加 401 重试次数上限判断
- 修复刷新 Token 失败时未正确清除本地缓存的缺陷
```

### 📂 变更文件统计
- **修改**：`src/utils/request.ts`
```

---

### 示例 3：新建分支首次提交与推送

**用户输入：**
```
/dev-commit 这是新功能分支的首次提交
```

**AI 响应：**
```markdown
检测到当前分支 `feature/payment-v2` 暂未关联远程分支，正在推送到远程并建立追踪关联（git push -u origin feature/payment-v2）...

## 🚀 Git 提交与推送完成

- **当前分支**：`feature/payment-v2`
- **提交哈希**：`f4e5d6c`
- **远程状态**：已成功建立追踪并推送至 `origin/feature/payment-v2`

### 📝 Commit Message
```
feat(payment): 初始化支付系统 V2 模块基础架构与配置
```

### 📂 变更文件统计
- **新增**：`src/modules/payment/index.ts`, `src/config/payment.ts`
```

---

## 安全规则与防护机制

| 安全机制 | 具体行为 |
|---------|---------|
| **严禁强推（No Force Push）** | 绝对不使用 `--force` 或 `-f`，避免覆盖他人代码与远程历史 |
| **敏感文件拦截** | 自动识别 `.env`、密钥文件、Token 等，防止误提交敏感信息 |
| **工作区状态守护** | 若工作区无变更，不生成无意义的空提交（Empty Commit） |
| **冲突安全中断** | 若远程存在更新导致 Push 被拒，提示用户拉取合并，不强行覆盖 |
| **主分支保护提示** | 在 `main` / `master` 等关键分支上操作时进行状态确认 |

---

## 何时使用

- [x] 完成新功能或模块开发后
- [x] 修复 Bug 并验证通过后
- [x] 重构代码或优化性能后
- [x] 更新项目文档、配置文件后
- [x] 阶段性保存工作进度并同步到远程仓库时

---

## 注意事项

1. **先验证后提交**：建议在运行过测试或确认代码无语法/编译错误后再执行提交。
2. **保持提交粒度**：尽量单次提交解决一个独立任务或主题，避免将不相关的修改混在同一次提交中。
3. **远程冲突处理**：如果团队协作时远程分支已有新提交，先 pull 同步后再执行 push。
