# 架构专题 · Architecture Deep Dive

> 读完这份文档，你会掌握 MPlanet 的**完整调用链**、**模块依赖图**和**底层设计原则**。

## 📑 目录

- [🏛️ 整体架构分层](#️整体架构分层)
- [🔗 模块依赖方向](#模块依赖方向)
- [🚀 一次完整调用链路走读](#一次完整调用链路走读)
- [🎯 三大设计原则](#三大设计原则)
- [⚠️ 反模式清单](#️反模式清单)
- [🔍 调试技巧](#调试技巧)

---

## 整体架构分层

```
┌────────────────────────────────────────────────────┐
│  宿主层                                            │
│  MainProject (AppDelegate + Bridge)              │
└────────────────────┬───────────────────────────────┘
                     │
┌────────────────────┴────────────────────────────────┐
│  业务层（依赖 Mediator）                            │
│  ┌────────────┐  ┌────────────┐                     │
│  │ AppMain    │  │ WMDiscover │  WMMine           │
│  │ (TabBar +  │  │  发现模块  │  我的模块         │
│  │  Launcher) │  │            │                    │
│  └─────┬──────┘  └──────┬─────┘  ─────┬─────┘      │
│        │               │             │            │
└────────┼───────────────┼─────────────┼────────────┘
         │       Mediator 路由层      │
┌────────┴─────────────────────────────┴────────────┐
│  基础设施层（被业务层依赖）                        │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐    │
│  │ FeatBox    │  │ Networks   │  │ Database   │    │
│  │ 基础能力   │  │  网络层    │  │  WCDB     │    │
│  └─────┬──────┘  └─────┬──────┘  └─────┬──────┘    │
│        │               │               │          │
└────────┼───────────────┼───────────────┼──────────┘
         │               │               │
┌────────┴───────────────┴───────────────┴──────────┐
│  通用工具层（被所有上层依赖，不依赖任何人）         │
│  ┌────────────┐  ┌────────────┐                    │
│  │ ProductLib │  │ Componets  │                    │
│  │ 通用工具   │  │ UI 组件库  │                    │
│  └────────────┘  └────────────┘                    │
└────────────────────────────────────────────────────┘
```

**单向依赖规则**：
- 上层可依赖下层
- 下层**绝不**依赖上层
- 业务模块之间通过 `Mediator` 通信，**不直接** import

---

## 模块依赖方向

| 层级 | Pod | 被谁依赖 | 依赖谁 |
|---|---|---|---|
| 宿主 | MainProject | — | AppMain |
| 业务 | AppMain | MainProject | FeatBox, Componets, ProductLib |
| 业务 | WMDiscover | — | FeatBox, Mediator, Networks, Componets, ProductLib |
| 业务 | WMMine | — | FeatBox, Mediator, Networks, Componets, ProductLib |
| 路由 | Mediator | 业务模块 | Foundation, ObjectiveC |
| 基础 | FeatBox | 业务、宿主 | ProductLib, Componets |
| 基础 | Networks | 业务 | ProductLib |
| 基础 | Database | 业务 | ProductLib |
| 基础 | RootManager | 宿主 | ProductLib |
| 工具 | ProductLib | 所有上层 | Foundation, UIKit |
| 工具 | Componets | 所有上层 | ProductLib, UIKit |

---

## 一次完整调用链路走读

> 场景：在 WMMine 模块中点击「发现」Tab，跳转到 WMDiscover 的 DiscoverViewController。

### 第 1 步：触发跳转

```swift
// DevelopmentPods/WMModules/WMMine/.../MineViewController.swift
self.tabBarController?.selectedIndex = 0  // 切到"发现"Tab
```

`WMTabBarController` 监听登录态变化，通过 `Mediator` 反射创建各 Tab 对应的 VC。

[`DevelopmentPods/AppMain/AppMain/Classes/WMTabBarController.swift:75-106`](DevelopmentPods/AppMain/AppMain/Classes/WMTabBarController.swift)

### 第 2 步：Mediator 反射调用

```swift
// DevelopmentPods/Mediator/Mediator/Classes/MediatorExt.swift
@objc public func perform<T>(targetName: String,
                             actionName: String,
                             params: [String: Any]? = nil) -> T? {
    let targetClassName = "Target_\(targetName)"
    let actionSelector = NSSelectorFromString("Action_\(actionName):")
    guard let targetClass = NSClassFromString(targetClassName),
          let target = (targetClass as? NSObject.Type)?.init() else {
        return nil
    }
    return target.perform(actionSelector)?.takeUnretainedValue() as? T
}
```

关键点：
- 类名规范：`Target_<ModuleName>`（`Target_Discover`、`Target_WMMine`）
- Action 规范：`Action_<actionName>:`（冒号表示带参数）
- 反射调用，**不需要** import 目标模块

### 第 3 步：Target 类返回 VC

```swift
// DevelopmentPods/WMModules/WMDiscover/.../Util/DiscoverTarget.swift
@objc public final class DiscoverTarget: NSObject {
    @objc public func Action_viewController(_ params: [String: Any]?) -> UIViewController {
        return DiscoverViewController()
    }
    
    @objc public func Action_bannerDetailViewController(_ params: [String: Any]?) -> UIViewController {
        return BannerDetailViewController(id: params?["id"] as? String)
    }
}
```

每个业务模块都有 `Target_xxx` 类，作为"对外门面"。

### 第 4 步：VC 注入 ViewModel

```swift
// DevelopmentPods/FeatBox/FeatBox/Base/BaseViewController.swift
class BaseViewController: UIViewController {
    public var viewModel: BaseViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()  // 绑定 VM 的 Output 到 UI
    }
}
```

### 第 5 步：ViewModel 发起网络请求

```swift
// DevelopmentPods/FeatBox/FeatBox/Base/BaseViewModel.swift
class BaseViewModel {
    func request<T>(_ api: TargetType) -> Observable<T> {
        return NetworkAPI.shared.request(api)
            .observe(on: MainScheduler.instance)
    }
}
```

### 第 6 步：Routerable 接管跳转

```swift
// DevelopmentPods/FeatBox/FeatBox/Core/Routerable.swift
protocol Routerable {
    var router: FunctionType { get }
}

extension Routerable {
    @discardableResult
    func goto(_ type: FunctionType) -> UIViewController? {
        return type.goto(self)  // 通过 Mediator 跳
    }
}
```

业务侧调用：
```swift
struct DiscoverModel: Routerable {
    let id: String
    var router: FunctionType { .bannerDetail(id: id) }
}

// 任意地方都可以
discoverModel.goto(.bannerDetail(id: "123"))
```

---

## 三大设计原则

### 原则 1：模块单向依赖

业务模块**只能**依赖基础设施层，**不能**反向依赖。业务模块之间通过 `Mediator` 通信。

```swift
// ❌ 错误：业务模块 A 直接 import B
import WMDiscover  // 反向依赖

// ✅ 正确：通过 Mediator
let vc = Mediator.shared.perform(targetName: "WMDiscover", ...)
```

### 原则 2：协议优先于实现

公开 API 用 `protocol` 暴露，隐藏具体实现。例如 `Routerable`、`AuthVerificationable`。

```swift
// 业务侧只依赖协议，不依赖具体类
struct DiscoverModel: Routerable { ... }
```

### 原则 3：Mediator 是唯一注册入口

业务模块间通信**只**走 `Mediator.performTarget()`，禁止其他形式的硬编码跳转。

---

## 反模式清单

> ❌ 这些写法会让组件化**失效**。

### 1. 业务模块反向 import

```swift
// ❌ 错误
import WMDiscover
let vc = DiscoverViewController()

// ✅ 正确
let vc = Mediator.shared.perform(targetName: "WMDiscover", actionName: "viewController")
```

### 2. 单例 + 全局可变状态

```swift
// ❌ 错误：全局可变
public static var environment = EnvironmentType.develop
```

### 3. 协议方法返回 nil 时不处理

```swift
// ❌ 错误
let vc = Mediator.shared.perform(...)  // 假设一定有值
navigationController?.pushViewController(vc!, animated: true)  // crash if nil

// ✅ 正确
guard let vc = Mediator.shared.perform(...) else { return }
navigationController?.pushViewController(vc, animated: true)
```

### 4. 在 closure 中强引用 self

```swift
// ❌ 错误：retain cycle
Observable.timer(.seconds(1))
    .subscribe(onNext: { _ in
        self.doSomething()  // 强引用
    })

// ✅ 正确
Observable.timer(.seconds(1))
    .subscribe(onNext: { [weak self] _ in
        self?.doSomething()
    })
```

### 5. ViewModel 持有 View（反向依赖）

```swift
// ❌ 错误
class DiscoverViewModel {
    weak var view: DiscoverViewController?  // VM 不应知道 View
}

// ✅ 正确：通过 Rx Subject 通知
class DiscoverViewModel {
    let items = PublishRelay<[Item]>()
    let loading = BehaviorRelay<Bool>(value: false)
}
```

---

## 调试技巧

### 1. `performTarget` 返回 nil 怎么排查

按以下顺序检查：

1. **类名规范**：`Target_<ModuleName>`，大小写敏感
2. **Action 名**：`Action_<actionName>:`，带参数必须有冒号
3. **Target 类**是否被编译进二进制（检查 `pod install` 是否成功）
4. **Target 类**是否声明 `@objc`、是否继承自 `NSObject`
5. **Action 方法**是否声明 `@objc`

```swift
// 在 Mediator 反射处打断点，检查：
let targetClass = NSClassFromString("Target_Discover")
// nil → 类没编译进二进制
// 非 nil → 类存在，继续往下走
```

### 2. 日志打点

在关键路径加 `print` 或 `os_log`：

```swift
print("🔗 [Mediator] perform: target=\(targetName), action=\(actionName)")
```

### 3. 用 LLDB 反射

```lldb
po NSClassFromString("Target_Discover")
po NSClassFromString("Target_WMMine")
```

### 4. 检查 Mediator 缓存

```swift
// 清空缓存（处理 VC 状态污染）
Mediator.shared.clearCache()
```

---

## 进阶：架构演进路径

```
当前：CTMediator 字符串路由
  ↓
演进 1：路由表抽到配置文件（JSON/YAML）
  ↓
演进 2：协议化注册（每个 Target 配一个 Swift Protocol）
  ↓
演进 3：完全去掉字符串，全协议通信
```

详见 [DESIGN.md ADR-0002](DESIGN.md#adr-0002-选择-ctmediator-而非-mgjrout)。

---

> 文档导航：[🏠 根 README](README.md) · [📝 CHANGELOG](CHANGELOG.md) · [❓ FAQ](FAQ.md) · [💡 DESIGN](DESIGN.md) · [🤝 CONTRIBUTING](CONTRIBUTING.md)
