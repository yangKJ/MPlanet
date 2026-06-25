# 设计决策记录 · Design Decision Records

> **MPlanet** 移动端架构组采用 **ADR(Architecture Decision Record)** 模式沉淀关键技术决策。每条记录聚焦"为什么这样选"而非"做了什么",便于团队成员、新人 onboarding 以及未来的"考古"工作。

## 🎯 为什么采用 ADR 模式

| 优势 | 说明 |
|------|------|
| 📌 **可追溯** | 每条决策都有时间戳和上下文,避免"为什么当时这么写"的争论 |
| 🧠 **知识沉淀** | 人员流动时,设计思想留在仓库里而非 Slack 历史 |
| ⚖️ **权衡透明** | 列出被否决的选项及原因,避免后人重复走弯路 |
| 🔄 **可演进** | 状态字段支持 `已采纳 / 已废弃 / 已替代`,支持架构演进 |
| 🤝 **协作对齐** | 跨团队 review 时,ADR 是天然的 RFC 入口 |

我们借鉴 Michael Nygard 的 ADR 模板并本土化:用中文书写、加入 emoji、关联具体代码路径,让"读起来像聊天"而不是"看起来像论文"。

---

## ADR-0001: 选择 CocoaPods 而非 SPM

- **状态**:已采纳
- **日期**:2024-03
- **背景**:项目立项时 Swift Package Manager 在二进制分发、ABI 稳定、私有仓库鉴权上尚未成熟;团队有大量基于 `.podspec` 的存量工具链
- **选项**:
  - A. CocoaPods(推荐) ✅
  - B. Swift Package Manager
  - C. Carthage
- **决策**:A
- **后果**:工具链成熟、生态丰富、IDE 集成稳定;代价是 `pod install` 启动慢、Workspace 索引膨胀
- **参考**:`DevelopmentPods/AppMain/Podfile`、`DevelopmentPods/FeatBox/FeatBox.podspec`

```ruby
# 典型 podspec
Pod::Spec.new do |s|
  s.name = "FeatBox"
  s.version = "1.0.0"
  s.source_files = "FeatBox/**/*.swift"
end
```

---

## ADR-0002: 选择 CTMediator 而非 MGJRouter

- **状态**:已采纳
- **日期**:2024-03
- **背景**:模块化拆解后需要 URL/Target 路由方案;团队要求无反射、编译期可检查
- **选项**:
  - A. CTMediator(推荐) ✅
  - B. MGJRouter
  - C. 自研协议路由
- **决策**:A
- **后果**:基于 `performTarget:action:` 的纯调用,无 `performSelector` 警告,可被静态分析器识别
- **参考**:`DevelopmentPods/Mediator/`

```swift
// CTMediator 调用示例
let vc = Mediator.shared.featBox_homeModule(params: ["id": 1])
```

---

## ADR-0003: 选择 RxSwift 而非 Combine

- **状态**:已采纳
- **日期**:2024-04
- **背景**:项目要求最低支持 iOS 13;Combine 在 iOS 13 行为不稳定且 API 与 SwiftUI 耦合较深
- **选项**:
  - A. RxSwift + RxCocoa(推荐) ✅
  - B. Combine
  - C. 纯闭包回调
- **决策**:A
- **后果**:跨版本稳定、操作符丰富、团队学习曲线低;代价是包体积 +1.5MB
- **参考**:`DevelopmentPods/Networks/`、`DevelopmentPods/FeatBox/FeatBox/Base/BaseViewModel.swift`

---

## ADR-0004: 选择 Moya 而非 Alamofire 直用

- **状态**:已采纳
- **日期**:2024-04
- **背景**:多业务线共享同一后端,需要按"业务域"隔离 endpoint 配置;Alamofire 直用会散落 URL 字符串
- **选项**:
  - A. Moya(推荐) ✅
  - B. Alamofire + 自封装
  - C. URLSession 原生
- **决策**:A
- **后果**:把 endpoint 抽象为 enum,编译器强制补全;插件机制天然支持日志、缓存、Token 注入
- **参考**:`DevelopmentPods/Networks/`

```swift
enum UserAPI {
  case login(phone: String, code: String)
}
extension UserAPI: TargetType {
  var path: String {
    switch self {
    case .login: return "/v1/user/login"
    }
  }
}
```

---

## ADR-0005: 选择 SnapKit 而非 Auto Layout DSL

- **状态**:已采纳
- **日期**:2024-05
- **背景**:团队期望 UI 代码可读性、可维护性兼得;Apple 原生 NSLayoutConstraint 写法冗长
- **选项**:
  - A. SnapKit(推荐) ✅
  - B. Cartography
  - C. UIKit Auto Layout 原生
  - D. SwiftUI(未采纳原因见 ADR-0013)
- **决策**:A
- **后果**:链式语法紧凑、可读性高;Chained 闭包让约束和属性同位置定义
- **参考**:`DevelopmentPods/Componets/Componets/`

```swift
view.snp.makeConstraints { make in
  make.top.equalTo(safeArea).offset(12)
  make.leading.trailing.equalToSuperview().inset(16)
}
```

---

## ADR-0006: 选择 WCDB 而非 FMDB / Core Data

- **状态**:已采纳
- **日期**:2024-05
- **背景**:本地存储需要 ORM + 高性能 + 加密 + 跨进程访问能力
- **选项**:
  - A. WCDB(推荐) ✅
  - B. FMDB
  - C. Core Data
  - D. GRDB
- **决策**:A
- **后果**:微信团队出品、底层基于 SQLite、ORM 语法糖接近 Swift Codable;代价是仅支持 iOS/macOS
- **参考**:`DevelopmentPods/Database/`

```swift
// 模型绑定
class User: WCDB.TableCodable {
  var name: String = ""
  var age: Int = 0
  static var tableName = "user"
}
```

---

## ADR-0007: 选择 Lottie 而非 SVGA

- **状态**:已采纳
- **日期**:2024-06
- **背景**:运营活动大量使用动画;设计同学使用 After Effects 导出
- **选项**:
  - A. Lottie(推荐) ✅
  - B. SVGA
  - C. GIF / 帧动画
- **决策**:A
- **后果**:JSON 体积小、运行时可控(进度/速度);生态成熟(airbnb/lottie-ios)
- **参考**:`DevelopmentPods/Componets/Componets/RippleEffectView.swift`

```swift
let animationView = LottieAnimationView(name: "ripple")
animationView.loopMode = .loop
animationView.play()
```

---

## ADR-0008: 选择 HBDNavigationBar 而非纯 UIKit NavigationBar

- **状态**:已采纳
- **日期**:2024-06
- **背景**:需要全局统一导航栏样式、解决大标题与透明导航栏的兼容性
- **选项**:
  - A. HBDNavigationBar(推荐) ✅
  - B. UIKit 原生
  - C. 全屏 Push + 自绘 Header
- **决策**:A
- **后果**:一行代码切主题色、解决 iOS 14+ 滚动时样式丢失问题;维护活跃
- **参考**:`DevelopmentPods/AppMain/AppMain/Classes/WMNavigationController.swift`

---

## ADR-0009: 选择 ESTabBarController 而非自定义 TabBar

- **状态**:已采纳
- **日期**:2024-07
- **背景**:产品要求 TabBar 中间凸起按钮 + 抖动动画 + 角标联动
- **选项**:
  - A. ESTabBarController(推荐) ✅
  - B. UITabBarController 自定义
  - C. RDVTabBarController(已归档)
- **决策**:A
- **后果**:中间凸起按钮开箱即用、动画系统丰富、Badge 联动逻辑完善
- **参考**:`DevelopmentPods/AppMain/AppMain/Classes/WMTabBarController.swift`

```swift
let tabBar = ESTabBarController()
let customItem = ESTabBarItemContentView()
customItem.image = UIImage(named: "plus")
```

---

## ADR-0010: 选择 @propertyWrapper 而非 @AppStorage

- **状态**:已采纳
- **日期**:2024-08
- **背景**:需要统一管理 UserDefaults 读写、Key 命名空间、防误覆盖
- **选项**:
  - A. 自研 @propertyWrapper(推荐) ✅
  - B. @AppStorage(SwiftUI)
  - C. 直接 UserDefaults.standard
- **决策**:A
- **后果**:Key 编译期常量检查、支持自定义序列化、跨 Target 复用
- **参考**:`DevelopmentPods/AppMain/AppMain/Classes/AppMainUtil.swift`

```swift
@propertyWrapper
struct Stored<Value: Codable> {
  let key: String
  var wrappedValue: Value? {
    get { UserDefaults.standard.decode(forKey: key) }
    set { UserDefaults.standard.encode(newValue, forKey: key) }
  }
}
```

---

## ADR-0011: 选择 Wrapper 命名空间协议

- **状态**:已采纳
- **日期**:2024-09
- **背景**:模块间常量、URL Scheme、错误码需要统一管理,避免分散在各处
- **选项**:
  - A. Wrapper 命名空间协议(推荐) ✅
  - B. 单例全局常量
  - C. enum 嵌套
- **决策**:A
- **后果**:类型安全、模块边界清晰、自动补全友好
- **参考**:`DevelopmentPods/AppMain/AppMain/Classes/AppMainTarget.swift`

```swift
protocol NamespaceWrappable {
  associatedtype Wrapper
  static var app: Wrapper.Type { get }
}
extension URL {
  struct App {
    let url: URL
    var home: URL { url.appendingPathComponent("home") }
  }
}
extension URL: NamespaceWrappable {
  static var app: App.Type { App.self }
}
```

---

## ADR-0012: 选择 Bridge 模式拆分 AppDelegate

- **状态**:已采纳
- **日期**:2024-10
- **背景**:AppDelegate 中三方 SDK 回调、推送、Crash 上报、统计埋点混杂,维护成本高
- **选项**:
  - A. Bridge 模式 + AppMain(推荐) ✅
  - B. 全部写在一个文件
  - C. SwiftUI App lifecycle(不兼容 UIKit 项目)
- **决策**:A
- **后果**:每三方一个 Bridge,符合开闭原则;新增/移除 SDK 不动 AppDelegate 主体
- **参考**:`DevelopmentPods/AppMain/AppMain/Classes/AppMainTarget.swift`

```swift
protocol AppMainBridge {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions opts: [UIApplication.LaunchOptionsKey: Any]?)
}
class AppMainTarget {
  private var bridges: [AppMainBridge] = []
  func attach(_ bridge: AppMainBridge) { bridges.append(bridge) }
}
```

---

## ADR-0013: 选择 iOS 15+ 作为最低部署目标

- **状态**:已采纳
- **日期**:2024-11
- **背景**:Swift Concurrency、AsyncSequence、Navigation API 等能力需要现代 OS;产品统计 iOS 15 覆盖率已达 92%
- **选项**:
  - A. iOS 15+(推荐) ✅
  - B. iOS 13(覆盖最广)
  - C. iOS 16+
- **决策**:A
- **后果**:可使用 `async/await`、`@MainActor` 简化代码;但需放弃约 8% 老用户
- **参考**:`DevelopmentPods/AppMain/Podfile`

```ruby
platform :ios, '15.0'
```

---

## 📊 ADR 总览表

| 编号 | 决策 | 状态 | 影响范围 |
|------|------|------|---------|
| ADR-0001 | CocoaPods | ✅ 已采纳 | 工程基础设施 |
| ADR-0002 | CTMediator | ✅ 已采纳 | 模块化路由 |
| ADR-0003 | RxSwift | ✅ 已采纳 | 异步流 |
| ADR-0004 | Moya | ✅ 已采纳 | 网络层 |
| ADR-0005 | SnapKit | ✅ 已采纳 | UI 布局 |
| ADR-0006 | WCDB | ✅ 已采纳 | 本地存储 |
| ADR-0007 | Lottie | ✅ 已采纳 | 动效 |
| ADR-0008 | HBDNavigationBar | ✅ 已采纳 | 导航 |
| ADR-0009 | ESTabBarController | ✅ 已采纳 | Tab 栏 |
| ADR-0010 | @propertyWrapper | ✅ 已采纳 | 偏好存储 |
| ADR-0011 | Wrapper 命名空间 | ✅ 已采纳 | 常量管理 |
| ADR-0012 | Bridge 模式 | ✅ 已采纳 | AppDelegate |
| ADR-0013 | iOS 15+ | ✅ 已采纳 | 部署目标 |

> 📝 **维护说明**:新增 ADR 请在表格末尾追加并保持编号连续;废弃的 ADR 不要删除,仅修改状态字段,保留历史。
