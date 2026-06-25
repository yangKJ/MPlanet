//
//  LearnCategoryViewModel.swift
//  WMLearn
//
//  Created by Condy on 2024/6/24.
//  美化说明：调整 cellHeight 让白卡 cell 视觉更舒展
//

import Foundation
import FeatBox

/// 分类课程列表 ViewModel
class LearnCategoryViewModel: BaseTableViewModel, ViewModelEmptiable {

    /// 当前分类 ID
    public var categoryId: Int = 0

    /// 课程选中事件（外部订阅跳转详情）
    public let courseSelected = PublishRelay<LearnCourse>()

    func request() {
        let courses = self.courseData().asObservable()

        courses.subscribe(onNext: { [weak self] list in
            guard let self = self else { return }
            let section = BaseTableViewHeaderFooterSection(cells: [])
            section.sectionHeaderHeight = 0.01
            section.sectionFooterHeight = 16
            section.sectionHeaderBackgroundColor = UIColor.fy.clear
            section.sectionFooterBackgroundColor = UIColor.fy.clear

            var cells: [BaseTableViewCellViewModelable] = []
            for course in list {
                var cell = LearnCourseCellViewModel()
                cell.datasource = course
                cell.cellHeight = 100
                cell.sepratorLineInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
                // 注入点击回调
                let relay = self.courseSelected
                cell.setCellDidSelected { [weak self] in
                    self?.courseSelected.accept(course)
                    _ = relay
                }
                cells.append(cell)
            }
            section.cells = cells

            self.sections = [section]
            self.reloadTableView()
        }).disposed(by: rx.disposeBag)
    }
}

extension LearnCategoryViewModel {

    /// 根据 categoryId 拉取课程
    func courseData() -> Driver<[LearnCourse]> {
        LearnAPI.courses(categoryId: categoryId).request()
            .deserialized(ApiResponse<[LearnCourse]>.self)
            .compactMap { $0?.data }
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
    }
}
