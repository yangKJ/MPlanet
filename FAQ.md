# 常见问题 · FAQ

> 关于 MPlanet 的 15+ 个常见疑问,按主题分块整理。
> 找不到答案?提个 [Issue](https://github.com/yangKJ/MPlanet/issues) 吧。

---

## 📑 目录

- [🧐 这是什么](#-这是什么)
- [🆚 和同类项目区别](#-和同类项目区别)
- [🚀 怎么跑起来](#-怎么跑起来)
- [🧱 怎么新增一个业务模块](#-怎么新增一个业务模块)
- [🤔 架构选择疑问](#-架构选择疑问)
- [🐞 调试与排错](#-调试与排错)
- [📱 兼容性 & 部署](#-兼容性--部署)
- [📜 法律 / 性能 / 测试](#-法律--性能--测试)
- [🔗 模块间通信](#-模块间通信)

---

## 🧐 这是什么

### Q1. MPlanet 是给新手的 iOS 教程吗?

**A**: 不完全是。它面向**有 1-3 年 Swift 经验**、想从「会写 UI」进阶到「懂架构」的中级 iOS 工程师。
如果你刚接触 Swift,建议先看 [The Swift Programming Language](https://docs.swift.org/swift-book/),再来读 MPlanet。

### Q2. MPlanet 是真实的生产项目吗?

**A**: 不是。这是一个**架构演示 + 学习参考项目**,UI 数据多为 mock,业务链路精简。详见 [SECURITY.md](SECURITY.md)。

### Q3. 可以直接拿这套架构做商业项目吗?

**A**: 可以,MIT 协议允许,但请:
- 替换敏感数据(API key、签名、域名)
- 把自研库版本(`Rickenbacker` / `RxNetworks` / `Harbeth` / `ImageX`)锁定到稳定版
- 删掉与业务无关的 demo 模块(`WMDiscover` / `WMMine`)

### Q4. 项目里有多少行代码?

**A**: ~17K 行 Swift,10 个本地 pod。规模适合中型项目起步,**不建议**直接套用到 100+ 模块的超大型 App。

---

## 🆚 和同类项目区别

### Q5. 跟 [MGJRouter](https://github.com/lyujunwei/MGJRouter) / [CTMediator](https://github.com/casatwy/CTMediator) 有什么区别?

**A**:

| 项目 | 路由方案 | 注册方式 | 学习曲线 |
|---|---|---|---|
| MGJRouter | URL 注册 | 显式注册 URL → Handler | 低 |
| CTMediator | Target-Action | 无需注册,反射调用 | 中 |
| **MPlanet** | **Target-Action + 协议驱动** | **无需注册,Model 可直接跳转** | **中-高** |

MPlanet 不是 CTMediator 的 fork,而是**在它基础上的完整工程化** —— 加上 Bridge / MVVM / Metal / Swift 高级语法演示。

### Q6. 跟 [Rickenbacker](https://github.com/yangKJ/Rickenbacker) 重复了?

**A**: 不重复。Rickenbacker 是**基础库**(BaseVC / BaseVM / 通用能力),MPlanet 是**完整工程**(集成 Rickenbacker + 4 大自研库 + 业务模块演示)。

### Q7. 为什么不直接看 RxSwift / SnapKit 官方 Demo?

**A**: 官方 Demo 演示**单一库**用法。MPlanet 演示**多个主流库 + 架构模式 + 业务真实链路**如何协同工作。

---

## 🚀 怎么跑起来

### Q8. `pod install` 失败怎么办?

**A**: 99% 是镜像源问题。按以下顺序排查:

```bash
# 1. 确认 CocoaPods 版本 ≥ 1.13
pod --version

# 2. 清理缓存
pod cache clean --all

# 3. 重新安装(默认走清华镜像)
pod install --repo-update

# 4. 如果仍失败,检查 Podfile 顶部 source 是否被改
# 应该是:source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'
```

### Q9. Xcode 打开后编译报错「linker command failed」?

**A**: 检查:
1. **是否打开了 `.xcodeproj` 而不是 `.xcworkspace`** —— **必须**打开 `MainProject.xcworkspace`
2. **Pods 是否完整生成** —— 重新执行 `pod install`
3. **Architecture 不匹配** —— 模拟器选 `iPhone` 系列,真机选 `Generic iOS Device`

### Q10. 真机调试怎么配?

**A**:

1. Xcode → Signing & Capabilities → Team 选择你自己的开发者账号
2. Bundle Identifier 改成你自己的(默认是 `com.yangkj.MPlanet`,可能冲突)
3. iPhone 通过 USB 连接,信任此电脑
4. 选择你的设备 → Cmd + R 运行

详见 [README.md](README.md) 的「5 分钟跑起来」章节。

### Q11. 编译能过但启动崩溃?

**A**: 90% 是 `Info.plist` 权限问题。打开 `MainProject/Info.plist`,确认相机 / 相册 / 麦克风权限已声明。如果没有,补齐即可。

---

## 🧱 怎么新增一个业务模块

### Q12. 怎么新增一个完整的业务模块?

**A**: 5 步:

1. **复制模板**:复制 `WMModules/WMDiscover` 整个目录,改名为 `WMxxx`
2. **改 podspec**:`name` / `module_name` 全部替换
3. **Podfile 引用**:`pod 'WMxxx', :path => 'DevelopmentPods/WMModules/WMxxx'`
4. **写 Target 类**:新建 `Util/xxxTarget.swift`,暴露 Target-Action 方法
5. **注册到 Mediator**:在 `MediatorExt.swift` 加一行扩展

参考 `WMDiscover/Classes/Util/DiscoverTarget.swift:1` 与 `Mediator/Classes/MediatorExt.swift:114`。

完整教程请阅读 [ARCHITECTURE.md](ARCHITECTURE.md) 的「新增业务模块」章节。

### Q13. 业务模块之间怎么解耦?

**A**: 三大原则:

| 原则 | 做法 |
|---|---|
| **模块单向依赖** | 业务模块之间不能互相 `import`,只能依赖 `FeatBox` / `Mediator` |
| **协议优先于实现** | Model 通过 `Routerable` 协议跳转,不直接引用目标模块类 |
| **Mediator 是唯一入口** | 跨模块调用必须走 `Mediator.xxx`,禁止 `xxxTarget.shared` 直接调用 |

详见 [ARCHITECTURE.md](ARCHITECTURE.md)。

---

## 🤔 架构选择疑问

### Q14. 为什么不使用 SwiftUI?

**A**: 见 [DESIGN.md](DESIGN.md) ADR-0011。核心原因:

- 项目立项时(2020)SwiftUI 尚未稳定
- UIKit 在中型项目里更可控,排查问题更直接
- 业务方多为 UIKit 栈,迁移成本高

> 📌 如果你想做 SwiftUI 版本,可以在 fork 里另起一个 `MainProjectSwiftUI/`。

### Q15. 为什么选 RxSwift 而不是 Combine?

**A**: 见 [DESIGN.md](DESIGN.md) ADR-0007。

| 维度 | RxSwift | Combine |
|---|---|---|
| 跨 iOS 版本 | iOS 9+ | iOS 13+ |
| 生态成熟度 | 高(2015 起) | 中(2019 起) |
| 文档/社区 | 丰富 | 较少 |
| 与 Moya 集成 | 顺滑 | 需自封装 |

iOS 部署目标是 15.0,Combine 可用,但**迁移价值不大**,学习曲线反而更高。

### Q16. 为什么不直接用 Swift Package Manager?

**A**: CocoaPods 在国内有清华镜像,首次安装快;SPM 在 Xcode 里首次解析慢、错误信息不友好。中型项目 CocoaPods 仍是首选。

---

## 🐞 调试与排错

### Q17. 怎么调试 CTMediator?

**A**: 三招:

1. **打断点在 `Mediator.performTarget`**(`Mediator/Classes/MediatorExt.swift:22`),看 `class` / `action` 是否拼写正确
2. **检查 action 末尾的 `:`** —— 带参数必须以 `:` 结尾,代码会自动补,但手动调用容易漏
3. **用 `discoverViewControllerType()`** 先验证类能反射到,再排查具体 action

### Q18. `unrecognized selector` 报错怎么办?

**A**: 99% 是 Target 类名或 Action 名拼错:

- 类名要带 `Target` 后缀(如 `DiscoverTarget`)
- Action 名要跟 Target 类里的 `@objc func` 完全一致
- 带参数的 Action 必须以 `:` 结尾

### Q19. Bridge 模式下 AppDelegate 不生效?

**A**: 检查 `Bridge.init(_:)` 的数组顺序,事件**按顺序**传递给每个子 delegate,后注册的先执行 `openURL`。

---

## 📱 兼容性 & 部署

### Q20. iOS 最低支持版本?

**A**: **iOS 15.0+**(可在 `Podfile` 改 `platform :ios, '13.0'`,但 RxSwift 6.x 需要 Swift 5.7+)

### Q21. Swift 版本要求?

**A**: **Swift 5.9+**,Xcode 15+。Swift 6 兼容性已测试,可用但需要开启 `Strict Concurrency`。

### Q22. 支持 Mac Catalyst / iPadOS 多任务吗?

**A**: 项目默认 iPhone,可以打开 `MainProject/Info.plist` 的 `UISupportedInterfaceOrientations~ipad` 配置支持 iPad,但未专门测试 Catalyst。

---

## 📜 法律 / 性能 / 测试

### Q23. 可以商用吗?

**A**: **可以**,MIT 协议允许。但请:
- 不要用 yangKJ 的名义发布
- 保留原作者致谢
- 自负代码合规与安全责任

### Q24. 性能如何?能撑住百万级 DAU 吗?

**A**: 这是**架构教学项目**,未做压力测试。生产环境还需:
- 接入 APM(友盟 / Sentry / 自研)
- 数据库分库分表
- 网络层做请求合并与缓存策略
- 启动项拆分(冷启动 / 热启动)

### Q25. 测试覆盖率?

**A**: 目前 `Tests/` 目录预留了单元测试入口,**业务模块测试覆盖极低**。如果你想贡献测试代码,参考 `DevelopmentPods/Mediator/Tests/`(待补)。

---

## 🔗 模块间通信

### Q26. 模块间通信支持回调吗?

**A**: **支持**,但要绕一层:

```swift
// ❌ 不推荐:Mediator 同步返回,无法回调
let vc = Mediator.bannerDetailViewController(params: ["id": "123"])

// ✅ 推荐:让目标 VC 本身支持 delegate / closure
// 详见 BannerDetailViewController 的 dismiss 回调
```

也可以通过 `FeatBox.Notify`(Rx 化通知中心)发广播,跨模块订阅即可。

### Q27. 能传递自定义 Model 作为参数吗?

**A**: 受 ObjC runtime 限制,**只能传基本类型 + `NSObject` 子类**。复杂 Model 请传 dict,目标模块自己解析。

详见 [ARCHITECTURE.md](ARCHITECTURE.md) 的「Mediator 限制」。

### Q28. 怎样避免循环依赖?

**A**: 架构强约束:

| 禁止 | 替代 |
|---|---|
| WMDiscover → WMMine | `Mediator.xxx` |
| WMMine → WMDiscover | `Mediator.xxx` |
| FeatBox → AppMain | 反向,必须改 |
| Mediator → 业务模块 | `Mediator` 只做反射,不依赖具体模块 |

详见 [ARCHITECTURE.md](ARCHITECTURE.md) 三大原则。

---

<div align="center">

**还有疑问?** 👉 [GitHub Issues](https://github.com/yangKJ/MPlanet/issues)

[⬆ 回到顶部](#常见问题--faq)

</div>