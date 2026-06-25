//
//  ChatListViewModel.swift
//  WMChat
//
//  Created by Condy on 2024/5/24.
//

import Foundation
import FeatBox
import RxCocoa
import RxSwift

/// 消息列表 ViewModel
class ChatListViewModel: BaseTableViewModel, ViewModelEmptiable {

    /// 防止 bag 累加，每次 request 重新创建
    private var requestBag = DisposeBag()

    /// 会话选中事件
    public let sessionSelected = PublishRelay<ChatSession>()

    func request() {
        // 修复：每次请求清空 bag，避免订阅累加导致多次刷新
        self.requestBag = DisposeBag()

        sessions().asObservable()
            .subscribe(onNext: { [weak self] list in
                guard let self = self else { return }
                let section = BaseTableViewHeaderFooterSection(cells: [])
                section.sectionHeaderHeight = 0.01
                section.sectionFooterHeight = 0.01
                section.sectionHeaderBackgroundColor = UIColor.fy.clear
                section.sectionFooterBackgroundColor = UIColor.fy.clear

                var cells: [BaseTableViewCellViewModelable] = []
                for session in list {
                    var cell = ChatSessionCellViewModel()
                    cell.datasource = session
                    cell.cellHeight = 72
                    cell.sepratorLineInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
                    let relay = self.sessionSelected
                    cell.setCellDidSelected { [weak self] in
                        self?.sessionSelected.accept(session)
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

extension ChatListViewModel {

    /// 获取会话列表
    func sessions() -> Driver<[ChatSession]> {
        ChatAPI.sessions.request()
            .deserialized(ApiResponse<[ChatSession]>.self)
            .compactMap { $0?.data }
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
    }
}
