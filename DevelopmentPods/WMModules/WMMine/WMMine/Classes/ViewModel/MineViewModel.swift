//
//  MineViewModel.swift
//  WMMine
//
//  Created by Condy on 2020/12/28.
//

import UIKit
import Rickenbacker

class MineViewModel: ViewModel, ViewModelEmptiable, ViewModelHeaderAndFooterable {
    
    let dataSource: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    func loadData() {
        let driver = NetworkService().randomResult().asObservable()
        driver.bind(to: dataSource).disposed(by: disposeBag)
        driver.map { $0.isEmpty }.bind(to: isEmptyData).disposed(by: disposeBag)
        driver.subscribe { _ in } onCompleted: {
            self.refreshSubject.onNext(.endHeaderRefresh)
        }.disposed(by: disposeBag)
    }
}

// MARK: - 模拟网络请求
fileprivate struct NetworkService {
    static var index: Int = 0
    func randomResult() -> Driver<[String]> {
        NetworkService.index += 1
        if NetworkService.index % 2 == 1 {
            return Observable.just([])
                .delay(.seconds(2), scheduler: MainScheduler.instance)
                .asDriver(onErrorDriveWith: Driver.empty())
        }
        let items = (0 ... 19).map { _ in
            "Random data \(Int(arc4random() % 700))"
        }
        let observable = Observable.just(items)
        return observable
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorDriveWith: Driver.empty())
    }
}
