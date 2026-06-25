//
//  LearnCourseViewModel.swift
//  WMLearn
//
//  Created by Condy on 2024/6/24.
//  美化说明：调整章节 section 头部为白卡风格
//

import Foundation
import FeatBox
import RxCocoa

/// 课程详情 ViewModel
class LearnCourseViewModel: BaseTableViewModel, ViewModelEmptiable {

    /// 当前课程 ID
    public var courseId: Int = 0

    /// 课程详情 BehaviorRelay（用于响应式更新）
    public let course = BehaviorRelay<LearnCourse?>(value: nil)

    func request() {
        courseDetail().asObservable().subscribe(onNext: { [weak self] course in
            guard let self = self, let course = course else { return }

            var sections = [BaseTableViewSectionable]()

            // Section 1: 课程头部 + 介绍（白卡化）
            let headerSection = BaseTableViewHeaderFooterSection(cells: [])
            headerSection.sectionHeaderHeight = 0.01
            headerSection.sectionFooterHeight = 12
            headerSection.sectionHeaderBackgroundColor = UIColor.fy.clear
            headerSection.sectionFooterBackgroundColor = UIColor.fy.clear
            var headerCell = LearnCourseHeaderCellViewModel()
            headerCell.datasource = course
            headerCell.cellHeight = UITableView.automaticDimension
            headerCell.sepratorLineHeight = 0
            headerSection.cells = [headerCell]
            sections.append(headerSection)

            // Section 2: 章节目录（白卡化）
            if let chapters = course.chapterList, chapters.count > 0 {
                let chapterSection = BaseTableViewHeaderFooterSection(cells: [])
                chapterSection.sectionHeaderTitle = "章节目录"
                chapterSection.sectionHeaderHeight = 50
                chapterSection.sectionFooterHeight = 16
                chapterSection.sectionHeaderBackgroundColor = UIColor.fy.white
                chapterSection.sectionFooterBackgroundColor = UIColor.fy.clear

                var cells: [BaseTableViewCellViewModelable] = []
                for chapter in chapters {
                    var cell = LearnChapterCellViewModel()
                    cell.datasource = chapter
                    cell.cellHeight = 50
                    cell.sepratorLineInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
                    cells.append(cell)
                }
                chapterSection.cells = cells
                sections.append(chapterSection)
            }

            self.sections = sections
            self.reloadTableView()
            self.course.accept(course)
        }).disposed(by: rx.disposeBag)
    }
}

extension LearnCourseViewModel {

    /// 获取课程详情
    func courseDetail() -> Driver<LearnCourse?> {
        LearnAPI.courseDetail(courseId: courseId).request()
            .deserialized(ApiResponse<LearnCourse>.self)
            .compactMap { $0?.data }
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: nil)
    }
}
