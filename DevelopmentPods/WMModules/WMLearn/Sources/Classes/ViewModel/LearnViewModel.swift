//
//  LearnViewModel.swift
//  WMLearn
//
//  Created by Condy on 2024/6/24.
//  美化说明：调整 cellHeight 让白卡视觉更舒展
//

import Foundation
import FeatBox
import RxCocoa

/// 学习区首页 ViewModel
///
/// 数据组装：
/// - 6 大分类（categories）
/// - 视频赔价榜入口（videos）
class LearnViewModel: BaseTableViewModel, ViewModelEmptiable {

    func request() {
        let categories = categoryData().asObservable()
        let videos = videoData().asObservable()

        let zip = Observable.zip(categories, videos)

        zip.subscribe(onNext: { [weak self] categoryList, videoList in
            var sections = [BaseTableViewSectionable]()

            // Section 1: 6 大分类宫格（白卡化）
            if categoryList.count > 0 {
                let categorySection = BaseTableViewHeaderFooterSection(cells: [])
                categorySection.sectionHeaderHeight = 0.01
                categorySection.sectionFooterHeight = 12
                categorySection.sectionHeaderBackgroundColor = UIColor.fy.clear
                categorySection.sectionFooterBackgroundColor = UIColor.fy.clear
                var categoryCell = LearnCategoryCellViewModel()
                categoryCell.datasource = categoryList
                // 宫格整体卡片化：内边距 16 + 2 行 item 高度 + 间距 8
                categoryCell.cellHeight = 260
                categoryCell.sepratorLineHeight = 0
                categorySection.cells = [categoryCell]
                sections.append(categorySection)
            }

            // Section 2: 视频赔价榜入口（白卡化）
            if videoList.count > 0 {
                let videoSection = BaseTableViewHeaderFooterSection(cells: [])
                videoSection.sectionHeaderHeight = 0.01
                videoSection.sectionFooterHeight = 16
                videoSection.sectionHeaderBackgroundColor = UIColor.fy.clear
                videoSection.sectionFooterBackgroundColor = UIColor.fy.clear
                var videoCell = LearnVideoCardCellViewModel()
                videoCell.datasource = videoList
                videoCell.cellHeight = 252
                videoCell.sepratorLineHeight = 0
                videoSection.cells = [videoCell]
                sections.append(videoSection)
            }

            self?.sections = sections
            self?.reloadTableView()
        }).disposed(by: rx.disposeBag)
    }
}

extension LearnViewModel {

    /// 获取 6 大分类数据
    func categoryData() -> Driver<[LearnCategory]> {
        LearnAPI.categories.request()
            .deserialized(ApiResponse<[LearnCategory]>.self)
            .compactMap { $0?.data }
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
    }

    /// 获取视频赔价榜数据
    func videoData() -> Driver<[LearnVideoCard]> {
        LearnAPI.videos(categoryId: 1).request()
            .deserialized(ApiResponse<[LearnVideoCard]>.self)
            .compactMap { $0?.data }
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
    }
}
