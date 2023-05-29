//
//  BannerDetailViewModel.swift
//  WMDiscover
//
//  Created by Condy on 2023/5/29.
//

import Foundation
import FeatBox

class BannerDetailViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let banners: [Banner]
    }
    struct Output {
        //let sections: Observable<[WalletSection]>
    }
    
    func transform(input: BannerDetailViewModel.Input) -> BannerDetailViewModel.Output {
        return Output()
    }
}
