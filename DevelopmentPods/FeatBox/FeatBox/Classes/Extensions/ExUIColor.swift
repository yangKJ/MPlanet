//
//  ExUIColor.swift
//  FeatBox
//
//  Created by Condy on 2020/11/23.
//

import UIKit

extension UIColor {
    /// RRGGBB
    public convenience init(rgbValue: Int, alpha: CGFloat = 1.0) {
        let red   = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue  = CGFloat(rgbValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

public extension UIColor {
    public enum GradientDirection {
        case horizontal
        case vertical
        case upwardDiagonal
        case downDiagonal
    }
}

public func UIGraphicsGradientImageCreate(_ fromColor: UIColor,
                                          _ toColor: UIColor,
                                          _ size: CGSize = .zero,
                                          _ direction: UIColor.GradientDirection = .horizontal) -> UIImage? {
    if size.equalTo(.zero) {
        debugPrint("size can not be .zero")
        return nil
    }
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = CGRect(origin: .zero, size: size)
    
    var startPoint = CGPoint.zero
    if direction == .downDiagonal {
        startPoint = CGPoint(x: 0, y: 1)
    }
    var endPoint = CGPoint.zero
    switch direction {
    case .vertical: endPoint = CGPoint(x: 0, y: 1)
    case .horizontal: endPoint = CGPoint(x: 1, y: 0)
    case .upwardDiagonal: endPoint = CGPoint(x: 1, y: 1)
    case .downDiagonal: endPoint = CGPoint(x: 1, y: 0) }
    
    gradientLayer.startPoint = startPoint
    gradientLayer.endPoint = endPoint
    gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
    UIGraphicsBeginImageContextWithOptions(size, gradientLayer.isOpaque, gradientLayer.contentsScale)
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    gradientLayer.render(in: context)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}
