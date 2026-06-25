//
//  MineFunctionForm.swift
//  WMMine
//
//  Created by Condy on 2023/6/6.
//

import Foundation
import FeatBox

/// 设置中心表单
enum MineFunctionForm {
    case signature
}

extension MineFunctionForm {
    var des: String {
        switch self {
        case .signature:
            return Res.text("电子签名")
        }
    }
    
    func gotoViewController(with users: MineUsers?) -> UIViewController? {
        switch self {
        case .signature:
            let vc = MineSignatureViewController()
            return vc
        }
        return nil
    }
}
