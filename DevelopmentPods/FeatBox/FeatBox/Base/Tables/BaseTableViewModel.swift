//
//  BaseTableViewModel.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import Rickenbacker
import Harbeth
import ProductLib

open class BaseTableViewModel: BaseViewModel {

    // 修复：viewModel 不应强引用 tableView，否则 viewModel -> tableView -> viewModel 形成循环引用，
    // 导致 VC 被销毁时 viewModel 跟着 tableView 一起 leak。
    public internal(set) weak var tableView: BaseTableView?

    public var sections: [BaseTableViewSectionable] = [] {
        didSet {
            sections.flatMap {
                $0.cells.map { $0.cellType }
            }.forEach {
                self.tableView?.fy.register($0)
            }
        }
    }

    public func reloadTableView() {
        self.tableView?.reloadData()
    }
    
    // MARK: - 子类重写实现
    
    /// 对每个cell进行个性化配置
    open func config(indexPath: IndexPath, cell: BaseTableViewCell) {
        
    }
    
    // MARK: - private methods
    
    @Harbeth.Locked private var cacheCells: [String: BaseTableViewCell] = [:]
    
    private func getSectionViewModel(with section: Int) -> BaseTableViewSectionable? {
        return self.sections[safe: section]
    }
    
    private func viewModel(at indexPath: IndexPath) -> BaseTableViewCellViewModelable? {
        guard let section = getSectionViewModel(with: indexPath.section) else {
            return nil
        }
        return section.cells[safe: indexPath.row]
    }
    
    private func setCell(_ cell: BaseTableViewCell, viewModel: BaseTableViewCellViewModelable, indexPath: IndexPath) {
        let count = getSectionViewModel(with: indexPath.section)?.cells.count ?? 0
        if let height = viewModel.sepratorLineHeight, height > 0.0 {
            cell.sepratorLine.backgroundColor = viewModel.sepratorLineColor
            cell.sepratorLine.isHidden = indexPath.row == count-1
            cell.setSepratorLine(height: height, insets: viewModel.sepratorLineInsets)
        } else {
            cell.sepratorLine.isHidden = true
        }
        self.config(indexPath: indexPath, cell: cell)
    }
}

extension BaseTableViewModel: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].cells.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let vm = viewModel(at: indexPath) else {
            return UITableViewCell()
        }
        let key = String(describing: vm.cellType) + "-\(indexPath.section)-\(indexPath.row)"
        if vm.prohibitedDequeueReusableCell, let cell = cacheCells[key] {
            cell.viewModel = vm
            self.setCell(cell, viewModel: vm, indexPath: indexPath)
            return cell
        }
        let dequeueReusableCell = tableView.fy.dequeueReusableCell(vm.cellType, for: indexPath)
        dequeueReusableCell.viewModel = vm
        self.setCell(dequeueReusableCell, viewModel: vm, indexPath: indexPath)
        if vm.prohibitedDequeueReusableCell {
            cacheCells[key] = dequeueReusableCell
        }
        return dequeueReusableCell
    }
}

extension BaseTableViewModel: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /// `UITableView.automaticDimension`则高度自适应
        return viewModel(at: indexPath)?.cellHeight ?? UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = getSectionViewModel(with: section)?.sectionHeaderHeight ?? 0.0
        if height == 0 {
            return tableView.style == .plain ? 0 : 0.01
        }
        return height
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let height = getSectionViewModel(with: section)?.sectionFooterHeight ?? 0.0
        if height == 0 {
            return tableView.style == .plain ? 0 : 0.01
        }
        return height
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let vm = getSectionViewModel(with: section), vm.sectionHeaderViewType == nil else {
            return nil
        }
        return vm.sectionHeaderHeight > 0 ? vm.sectionHeaderTitle : nil
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let vm = getSectionViewModel(with: section), vm.sectionFooterViewType == nil else {
            return nil
        }
        return vm.sectionFooterHeight > 0 ? vm.sectionFooterTitle : nil
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let vm = getSectionViewModel(with: section), let type = vm.sectionHeaderViewType else {
            return nil
        }
        if let nib = vm.sectionHeaderViewNib {
            tableView.register(nib, forHeaderFooterViewReuseIdentifier: String(describing: type))
        } else {
            tableView.register(type, forHeaderFooterViewReuseIdentifier: String(describing: type))
        }
        let view = tableView.fy.dequeueReusableHeaderFooterView(type)
        view?.type = .header
        view?.sectionViewModel = vm
        return view
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let vm = getSectionViewModel(with: section), let type = vm.sectionFooterViewType else {
            return nil
        }
        if let nib = vm.sectionFooterViewNib {
            tableView.register(nib, forHeaderFooterViewReuseIdentifier: String(describing: type))
        } else {
            tableView.register(type, forHeaderFooterViewReuseIdentifier: String(describing: type))
        }
        let view = tableView.fy.dequeueReusableHeaderFooterView(type)
        view?.type = .footer
        view?.sectionViewModel = vm
        return view
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return nil
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return -1
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}
