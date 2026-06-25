# Security Policy

> **English Notice**: This is a sample/learning project, NOT for production deployment. We do NOT accept vulnerability disclosures.

---

# 安全策略

> **中文声明**:这是一个示例 / 学习项目,**不用于生产环境部署**。我们**不接受任何形式的漏洞披露**。

## 目录

- [项目性质声明](#项目性质声明)
- [如何安全地 fork](#如何安全地-fork)
- [如果你确实发现了 Bug](#如果你确实发现了-bug)
- [关于"已脱敏"的说明](#关于已脱敏的说明)
- [许可证免责声明](#许可证免责声明)
- [相关文档](#相关文档)

---

## 项目性质声明

| 项目 | 说明 |
| --- | --- |
| **项目类型** | 示例 / 学习用途 (Sample / Learning) |
| **生产可用性** | 不支持 (Not supported) |
| **漏洞披露** | 不接受 (Not accepted) |
| **安全更新** | 不承诺 (Not promised) |
| **官方支持** | 不提供 (Not provided) |

> ⚠️ **重要提示**:本仓库的代码仅供学习参考,作者不承担任何因使用本项目代码而产生的安全风险或数据损失责任。

---

## 如何安全地 fork

如果你打算 fork 本项目用于学习或实验,请务必遵守以下 5 条安全准则:

| # | 准则 | 说明 |
| --- | --- | --- |
| 1 | 🚫 **不要往生产 fork** | 仅限个人学习 / 本地实验,**禁止**用于生产环境或对外服务 |
| 2 | 🔄 **保持依赖更新** | 定期执行 `pod update` 或 `swift package update` 拉取最新依赖 |
| 3 | 🔑 **不要直接用示例 token** | 替换为你自己的凭证(API Key / Token),不要使用示例中的默认值 |
| 4 | 📜 **检查第三方库许可证** | fork 前审查依赖库的 License,避免许可证冲突 |
| 5 | 🔍 **私有 API 检测** | 上架前使用 `runtime-api-check` 等工具扫描是否误用私有 API |

### 快速检查清单

```bash
# 1. 更新 CocoaPods 依赖
pod update --repo-update

# 2. 更新 Swift Package Manager 依赖
swift package update

# 3. 搜索硬编码的敏感信息
grep -rn "TODO_TOKEN\|CHANGEME\|PLACEHOLDER" .

# 4. 扫描私有 API 使用情况
find . -name "*.swift" | xargs grep -l "_private\|PrivateFramework"
```

### 推荐的依赖更新频率

| 环境 | 更新频率 |
| --- | --- |
| 开发环境 | 每周一次 |
| 测试环境 | 每次构建前 |
| ~~生产环境~~ | ~~不适用~~ |

---

## 如果你确实发现了 Bug

虽然我们不接受安全漏洞披露,但如果你在阅读源码时发现了普通 Bug:

1. 📝 在 [GitHub Issues](https://github.com/owner/repo/issues) 提交 Issue
2. 🏷️ 使用 `bug` 标签
3. 📋 提供复现步骤、期望结果、实际结果
4. 🖼️ 如有截图请一并附上

> 💡 **提示**:提交 Issue 之前请先搜索是否已有相同问题,避免重复。

### Issue 模板

```markdown
**环境**:
- iOS 版本:
- Xcode 版本:
- 设备型号:

**复现步骤**:
1. xxx
2. xxx

**期望结果**:
xxx

**实际结果**:
xxx
```

---

## 关于"已脱敏"的说明

本项目已经过脱敏处理,移除了以下敏感信息:

| 类型 | 处理方式 |
| --- | --- |
| 🔐 真实 API Key | 替换为 `YOUR_API_KEY` 占位符 |
| 🔐 真实 Token | 替换为 `<REDACTED_TOKEN>` |
| 🔐 服务端地址 | 替换为 `https://example.com` |
| 🔐 真实用户数据 | 已删除或替换为模拟数据 |
| 🔐 内部域名 | 替换为 `internal.example.com` |

> ✅ **脱敏状态**:已完成 (Sanitized)

```swift
// 脱敏前 (示例)
let apiKey = "sk-1234567890abcdef"

// 脱敏后
let apiKey = "YOUR_API_KEY"  // 请替换为你的真实凭证
```

> ⚠️ 注意:脱敏仅针对公开仓库中可见的部分,不能保证所有提交历史都已被完全清理。如发现遗漏,请通过普通 Issue 反馈(非安全披露)。

---

## 许可证免责声明

本项目基于 **MIT License** 开源。

| 条款 | 说明 |
| --- | --- |
| ✅ 允许 | 商业使用、修改、分发、私用 |
| ❌ 不允许 | 未经授权以原作者名义担保 |
| 📋 要求 | 保留版权声明和许可声明 |

### MIT 许可证节选

```
MIT License

Copyright (c) 2026 MPlanet Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```

> ⚠️ **免责声明**:
> - 本项目按"原样"提供,作者不承担任何明示或暗示的担保责任
> - 作者不对使用本项目产生的任何直接或间接损失负责
> - 包含的示例代码可能不符合生产环境的安全标准

---

## 相关文档

| 文档 | 说明 |
| --- | --- |
| 📘 [README.md](./README.md) | 项目介绍与快速开始 |
| 📋 [CHANGELOG.md](./CHANGELOG.md) | 版本变更日志 |
| 🤝 [CONTRIBUTING.md](./CONTRIBUTING.md) | 贡献指南 |

> 📌 **建议阅读顺序**:先读 README.md 了解项目,再读 CHANGELOG.md 查看变更,最后阅读本 SECURITY.md 了解安全注意事项。

---

*最后更新:2026/06/24*
