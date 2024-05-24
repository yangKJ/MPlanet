//
//  Methods.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import ProductLib
import Harbeth

/// 二次封装频繁使用方法
public struct Methods {
    
    /// 解释弹框
    public static func explanationFor(view: UIView,
                                      with content: String?,
                                      arrowDirection: UIPopoverArrowDirection = .up,
                                      lineLengthDdaptive: Bool = false) -> ExplanationPopupViewController {
        let vc = ExplanationPopupViewController()
        vc.lineLengthDdaptive = lineLengthDdaptive
        vc.content = content
        let viewPoint = view.convert(view.center, to: UIWindow.fy.keyWindow())
        if UIScreen.main.bounds.height - viewPoint.y < vc.preferredContentSize.height, arrowDirection == .up {
            vc.arrowDirection = .down
        } else if viewPoint.y < vc.preferredContentSize.height + UINavigationController.fy.navigationHeight(), arrowDirection == .down {
            vc.arrowDirection = .up
        } else {
            vc.arrowDirection = arrowDirection
        }
        vc.sourceView = view
        return vc
    }
    
    /// 生成纯色图像
    public static func colorImage(with color: UIColor, width: Int, height: Int) -> C7Image? {
        guard let texture = try? TextureLoader.emptyTexture(width: width, height: height) else {
            return nil
        }
        let filter = C7SolidColor(color: color)
        let dest = HarbethIO(element: texture, filter: filter)
        return try? dest.output().c7.toImage()
    }
}
