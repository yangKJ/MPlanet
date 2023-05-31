//
//  DiscoverViewModel.swift
//  WMDiscover
//
//  Created by Condy on 2020/12/28.
//

import FeatBox
import Rickenbacker
import RxNetworks
import RxCocoa

class DiscoverViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let header: Bool
    }
    
    struct Output {
        let banners: Observable<[Banner]>
    }
    
    func transform(input: Input) -> Output {
        let banners = {
            if input.header {
                return bannerData().asObservable()
            } else {
                return Observable.of([])
            }
        }()
        
        return Output(banners: banners)
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
}
