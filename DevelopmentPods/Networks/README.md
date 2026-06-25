# Networks

> 网络层 —— 基于 Moya + RxSwift 的统一请求封装，搭配 SmartCodable 完成 JSON → Model 自动解析。

[![Platform](https://img.shields.io/badge/platform-iOS%2015%2B-blue)]()
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)]()
[![License](https://img.shields.io/badge/license-MIT-lightgrey)]()

## 作用
- 在 Moya 之上统一 `ApiResponse` 模型与错误处理，把 `Result` 转成业务侧易用的 `Single` 流。
- 通过 `SmartCodable` / `HollowCodable` 自动将后端 JSON 转为业务 Model，并兼容 Hollow 风格的容错解析。
- 提供 `AsyncNetwork`（`withCheckedThrowingContinuation`）以便在 async/await 代码里复用同一套请求。
- 不解决网络层缓存策略（每个业务自行决定），不解决 WebSocket / SSE（不在本 Pod 范围）。

## 依赖关系
- **被依赖**：所有需要网络请求的业务模块。
- **依赖**：`Moya`、`RxSwift`、`SmartCodable`、`HollowCodable`。
- **反向依赖**：业务模块禁止直接 `import Moya`，必须通过 `Networks` 暴露的 `NetworkAPI` 扩展。

## 文件结构
| 路径 | 作用 |
|------|------|
| `Networks/SharedNettable.swift` | 全局共享的 `NetworkNettable` 配置（拦截器 / 日志 / 超时） |
| `Networks/NetworkAPI+Rx.swift` | `NetworkAPI` 的 RxSwift 扩展，返回 `Single<ApiResponse<T>>` |
| `Networks/ApiResponse.swift` | 统一响应壳 `{ code, message, data }` |
| `Networks/SmartCodable+Rx.swift` | SmartCodable 适配 Rx 的解析扩展 |
| `Networks/HollowCodable+Rx.swift` | HollowCodable 容错解析适配 Rx |
| `Networks/AsyncNetwork.swift` | `withCheckedThrowingContinuation` 版的 async/await 入口 |

## 使用示例
```swift
// 1. 定义 Moya Target
enum DiscoverAPI {
    case home
    case bannerDetail(id: String)
}
extension DiscoverAPI: TargetType {
    var path: String { switch self { case .home: "/discover/home"; case .bannerDetail(let id): "/banner/\(id)" } }
    var method: Moya.Method { .get }
    var task: Task { .requestPlain }
}

// 2. 发起请求（Rx 风格）
DiscoverAPI.home
    .request()
    .mapObject(DiscoverHomeModel.self)   // SmartCodable 解析
    .subscribe(onSuccess: { model in }, onFailure: { print($0) })
    .disposed(by: disposeBag)

// 3. async/await 风格
let model = try await AsyncNetwork.request(
    DiscoverAPI.bannerDetail(id: "123"),
    as: BannerDetail.self
)
```

## 维护者
<!-- yangKJ -->