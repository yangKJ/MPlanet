//
//  LearnRankingViewModel.swift
//  WMLearn
//
//  Created by Condy on 2024/6/24.
//

import Foundation
import FeatBox

/// 世界排行榜 ViewModel
///
/// 数据组装：
/// - 柱状图 Cell：展示前 N 名用户分数对比
/// - 列表 Cell：完整排行榜列表
class LearnRankingViewModel: BaseTableViewModel, ViewModelEmptiable {

    /// 柱状图显示前 N 名（默认 5）
    public let barTopCount: Int = 5

    func request() {
        rankingData().asObservable().subscribe(onNext: { [weak self] list in
            guard let self = self else { return }
            var sections = [BaseTableViewSectionable]()

            let sorted = list.sorted(by: { ($0.rank ?? 0) < ($1.rank ?? 0) })

            // Section 1: 柱状图
            let barSection = BaseTableViewHeaderFooterSection(cells: [])
            barSection.sectionHeaderTitle = "世界排行 · TOP \(self.barTopCount)"
            barSection.sectionHeaderHeight = 50
            barSection.sectionFooterHeight = 0.01
            barSection.sectionHeaderBackgroundColor = UIColor.fy.white
            barSection.sectionFooterBackgroundColor = UIColor.fy.clear

            var barCell = LearnRankingBarCellViewModel()
            barCell.datasource = Array(sorted.prefix(self.barTopCount))
            barCell.cellHeight = 220
            barSection.cells = [barCell]
            sections.append(barSection)

            // Section 2: 完整列表
            let listSection = BaseTableViewHeaderFooterSection(cells: [])
            listSection.sectionHeaderTitle = "完整榜单"
            listSection.sectionHeaderHeight = 44
            listSection.sectionFooterHeight = 0.01
            listSection.sectionHeaderBackgroundColor = UIColor.fy.white
            listSection.sectionFooterBackgroundColor = UIColor.fy.clear

            var cells: [BaseTableViewCellViewModelable] = []
            for item in sorted {
                var cell = LearnRankingListCellViewModel()
                cell.datasource = item
                cell.cellHeight = 64
                cell.sepratorLineInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
                cells.append(cell)
            }
            listSection.cells = cells
            sections.append(listSection)

            self.sections = sections
            self.reloadTableView()
        }).disposed(by: rx.disposeBag)
    }
}

extension LearnRankingViewModel {

    /// 获取排行榜数据
    func rankingData() -> Driver<[LearnRanking]> {
        LearnAPI.ranking.request()
            .deserialized(ApiResponse<[LearnRanking]>.self)
            .compactMap { $0?.data }
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
    }
}
