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
    
    public let sections = PublishRelay<[DiscoverSection]>()
    public let banners = PublishRelay<[Banner]>()
    public let discovers = PublishRelay<[Discover]>()
    
    func request() {
        let banners = bannerData().asObservable()
        let discovers = discoverData().asObservable()
        
        discovers.bind(to: self.discovers).disposed(by: rx.disposeBag)
        banners.bind(to: self.banners).disposed(by: rx.disposeBag)
        
        let zip = Observable.zip(banners, discovers)
        
        //zip.map { $0.0.isEmpty && $0.1.isEmpty }.bind(to: isEmptyData).disposed(by: rx.disposeBag)
        
        zip.subscribe(onNext: { [weak self] in
            var sections = [DiscoverSection]()
            if let bannerSection = DiscoverGroupDetailType.banner.createSection(with: $0) {
                sections.append(bannerSection)
            }
            let discoversSections = $1.sorted(by: {
                ($0.sort ?? 0) < ($1.sort ?? 0)
            }).compactMap {
                let title = $0.title ?? "" // 根据主题取不同值
                return $0.module?.createSection(with: $0.datas, title: title)
            }
            sections.append(contentsOf: discoversSections)
            self?.sections.accept(sections)
        }).disposed(by: rx.disposeBag)
    }
}

extension DiscoverViewModel {
    
    func bannerData() -> Driver<[Banner]> {
        DiscoverAPI.banner.request()
            .mapHandyJSON(HandyDataModel<[Banner]>.self)
            .compactMap { $0.data }
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
    }
    
    func discoverData() -> Driver<[Discover]> {
        DiscoverAPI.discoverHome.request()
            .mapHandyJSON(HandyDataModel<[Discover]>.self)
            .compactMap {
                ($0.data as? [Discover])?.map({
                    $0.mutating {
                        $0.datas = $0.module?.deserialized(with: $0.list)
                    }
                })
            }
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
    }
}
