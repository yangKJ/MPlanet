//
//  TopicsViewModel.swift
//  WMTopics
//
//  Created by Condy on 2024/5/24.
//

import Foundation
import FeatBox
import RxCocoa
import RxSwift

/// 主题列表 ViewModel
///
/// 数据组装：
/// - 顶部 UISegmentedControl（最新/热门/我的关注）
/// - 切 tab 触发不同接口
class TopicsViewModel: BaseTableViewModel, ViewModelEmptiable {

    /// 防止 bag 累加，每次 request 重新创建
    private var requestBag = DisposeBag()

    /// 当前选中的 tab
    private var currentType: String = "latest"

    /// 帖子选中事件（外部订阅跳转详情）
    public let topicSelected = PublishRelay<Topic>()

    func request(type: String) {
        // 修复：每次请求清空 bag，避免订阅累加导致多次刷新
        self.requestBag = DisposeBag()
        self.currentType = type

        topicList(type: type).asObservable()
            .subscribe(onNext: { [weak self] list in
                guard let self = self else { return }
                let section = BaseTableViewHeaderFooterSection(cells: [])
                section.sectionHeaderHeight = 0.01
                section.sectionFooterHeight = 0.01
                section.sectionHeaderBackgroundColor = UIColor.fy.clear
                section.sectionFooterBackgroundColor = UIColor.fy.clear

                var cells: [BaseTableViewCellViewModelable] = []
                for topic in list {
                    var cell = TopicCellViewModel()
                    cell.datasource = topic
                    cell.cellHeight = UITableView.automaticDimension
                    // 注入点击回调
                    let relay = self.topicSelected
                    cell.setCellDidSelected { [weak self] in
                        self?.topicSelected.accept(topic)
                        _ = relay
                    }
                    cells.append(cell)
                }
                section.cells = cells

                self.sections = [section]
                self.reloadTableView()
            }).disposed(by: self.requestBag)
    }
}

extension TopicsViewModel {

    /// 获取指定 type 的帖子列表
    func topicList(type: String) -> Driver<[Topic]> {
        TopicsAPI.list(type: type).request()
            .deserialized(ApiResponse<[Topic]>.self)
            .compactMap { $0?.data }
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
    }
}
