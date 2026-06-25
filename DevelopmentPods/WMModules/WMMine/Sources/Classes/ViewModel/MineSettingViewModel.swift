//
//  MineSettingViewModel.swift
//  WMMine
//
//  Created by Condy on 2023/6/6.
//

import Foundation
import FeatBox

class MineSettingViewModel: BaseTableViewModel, SharedNettable {
    
    let tapIndexFunctionForm = PublishRelay<MineFunctionForm>()
    
    func setupFunctionForm(with users: MineUsers?) {
        let elements: [MineFunctionForm] = [
            .signature,
        ]
        let section = BaseTableViewHeaderFooterSection(cells: [])
        section.cells = elements.map({ element in
            var vm = BaseFormCellViewModel()
            vm.datasource = element
            vm.title = element.des
            vm.hasArrow = true
            vm.setCellDidSelected(block: {
                self.tapIndexFunctionForm.accept(element)
            })
            return vm
        })
        self.sections = [section]
        self.reloadTableView()
    }
}
