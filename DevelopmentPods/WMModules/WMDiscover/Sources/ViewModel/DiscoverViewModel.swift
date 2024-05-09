//
//  DiscoverViewModel.swift
//  WMDiscover
//
//  Created by Condy on 2020/12/28.
//

import FeatBox
import RxNetworks
import RxCocoa

class DiscoverViewModel: BaseViewModel, ViewModelEmptiable {
    public let banners = PublishRelay<[Banner]>()
    public let datas = PublishRelay<[DiscoverSection]>()
    
    func request() {
        let progressItems = progressItems().asObservable()
        let banners = bannerData().asObservable()
        
        let zip = Observable.zip(banners, progressItems)
        
        banners.bind(to: self.banners).disposed(by: rx.disposeBag)
        
        zip.subscribe(onNext: { [weak self] in
            let progressItems = DiscoverSection.progress(items: [.progress(item: $1)])
            self?.datas.accept([progressItems])
        }).disposed(by: rx.disposeBag)
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
    
    func progressItems() -> Observable<[DiscoverProgressItem]> {
        let items = ["开放期开始", "开放期结束", "确认日", "下一开放期开始", "下一开放期结束"]
        let itemss = items.map { name in
            var item = DiscoverProgressItem.init()
            item.title = name
            return item
        }
        return Observable.of(itemss)
    }
}
