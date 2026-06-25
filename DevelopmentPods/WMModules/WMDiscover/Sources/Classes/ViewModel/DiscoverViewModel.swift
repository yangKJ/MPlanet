//
//  DiscoverViewModel.swift
//  WMDiscover
//
//  Created by Condy on 2020/12/28.
//

import FeatBox
import RxCocoa
import RxSwift

class DiscoverViewModel: BaseTableViewModel, ViewModelEmptiable {

    /// 防止 bag 累加，每次 request 重新创建
    private var requestBag = DisposeBag()

    func request() {
        // 修复：每次请求清空 bag，避免订阅累加导致多次刷新
        self.requestBag = DisposeBag()

        let banners = bannerData().asObservable()
        let discovers = discoverData().asObservable()
        let quickEntries = quickEntriesData().asObservable()
        let videoRanking = videoRankingData().asObservable()
        let posts = postsData().asObservable()

        let zip = Observable.zip(banners, discovers, quickEntries, videoRanking, posts)

        zip.subscribe(onNext: { [weak self] banners, discovers, quickEntries, videoRanking, posts in
            guard let self = self else { return }
            var sections = [BaseTableViewSectionable]()

            // 1. Banner
            if let bannerSection = DiscoverGroupDetailType.banner.createSection(with: banners) {
                sections.append(bannerSection)
            }

            // 2. 6 宫格学习区入口
            if let quickSection = DiscoverSectionFactory.quickEntriesSection() {
                sections.append(quickSection)
            }

            // 3. 视频分类（来自 discoverHome）
            let classifies = discovers
                .filter { $0.module == .videoClassify }
                .sorted(by: { ($0.sort ?? 0) < ($1.sort ?? 0) })
                .compactMap { module -> BaseTableViewSectionable? in
                    return module.module?.createSection(with: module.datas, title: module.title)
                }
            sections.append(contentsOf: classifies)

            // 4. 装饰 rail
            let rails = discovers
                .filter { $0.module == .decorativeRail }
                .sorted(by: { ($0.sort ?? 0) < ($1.sort ?? 0) })
                .compactMap { module -> BaseTableViewSectionable? in
                    return module.module?.createSection(with: module.datas, title: module.title)
                }
            sections.append(contentsOf: rails)

            // 5. 视频赔价榜
            if let rankingSection = DiscoverSectionFactory.videoRankingSection(items: videoRanking) {
                sections.append(rankingSection)
            }

            // 6. 最新帖子
            if let postsSection = DiscoverSectionFactory.postsSection(items: posts) {
                sections.append(postsSection)
            }

            self.sections = sections
            self.reloadTableView()
        }).disposed(by: self.requestBag)
    }
}

extension DiscoverViewModel {

    func bannerData() -> Driver<[Banner]> {
        DiscoverAPI.banner.request()
            .deserialized(ApiResponse<[Banner]>.self)
            .compactMap { $0?.data }
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
    }

    func discoverData() -> Driver<[Discover]> {
        DiscoverAPI.discoverHome.request()
            .deserialized(ApiResponse<[Discover]>.self)
            .compactMap { $0?.data }
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
    }

    func quickEntriesData() -> Driver<[DiscoverQuickEntry]> {
        DiscoverAPI.quickEntries.request()
            .deserialized(ApiResponse<[DiscoverQuickEntry]>.self)
            .compactMap { $0?.data }
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
    }

    func videoRankingData() -> Driver<[DiscoverVideoRanking]> {
        DiscoverAPI.videoRanking.request()
            .deserialized(ApiResponse<[DiscoverVideoRanking]>.self)
            .compactMap { $0?.data }
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
    }

    func postsData() -> Driver<[DiscoverPost]> {
        DiscoverAPI.posts.request()
            .deserialized(ApiResponse<[DiscoverPost]>.self)
            .compactMap { $0?.data }
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
    }
}
