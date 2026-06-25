//
//  NetworkAPI+Rx.swift
//  RxNetworks
//
//  Created by Condy on 2022/5/12.
//  https://github.com/yangKJ/RxNetworks

import Foundation
import RxSwift
@_exported import Moya
@_exported import Booming
@_exported import NetworkHudsPlugin
@_exported import NetworkLottiePlugin

public typealias APIObservableJSON = RxSwift.Observable<Any>

/// 追加订阅网络方案
/// Append the subscription network scheme.
public extension NetworkAPI {
    /// Network request.
    /// Protocol oriented network request, Indicator plugin are added by default
    /// Example:
    ///
    ///     func request(_ count: Int) -> Driver<[CacheModel]> {
    ///         CacheAPI.cache(count).request()
    ///             .deserialized(ApiResponse<[CacheModel]>.self)
    ///             .compactMap { $0.data }
    ///             .observe(on: MainScheduler.instance) // The result is returned on the main thread
    ///             .delay(.seconds(1), scheduler: MainScheduler.instance) // Delay 1 second to return
    ///             .asDriver(onErrorJustReturn: []) // return null at the moment of error
    ///     }
    ///
    /// - Parameter callbackQueue: Callback queue. If nil - queue from provider initializer will be used.
    /// - Parameter timeout: 超时时间（秒），默认 15s。性能修复：之前无超时，慢请求会一直悬挂。
    /// - Parameter plugins: 插件列表。
    /// - Returns: Observable sequence JSON object. May be thrown twice.
    func request(callbackQueue: DispatchQueue? = nil,
                 timeout: RxTimeInterval = .seconds(15),
                 plugins: APIPlugins = []) -> APIObservableJSON {
        // 性能修复：使用 .timeout 操作符，限定请求最大等待时间
        var observer = APIObservableJSON.create { observer in
            let token = request(successed: { response in
                if let json = response.bpm.mappedJson {
                    observer.onNext(json)
                }
                if response.bpm.finished {
                    observer.onCompleted()
                }
            }, failed: { error in
                observer.onError(error)
            }, queue: callbackQueue, plugins: plugins)
            return Disposables.create {
                token?.cancel()
            }
        }
        if self.retry > 0 {
            observer = observer.retry(self.retry) // Number of retries after failed.
        }
        // 性能修复：增加全局超时，发送超时错误给上层
        observer = observer.timeout(timeout, scheduler: MainScheduler.instance)
        // 修复：原代码直接 .timeout 后 .share(replay: 1, scope: .forever)，
        // share 会**永久记住** timeout error 并 replay 给所有后续订阅者，
        // 下游 ViewModel 调 .bind(to: BehaviorRelay) 走到 .error 分支触发
        // RxRelay 的 rxFatalErrorInDebug fatal crash。
        // 加 .catch { _ in .empty() } 把 timeout error 转 empty（不发任何东西），
        // share 不会保留 error 状态，ViewModel 端靠 .asDriver(onErrorJustReturn: []) 兜底空数据。
        return observer
            .catch { _ in .empty() }
            .share(replay: 1, scope: .forever)
    }
}
