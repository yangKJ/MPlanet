//
//  WalletViewModel.swift
//  WMWallet
//
//  Created by Condy on 2020/12/28.
//

import UIKit
import Rickenbacker
import FeatBox

class WalletViewModel: BaseViewModel {
    struct Input { }
    struct Output {
        let sections: Observable<[WalletSection]>
        let displayEmptyView: Driver<Bool>
        let displayHomeView: Driver<Bool>
    }
}

extension WalletViewModel: ViewModelType {
    
    func transform(input: WalletViewModel.Input) -> WalletViewModel.Output {
        let wallet = input.queryWalletDatabase()
        
        let displeyEmptyView = wallet.map { $0 != nil }.asDriver(onErrorJustReturn: true)
        let displayHomeView  = wallet.map { $0 == nil }.asDriver(onErrorJustReturn: true)
        let sections = wallet.flatMapLatest(input.setupWalletSection)
        
        return Output(sections: sections, displayEmptyView: displeyEmptyView, displayHomeView: displayHomeView)
    }
}

extension WalletViewModel.Input {
    
    /// 配置组装钱包首页模型
    /// - Parameter database: 当前选择的钱包数据
    func setupWalletSection(_ wallet: WalletData?) -> Observable<[WalletSection]> {
        guard let wallet = wallet else {
            return Observable.never().observe(on: MainScheduler.instance)
        }
        return Observable.create { observer in
            // 1.先读取本地数据
            Observable.zip(
                queryWalletApplicationList(wallet),
                queryWalletTokenList(wallet)
            ).subscribe(onNext: {
                let asset = WalletSection.asset(items: [.asset(item: wallet)])
                let application = WalletSection.application(items: [.application(item: $0)])
                let tokenList = WalletSection.token(items: $1.map { .token(item: $0) })
                observer.onNext([asset, application, tokenList])
            })
            // 2.再从网络拉取
            
            return Disposables.create { }
        }.observe(on: MainScheduler.instance)
    }
}

// MARK: - 数据库获取
extension WalletViewModel.Input {
    
    /// 读取当前选择的钱包模型
    func queryWalletDatabase() -> Observable<WalletData?> {
        let wallet = WalletData.querySelectedWallet()
        return Observable.just(wallet).observe(on: CurrentThreadScheduler.instance)
    }
    
    /// 获取应用列表
    /// - Parameter wallet: 钱包模型
    func queryWalletApplicationList(_ wallet: WalletData) -> Observable<[WalletApplicationData]> {
        guard let ID = wallet.ID else {
            return Observable.just([]).observe(on: CurrentThreadScheduler.instance)
        }
        let list = WalletApplicationData.query(walletID: ID)
        return Observable.just(list).observe(on: CurrentThreadScheduler.instance)
    }
    
    /// 获取代币列表
    /// - Parameter wallet: 钱包模型
    func queryWalletTokenList(_ wallet: WalletData) -> Observable<[WalletTokenData]> {
        guard let ID = wallet.ID else {
            return Observable.just([]).observe(on: CurrentThreadScheduler.instance)
        }
        let list = WalletTokenData.query(walletID: ID)
        return Observable.just(list).observe(on: CurrentThreadScheduler.instance)
    }
}

// MARK: - 网络获取
extension WalletViewModel.Input {
    
}
