//
//  MineSettingViewModel.swift
//  WMMine
//
//  Created by Condy on 2023/6/6.
//

import Foundation
import FeatBox

class MineSettingViewModel: BaseViewModel {
    
    public let mineFunctions = PublishRelay<[MineFunctionForm]>()
    
    func setupFunctionForm(with users: MineUsers?) {
        let form = functionForm().asObservable()
        
        form.bind(to: mineFunctions).disposed(by: rx.disposeBag)
    }
}

extension MineSettingViewModel {
    // 功能表单
    private func functionForm() -> Observable<[MineFunctionForm]> {
        let funs: [MineFunctionForm] = [
            .signature,
        ]
        return Observable.of(funs)
    }
}
