//
//  ConfigsAppDelegate.swift
//  RootManager
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import FeatBox

/// 配置信息
class ConfigsAppDelegate: AppDelegateType {
    
    override init() {
        super.init()
        self.setupConfigs()
    }
}

extension ConfigsAppDelegate {
    
    private func setupConfigs() {
        setupNetworkConfigs()
        Session.initializeSession()
    }
    
    private func setupNetworkConfigs() {
        BoomingSetup.animatedJSON = "StandardLoading"
        BoomingSetup.debuggingLogOption = .concise
        BoomingSetup.addIndicator = true
    }
}
