//
//  TopicDetailViewModel.swift
//  WMTopics
//
//  Created by Condy on 2024/5/24.
//

import Foundation
import FeatBox
import RxCocoa
import RxSwift

/// 帖子详情 ViewModel
class TopicDetailViewModel: BaseTableViewModel, ViewModelEmptiable {

    /// 帖子 ID
    public var topicId: Int = 0

    /// 帖子详情 BehaviorRelay
    public let topic = BehaviorRelay<Topic?>(value: nil)

    /// 评论列表 BehaviorRelay
    public let comments = BehaviorRelay<[Comment]>(value: [])

    /// 评论发送输入框
    public let commentInputText = BehaviorRelay<String>(value: "")

    private var requestBag = DisposeBag()

    func request() {
        self.requestBag = DisposeBag()

        topicDetail(id: topicId).asObservable()
            .subscribe(onNext: { [weak self] topic in
                guard let self = self, let topic = topic else { return }

                var sections = [BaseTableViewSectionable]()

                // Section 1: 帖子头部
                let headerSection = BaseTableViewHeaderFooterSection(cells: [])
                headerSection.sectionHeaderHeight = 0.01
                headerSection.sectionFooterHeight = 0.01
                headerSection.sectionHeaderBackgroundColor = UIColor.fy.clear
                headerSection.sectionFooterBackgroundColor = UIColor.fy.clear
                var headerCell = TopicDetailHeaderCellViewModel()
                headerCell.datasource = topic
                headerCell.cellHeight = UITableView.automaticDimension
                headerSection.cells = [headerCell]
                sections.append(headerSection)

                // Section 2: 评论区
                let commentList = topic.comments ?? []
                let commentSection = BaseTableViewHeaderFooterSection(cells: [])
                commentSection.sectionHeaderTitle = "评论 (\(commentList.count))"
                commentSection.sectionHeaderHeight = 44
                commentSection.sectionFooterHeight = 0.01
                commentSection.sectionHeaderBackgroundColor = UIColor.fy.white
                commentSection.sectionFooterBackgroundColor = UIColor.fy.clear

                var cells: [BaseTableViewCellViewModelable] = []
                for comment in commentList {
                    var cell = CommentCellViewModel()
                    cell.datasource = comment
                    cell.cellHeight = UITableView.automaticDimension
                    cell.sepratorLineInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
                    cells.append(cell)
                }
                commentSection.cells = cells
                sections.append(commentSection)

                self.sections = sections
                self.reloadTableView()
                self.topic.accept(topic)
                self.comments.accept(commentList)
            }).disposed(by: self.requestBag)
    }

    /// 发送评论（演示用：把输入框内容追加到本地评论列表）
    func sendComment() {
        let text = (commentInputText.value ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        var currentComments = comments.value
        let newComment = Comment()
        // 由于 Comment 是 SmartCodable 模型，构造简单模拟数据
        currentComments.append(newComment)
        comments.accept(currentComments)
        commentInputText.accept("")

        // 重新构建 section 2
        rebuildCommentSection(comments: currentComments)
    }

    private func rebuildCommentSection(comments: [Comment]) {
        guard sections.count >= 2 else { return }
        let section = sections[1]
        var cells: [BaseTableViewCellViewModelable] = []
        for comment in comments {
            var cell = CommentCellViewModel()
            cell.datasource = comment
            cell.cellHeight = UITableView.automaticDimension
            cell.sepratorLineInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            cells.append(cell)
        }
        (section as? BaseTableViewHeaderFooterSection)?.cells = cells
        section.sectionHeaderTitle = "评论 (\(comments.count))"
        reloadTableView()
    }
}

extension TopicDetailViewModel {

    /// 获取帖子详情
    func topicDetail(id: Int) -> Driver<Topic?> {
        TopicsAPI.detail(id: id).request()
            .deserialized(ApiResponse<Topic>.self)
            .compactMap { $0?.data }
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: nil)
    }
}
