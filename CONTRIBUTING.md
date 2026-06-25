# 贡献指南 · Contributing to MPlanet

> **欢迎你 👋** 任何人都可以通过 Issue、PR、Fork、文档完善等方式参与 MPlanet。
> 这是一个开源项目,我们相信社区的力量能让它变得更好。

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)]()
[![Conventional Commits](https://img.shields.io/badge/commit-Conventional%20Commits-blue.svg)]()
[![MIT License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](LICENSE)

---

## 📑 目录

- [🤝 我们的态度](#-我们的态度)
- [🛠️ 贡献的 4 种方式](#-贡献的-4-种方式)
- [🧰 开发环境准备](#-开发环境准备)
- [🌿 分支与提交规范](#-分支与提交规范)
- [🔍 本地验证清单](#-本地验证清单)
- [📬 提交 Pull Request](#-提交-pull-request)
- [⏱️ 审核 SLA](#-审核-sla)
- [🧑‍💻 维护者说明](#-维护者说明)
- [❓ 常见疑问](#-常见疑问)

---

## 🤝 我们的态度

| ✅ 我们欢迎 | ❌ 我们不期望 |
|---|---|
| 报告 Bug、提改进建议 | 一次性巨型重构 PR |
| 修小 Bug、改错别字 | 与架构目标无关的大型功能 |
| 补文档、加注释、加示例 | 不经过沟通就动核心架构 |
| 新增可复用的业务模块 | 把内部公司业务强塞进来 |
| 翻译、纠错、补充截图 | 提交破坏组件化边界的代码 |

> **社区贡献型项目,不是公司内部代码仓库** —— 一切以「可读、可学、可复用」为第一原则。

---

## 🛠️ 贡献的 4 种方式

### 1️⃣ 报告 Bug 🐛

发现项目本身有 Bug(不是使用问题),请通过 GitHub Issues 提交:

- 使用 `Bug` 模板
- 标题清晰:`[Bug] pod install 在 Xcode 16.2 失败`
- 提供:操作系统 / Xcode 版本 / 完整日志 / 复现步骤
- 如果有解决方案,顺手附上 PR 链接

### 2️⃣ 提改进建议 💡

任何想法都可以提:

- 架构疑问 → `Question` 标签
- 改进想法 → `Enhancement` 标签
- 文档/翻译问题 → `Docs` 标签

> 💬 **不确定算不算 Bug?** 直接开 Issue 描述场景,我们一起判断。

### 3️⃣ 提交文档 PR 📝

文档改动**门槛最低、最受欢迎**,包括:

- 错别字、语句不通顺
- 补充代码示例或截图
- 翻译其他语言版本(英文 README 已经在 [README.en.md](README.en.md))
- 新增 FAQ、设计文档、教程

### 4️⃣ 提交代码 PR 💻

代码改动请先开 Issue 沟通,**大改动前**等维护者确认方向,避免做无用功。

适合的代码改动:

- 修复明确的 Bug
- 新增一个完整业务模块作为参考(放在 `DevelopmentPods/WMModules/` 下)
- 改进组件化基础能力(`Mediator` / `FeatBox` / `RootManager`)
- 升级依赖版本(请保留兼容说明)

---

## 🧰 开发环境准备

| 工具 | 版本要求 | 备注 |
|---|---|---|
| macOS | 12+ | Apple Silicon 原生支持 |
| Xcode | 15.0+ | 推荐 15.4 / 16.x |
| Swift | 5.9+ | 与项目保持一致 |
| CocoaPods | 1.13+ | 镜像源已配清华,无需改 |
| Git | 2.30+ | 配置好 `user.name` / `user.email` |

### Fork & Clone

```bash
# 1. 在 GitHub 上点 Fork 按钮
# 2. 克隆你自己的 fork
git clone https://github.com/<your-name>/MPlanet.git
cd MPlanet

# 3. 添加上游 remote
git remote add upstream https://github.com/yangKJ/MPlanet.git

# 4. 安装依赖
pod install

# 5. 打开 workspace(注意是 .xcworkspace 不是 .xcodeproj)
open MainProject.xcworkspace
```

---

## 🌿 分支与提交规范

### 分支命名

格式:`<type>/<short-description>`,常见类型:

| 前缀 | 用途 | 示例 |
|---|---|---|
| `feat/` | 新功能 | `feat/add-wallet-module` |
| `fix/` | 修 Bug | `fix/mediator-cache-leak` |
| `docs/` | 文档 | `docs/update-architecture-md` |
| `refactor/` | 重构(不改行为) | `refactor/extract-baseviewmodel` |
| `chore/` | 工程杂项 | `chore/bump-rxswift-6.7` |
| `test/` | 测试 | `test/add-mediator-tests` |

### Commit Message(参考 Conventional Commits)

```
<type>(<scope>): <subject>

<body>

<footer>
```

**示例**:

```text
feat(mediator): support async/await target calls

增加基于 Swift Concurrency 的 performTarget 包装,
保留旧接口的同时提供异步版本以便 ViewModel 调用。

Closes #42
```

**常用 type**:

- `feat` · 新功能
- `fix` · 修 Bug
- `docs` · 仅文档
- `style` · 格式调整(不影响代码)
- `refactor` · 重构
- `test` · 测试
- `chore` · 构建/依赖/工具

---

## 🔍 本地验证清单

> ✅ 提交 PR 前,**必须**全部通过:

| # | 步骤 | 命令 / 操作 |
|---|---|---|
| 1 | 编译成功 | `xcodebuild -workspace MainProject.xcworkspace -scheme MainProject -sdk iphonesimulator -configuration Debug build` |
| 2 | pod install 干净 | `pod install --repo-update` 无报错 |
| 3 | SwiftLint 通过 | `swiftlint` (如已配置) |
| 4 | 新模块有 target | 业务模块必须包含 `Target_xxx` 类 |
| 5 | 公开 API 有 `///` | 注释使用中文,描述「为什么」不只是「是什么」 |
| 6 | 文档同步 | 若改动影响架构,更新 [ARCHITECTURE.md](ARCHITECTURE.md) |
| 7 | Commit 格式 | 遵循 Conventional Commits |

---

## 📬 提交 Pull Request

### PR 标题模板

```
<type>(<scope>): <一句话说明>
```

**示例**:

- `fix(mediator): 修复无参数 VC 缓存 key 冲突`
- `docs(readme): 补充真机调试步骤`
- `feat(wallet): 新增钱包业务模块参考实现`

### PR 描述应包含

1. **背景**:这个 PR 解决什么问题 / 为什么需要
2. **改动点**:改了哪些文件、为什么这么改
3. **截图 / 录屏**:UI 改动必须有
4. **关联 Issue**:`Closes #123` / `Refs #456`
5. **自测结果**:本地验证清单全部 ✅

### 流程图

```text
fork 仓库
   ↓
新建 feature/xxx 分支
   ↓
本地开发 + 验证清单
   ↓
push 到你的 fork
   ↓
GitHub 上提 PR(标题遵循规范)
   ↓
等待 CI(如有) + 维护者 review
   ↓
根据反馈修改 → merge 🎉
```

---

## ⏱️ 审核 SLA

| 阶段 | 时间 | 说明 |
|---|---|---|
| **首次响应** | **72 小时** | 维护者首次回复 Issue / PR |
| 简单 PR 合并 | 1-7 天 | 文档、typo、小修小补 |
| 复杂 PR 沟通 | 1-3 周 | 涉及架构改动需多轮讨论 |
| Bug 修复优先级 | 高 | 安全 / 编译失败类 Bug 优先处理 |

> 🕐 **响应延迟**是常态,不是异常。如果超过 72h 未收到回复,可以在 Issue 里 `@` 维护者礼貌提醒。

---

## 🧑‍💻 维护者说明

MPlanet 由 [yangKJ](https://github.com/yangKJ) **单人维护**。

### 这意味着什么?

| 维度 | 现状 |
|---|---|
| 维护人数 | 1 人 |
| 可投入时间 | 工作之余 |
| 时区 | GMT+8(Asia/Shanghai) |
| 主要语言 | 中文 / English |
| 响应速度 | 72 小时内首次响应 |

### 你可以做的

- ✅ 耐心等首次响应(通常更快)
- ✅ 在 Issue 里贴完整日志、复现步骤、你的判断
- ✅ 自己尝试修复并提 PR(维护者会很感激)
- ✅ 对其他人的 Issue 给出回复(社区互助)

### 请避免

- ❌ 短时间内重复 `@` 维护者
- ❌ 跨多 Issue 重复提相同问题
- ❌ 在 PR 中混入不相关的格式化改动

---

## ❓ 常见疑问

### Q:我能直接修改 `MainProject/` 下的文件吗?

**A**: 可以,但请说明理由。宿主工程的改动通常意味着对架构的调整,请先开 Issue 讨论。

### Q:能新增一个完整业务模块吗?

**A**: 非常欢迎!放在 `DevelopmentPods/WMModules/<ModuleName>/` 下,参考 `WMDiscover` / `WMMine` 的目录结构。

### Q:依赖版本想升级怎么办?

**A**: 先开 Issue 说明升级原因和影响范围。小版本直接提 PR 即可,主版本升级需要讨论。

### Q:PR 被拒绝了会怎样?

**A**: 我们会在 PR 里说明原因。如果你认为判断有误,可以重新讨论或关闭。

### Q:我能成为长期贡献者吗?

**A**: 如果你持续贡献(≥3 次有质量的 PR),可以在 README 的致谢区获得署名。

---

## 📄 License

提交贡献即表示你同意以 [MIT License](LICENSE) 协议开源你的代码。

---

<div align="center">

**感谢你愿意花时间让 MPlanet 变得更好 ⭐**

[⬆ 回到顶部](#贡献指南--contributing-to-mplanet)

</div>