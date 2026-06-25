//
//  MJRefreshAnimationHeader.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import MJRefresh

/// 刷新动画控件
public final class MJRefreshAnimationHeader: MJRefreshGifHeader {
    
    public override func prepare() {
        super.prepare()
        
        stateLabel?.isHidden = true
        lastUpdatedTimeLabel?.isHidden = true
        
        setImages([Res.image("refresh_normal")], for: .idle)
        setImages([Res.image("refresh_will_refresh")], for: .pulling)
        
        let images = (1...3).compactMap {
            Res.image("refresh_loading_\($0)")
        }
        setImages(images, for: .refreshing)
    }
}
