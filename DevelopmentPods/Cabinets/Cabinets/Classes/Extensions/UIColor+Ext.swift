//
//  ExUIColor.swift
//  FeatBox
//
//  Created by Condy on 2020/11/23.
//

import UIKit

extension UIColor {
    public enum GradientDirection {
        case horizontal
        case vertical
        case upwardDiagonal
        case downDiagonal
    }
    
    /// RRGGBB
    public convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        let red   = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue  = CGFloat((rgb & 0x0000FF)) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// 0xRRGGBB
    public convenience init(hex: Int) {
        let mask = 0xFF
        let r = CGFloat((hex >> 16) & mask) / 255
        let g = CGFloat((hex >> 8) & mask) / 255
        let b = CGFloat((hex) & mask) / 255
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
    
    public convenience init(hex: String) {
        let input = hex.replacingOccurrences(of: "#", with: "").uppercased()
        var a: CGFloat = 1.0, r: CGFloat = 0.0, b: CGFloat = 0.0, g: CGFloat = 0.0
        func colorComponent(from string: String, start: Int, length: Int) -> CGFloat {
            let substring = (string as NSString).substring(with: NSRange(location: start, length: length))
            let fullHex = length == 2 ? substring : "\(substring)\(substring)"
            var hexComponent: UInt64 = 0
            Scanner(string: fullHex).scanHexInt64(&hexComponent)
            return CGFloat(Double(hexComponent) / 255.0)
        }
        switch (input.count) {
        case 3 /* #RGB */:
            r = colorComponent(from: input, start: 0, length: 1)
            g = colorComponent(from: input, start: 1, length: 1)
            b = colorComponent(from: input, start: 2, length: 1)
        case 4 /* #ARGB */:
            a = colorComponent(from: input, start: 0, length: 1)
            r = colorComponent(from: input, start: 1, length: 1)
            g = colorComponent(from: input, start: 2, length: 1)
            b = colorComponent(from: input, start: 3, length: 1)
        case 6 /* #RRGGBB */:
            r = colorComponent(from: input, start: 0, length: 2)
            g = colorComponent(from: input, start: 2, length: 2)
            b = colorComponent(from: input, start: 4, length: 2)
        case 8 /* #AARRGGBB */:
            a = colorComponent(from: input, start: 0, length: 2)
            r = colorComponent(from: input, start: 2, length: 2)
            g = colorComponent(from: input, start: 4, length: 2)
            b = colorComponent(from: input, start: 6, length: 2)
        default:
            break
        }
        self.init(red: r, green: g, blue: b, alpha: a)
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
    
    let startPoint = direction == .downDiagonal ? CGPoint(x: 0, y: 1) : CGPoint.zero
    var endPoint = CGPoint.zero
    switch direction {
    case .vertical:
        endPoint = CGPoint(x: 0, y: 1)
    case .horizontal:
        endPoint = CGPoint(x: 1, y: 0)
    case .upwardDiagonal:
        endPoint = CGPoint(x: 1, y: 1)
    case .downDiagonal:
        endPoint = CGPoint(x: 1, y: 0)
    }
    
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
