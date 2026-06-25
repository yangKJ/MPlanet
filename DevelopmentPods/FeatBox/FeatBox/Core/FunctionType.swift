//
//  FunctionType.swift
//  FeatBox
//
//  Created by Condy on 2024/5/10.
//

import Foundation
import Mediator
import ProductLib

/// App功能标识
public enum FunctionType: String {
    case banner_detail = "FUNCTION_BANNER_DETAIL" // Banner详情
}

extension FunctionType {
    
    @discardableResult
    public func goto(from viewController: UIViewController? = nil, additional: Any? = nil) -> Bool {
        switch self {
        case .banner_detail:
            let params = additional as? [String: Any]
            let vc = Mediator.bannerDetailViewController(params: params)
            return push(from: viewController, vc: vc)
        default:
            return false
        }
        return false
    }
}

extension FunctionType {
    private func push(from viewController: UIViewController?, vc: UIViewController?) -> Bool {
        guard let vc = vc else {
            return false
        }
        let viewController = viewController ?? UIViewController.fy.currentViewController()
        viewController?.navigationController?.pushViewController(vc, animated: true)
        return true
    }
}
