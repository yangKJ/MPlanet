//
//  BannerDetailViewModel.swift
//  WMDiscover
//
//  Created by Condy on 2023/5/29.
//

import Foundation
import FeatBox
import RxNetworks

class BannerDetailViewModel: BaseViewModel, ViewModelEmptiable {
    
    // 缓存已经获取的卡详情数据，卡号为`key`，卡详情数据为`value`
    private var cacheBannerDetail = [String: BannerDetail]()
    // 链式需要
    private let tempBanners = BehaviorRelay<[Banner]>(value: [])
    
    public let banners = PublishRelay<[Banner]>()
    public let currentIndex = PublishRelay<Int>()
    public let datas = PublishRelay<[BannerDetailSection]>()
    
    func requestBannerDetail(with index: Int, banners: [Banner]?) {
        let driver = self.bannerList(banners)
        
        driver.map { $0.isEmpty }.bind(to: isEmptyData).disposed(by: rx.disposeBag)
        
        // 链式获取先获取卡列表再去获取详情
        driver.map { [weak self] in
            self?.tempBanners.accept($0)
            self?.banners.accept($0)
            return $0[safe: index]
        }
        .flatMapLatest(detail(banner:))
        .subscribe(onNext: { [weak self] in
            NetworkLoadingPlugin.hideMBProgressHUD() //链式需主动关闭loading
            guard let banners = self?.tempBanners.value else {
                return
            }
            let top = BannerDetailSection.top(items: [.top(item: banners)])
            let detail = BannerDetailSection.detail(items: [.detail(item: $0)])
            self?.datas.accept([top, detail])
        }).disposed(by: rx.disposeBag)
    }
    
    // 删除缓存数据
    func removeCacheBannerDetail(with detail: BannerDetail) {
        if let key = detail.id?.ai.toString() {
            self.cacheBannerDetail[key] = nil
        }
    }
}

extension BannerDetailViewModel {
    
    private func bannerList(_ list: [Banner]?) -> Observable<[Banner]> {
        if let list = list, list.isEmpty == false {
            return Observable.of(list)
        }
        // 列表为空则去获取数据
        return DiscoverAPI.banner.request()
            .mapHandyJSON(HandyDataModel<[Banner]>.self)
            .map { $0.data ?? [] }
            .observe(on: MainScheduler.instance)
    }
    
    private func detail(banner: Banner?) -> Observable<BannerDetail?> {
        guard let banner = banner else {
            return Observable.of(nil)
        }
        // 先读取缓存数据
        if let key = banner.id?.ai.toString(), let detail = self.cacheBannerDetail[key] {
            return Observable.from(optional: detail) //Tip:这种方式传nil会导致后面订阅不响应
        }
        // 没有则去获取卡详情数据
        return DiscoverAPI.detail(banner).request()
            .mapHandyJSON(HandyDataModel<BannerDetail>.self)
            .observe(on: MainScheduler.instance)
            .map { [weak self] in
                guard var detail = $0.data else {
                    return $0.data
                }
                detail.id = banner.id
                detail.background = UIColor.ai.random
                if let key = banner.id?.ai.toString() {
                    self?.cacheBannerDetail[key] = detail
                }
                return detail
            }
    }
}
