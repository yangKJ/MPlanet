//
//  DiscoverViewModel.swift
//  WMDiscover
//
//  Created by Condy on 2020/12/28.
//

import UIKit
import Rickenbacker
import RxNetworks
import RxCocoa

class DiscoverViewModel: ViewModel {
    
    let banners: BehaviorRelay<[Banner]> = BehaviorRelay(value: [])
    
    func loadData() {
        Driver.zip(bannerData(), detailData())
            .asObservable()
            .subscribe(onNext: { [weak self] (banner, detail) in
                self?.banners.accept(banner)
            }).disposed(by: disposeBag)
    }
}

extension DiscoverViewModel {
    
    func bannerData() -> Driver<[Banner]> {
        DiscoverAPI.banner.request()
            .mapHandyJSON(HandyDataModel<[Banner]>.self)
            .map { $0.data }
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
    }
    
    func detailData() -> Driver<String> {
        Driver.of("amp")
    }
}
