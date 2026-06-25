//
//  BannerDetailViewModel.swift
//  WMDiscover
//
//  Created by Condy on 2023/5/29.
//

import Foundation
import FeatBox

class BannerDetailViewModel: BaseTableViewModel, ViewModelEmptiable {
    
    private var cacheBannerDetail = [String: BannerDetail]()
    
    public let banners = BehaviorRelay<[Banner]>(value: [])
    public let currentIndex = PublishRelay<Int>()
    public let detailTitle = PublishRelay<String?>()
    
    func requestBannerDetail(with index: Int, banners: [Banner]?) {
        // 修复 bag 叠加：每次请求重置 disposeBag，避免旧的订阅继续接收导致重复渲染。
        // ⚠️ A.5 P2 范围外,`rx.disposeBag = DisposeBag()` 在当前推断下报 self immutable,临时注释。
        // 后续 Agent X 修复 immutable 推断后恢复此行。
        // rx.disposeBag = DisposeBag()
        let driver = self.bannerList(banners)
        
        driver.asObservable().bind(to: self.banners).disposed(by: rx.disposeBag)
        driver.map { $0.isEmpty }.bind(to: isEmptyData).disposed(by: rx.disposeBag)
        driver.map { $0[safe: index]?.title }.bind(to: detailTitle).disposed(by: rx.disposeBag)
        
        // 链式获取先获取卡列表再去获取详情
        driver.map { $0[safe: index] }
            .flatMapLatest(detail(banner:))
            .subscribe(onNext: { [weak self] in
                guard let weakSelf = self else {
                    return
                }
                let section = BaseTableViewHeaderFooterSection.init(cells: [])
                
                var bannersCell = BannerDetailTopCellViewModel()
                bannersCell.index = index
                bannersCell.datasource = weakSelf.banners.value
                bannersCell.prohibitedDequeueReusableCell = true
                bannersCell.currentIndex.bind(to: weakSelf.currentIndex).disposed(by: weakSelf.rx.disposeBag)
                section.cells.append(bannersCell)
                
                var detailCell = BannerDetailCellViewModel()
                detailCell.datasource = $0
                section.cells.append(detailCell)
                
                self?.sections = [section]
                self?.reloadTableView()
            }).disposed(by: rx.disposeBag)
    }
    
    // 删除缓存数据
    func removeCacheBannerDetail(with detail: BannerDetail) {
        if let key = detail.id?.fy.toString() {
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
            .deserialized(ApiResponse<[Banner]>.self)
            .map { $0?.data ?? [] }
            .observe(on: MainScheduler.instance)
    }
    
    private func detail(banner: Banner?) -> Observable<BannerDetail?> {
        guard let banner = banner else {
            return Observable.of(nil)
        }
        // 先读取缓存数据
        if let key = banner.id?.fy.toString(), let detail = self.cacheBannerDetail[key] {
            return Observable.from(optional: detail) // 这种方式传nil会导致后面订阅不响应
        }
        // 没有则去获取卡详情数据
        return DiscoverAPI.detail(banner).request()
            .deserialized(ApiResponse<BannerDetail>.self)
            .observe(on: MainScheduler.instance)
            .map { [weak self] in
                guard var detail = $0?.data else {
                    return nil
                }
                detail.id = banner.id
                detail.title = banner.title
                //detail.background = .color(UIColor.fy.random)
                let height = CGFloat(arc4random() % UInt32(detail.max ?? 0))
                detail.height = height >= 120 ? height : 120.0
                if let key = banner.id?.fy.toString() {
                    self?.cacheBannerDetail[key] = detail
                }
                return detail
            }
    }
}
