//
//  BridgeAppDelegateable.swift
//  FeatBox
//
//  Created by Condy on 2024/5/10.
//

import Foundation

/// 获取AppDelegate当中的参数，使用在cocoapods当中
public protocol BridgeAppDelegateable {
    
    var bridgeUIWindow: UIWindow? { get }
    
    var bridgeRootViewController: UIViewController? { get }
}
