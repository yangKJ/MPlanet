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
        let index: Int
    }
    struct Output {
        //let detail: Observable<BannerDetail?>
    }
    
    func transform(input: Input) -> Output {
        
//        let detail = detail(banner: input.banners[input.index])
//
//        return Output(detail: detail)
        return Output()
    }
}

extension BannerDetailViewModel {
    
    private func detail(banner: Banner) -> Observable<BannerDetail?> {
        let detail_ = BannerDetail()
        let detail = detail_.mappingLatterNotNil(type: BannerDetail.self, latter: banner)
        return Observable.of(detail)
    }
}
