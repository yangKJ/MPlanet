//
//  FunctionType.swift
//  FeatBox
//
//  Created by Condy on 2024/5/10.
//

import Foundation
import Mediator

/// App功能标识
public enum FunctionType: String {
    case banner_detail = "FUNCTION_BANNER_DETAIL" // Banner详情
}

extension FunctionType {
    
    @discardableResult
    public func goto(from viewController: UIViewController? = nil, additional: [String: Any]? = nil, logined: Bool = false) -> Bool {
        switch self {
        case .banner_detail:
            let vc = Mediator.bannerDetailViewController(params: additional)
            return push(from: viewController, vc: vc)
        default:
            return false
        }
        return false
    }
    
    func push(from viewController: UIViewController?, vc: UIViewController?) -> Bool {
        guard let vc = vc else {
            return false
        }
        let viewController = viewController ?? Ces.topViewController
        viewController?.navigationController?.pushViewController(vc, animated: true)
        return true
    }
}
