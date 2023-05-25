//
//  ExUIImage.swift
//  FeatBox
//
//  Created by Condy on 2020/11/23.
//

import UIKit

extension UIImage {
    
    /// 根据坐标获取图片中的像素颜色值
    public subscript (x: Int, y: Int) -> UIColor? {
        if x < 0 || x > Int(size.width) || y < 0 || y > Int(size.height) {
            return nil
        }
        guard let provider = self.cgImage?.dataProvider, let data = CFDataGetBytePtr(provider.data) else {
            return nil
        }
        let numberOfComponents = 4
        let pixelData = ((Int(size.width) * y) + x) * numberOfComponents
        let r = CGFloat(data[pixelData + 0]) / 255.0
        let g = CGFloat(data[pixelData + 1]) / 255.0
        let b = CGFloat(data[pixelData + 2]) / 255.0
        let a = CGFloat(data[pixelData + 3]) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

extension BoxWrapper where Base: UIImage {
    
    /// 类似Android中的setColorFilter，可以给图片换颜色。
    /// UI给了一张绿色的图，实际效果却是红色，这时候要么重新换一张红色的图，要么就可以使用这个方法。
    ///
    /// - Parameters:
    ///   - rgbValue: 颜色16进制值
    ///   - alpha: 颜色透明度
    /// - Returns: 滤镜后的图片
    public func setColorFilter(_ rgbValue: Int, _ alpha: CGFloat = 1.0) -> UIImage? {
        return setColorFilter(UIColor(rgb: rgbValue, alpha: alpha))
    }
    
    public func setColorFilter(_ fillColor: UIColor) -> UIImage? {
        guard let cgImage = base.cgImage else { return nil }
        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.scaleBy(x: 1, y: -1)
        ctx?.translateBy(x: 0, y: -base.size.height)
        ctx?.draw(cgImage, in: CGRect(origin: .zero, size: base.size))
        ctx?.setBlendMode(.sourceAtop)
        ctx?.setFillColor(fillColor.cgColor)
        ctx?.fill(CGRect(origin: .zero, size: base.size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 白色背景透明化
    public func imageByMakingWhiteBackgroundTransparent() -> UIImage? {
        guard let data = base.jpegData(compressionQuality: 1.0), let image = UIImage(data: data) else {
            return nil
        }
        // RGB color range to mask (make transparent)  R-Low, R-High, G-Low, G-High, B-Low, B-High
        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        UIGraphicsBeginImageContext(image.size)
        guard let maskedImageRef = image.cgImage?.copy(maskingColorComponents: colorMasking) else {
            return nil
        }
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0.0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.draw(maskedImageRef, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
