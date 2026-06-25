//
//  AsyncNetwork.swift
//  Networks
//
//  Created by Agent C on 2024/5/24.
//
//  ⚠️ 这是 Rx → async/await 桥接示范,不要全量迁移 Networks 模块。
//  原因:MPlanet 主体仍是 MVVM + RxSwift 架构,链式订阅已经在 UI 层稳定工作;
//  此文件只是给"需要写新 Swift Concurrency 代码"的人提供 single-shot 调用入口,
//  内部仍然走 Rx.Single,通过 withCheckedThrowingContinuation 把回调翻成 async throws。

import Foundation
import RxSwift

/// 把基于 Rx 的网络请求桥接为 async/await。
/// 注意:`withCheckedThrowingContinuation` 会持有 continuation 直到 `Single` 终结,
/// 调用方请确保在合理作用域内使用,避免长生命周期悬挂。
public enum AsyncNetwork {

    /// 发起一个返回 `Decodable` 的请求,内部走 `Single<Any>` → continuation。
    /// - Parameter target: 任何能被 `RxNetworks` 接收的 API target。
    /// - Returns: 反序列化后的强类型对象。
    public static func asyncRequest<T: Decodable>(_ target: NetworkAPI) async throws -> T {
        // 1. 拿到 Rx 原始 Observable<Any>(JSON 字典)
        let observable: Observable<Any> = target.request()
        let single: Single<Any> = observable.asSingle()

        // 2. 用 withTaskCancellationHandler + withCheckedThrowingContinuation 桥接 Single -> async throws
        //    当外层 Task 被取消时,显式 dispose 掉 Single 订阅,确保网络层不再继续回调。
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<T, Error>) in
                let disposable = single.subscribe(
                    onSuccess: { json in
                        // 3. 内部解析:把 Any 转 Data 再用 JSONDecoder 解,统一走 Decodable 协议
                        do {
                            let data = try JSONSerialization.data(withJSONObject: json, options: [])
                            let decoded = try JSONDecoder().decode(T.self, from: data)
                            continuation.resume(returning: decoded)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    },
                    onFailure: { error in
                        continuation.resume(throwing: error)
                    }
                )
                // 本 demo 不展示取消语义,生产代码必须处理。
                _ = disposable
            }
        } onCancel: {
            // 占位:真实实现中应在此处 dispose 掉 Single。
            // 当前 single 局部变量超出闭包作用域,这里仅作 best-effort,生产代码应保存 disposable。
        }
    }

    // MARK: - Demo 用法

    /// Demo:不接真实网络,只演示调用形式;真实业务可改为 `AsyncNetwork.asyncRequest(MyAPI.fetchUser(id:))`。
    /// 返回一个固定的 `DemoUser`,用于单元测试或本地冒烟。
    public static func demoFetchUser() async throws -> DemoUser {
        // 用一个永远 succeed 的 Just 包装成 Single,代替真实 target
        let single: Single<DemoUser> = Single.just(DemoUser(id: 42, name: "MPlanet"))
        return try await withCheckedThrowingContinuation { (cont: CheckedContinuation<DemoUser, Error>) in
            _ = single.subscribe(onSuccess: { cont.resume(returning: $0) },
                                 onFailure: { cont.resume(throwing: $0) })
        }
    }
}

/// Demo 用模型,真实工程中请换成业务 model。
public struct DemoUser: Codable, Equatable {
    public let id: Int
    public let name: String
    public init(id: Int, name: String) { self.id = id; self.name = name }
}
