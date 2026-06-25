//
//  BaseViewModel.swift
//  FeatBox
//
//  Created by Condy on 2023/4/29.
//

import Foundation
import Rickenbacker
import RxSwift
import RxRelay

open class BaseViewModel: ViewModel {

    /// 错误信号:VM 内部任意错误(网络/解析/业务)统一发到这里
    public let errorSubject = PublishRelay<Error>()

    /// 加载中状态:BehaviorRelay 保证新订阅者立刻能拿到当前值
    public let loadingRelay = BehaviorRelay<Bool>(value: false)

    /// 是否为空态:通常列表数据为空时 push true
    public let emptyRelay = BehaviorRelay<Bool>(value: false)
    // why: 三个 Relay 配合 BaseVC.showState,
    // 让子类只需在合适时机 push,UI 自动切换 loading/content/empty/error。
    // 用 BehaviorRelay 而非 PublishRelay 是为了让后到的订阅者也能拿到当前态,
    // 避免 VC 晚于 VM 创建时错过首屏状态。
}
