//
//  ExCALayer.swift
//  FeatBox
//
//  Created by Condy on 2021/1/2.
//

import CoreGraphics

extension CALayer {
    /// 阴影方向
    public struct ShadowDirection: OptionSet {
        public static let top = ShadowDirection(rawValue: 1 << 0)
        public static let left = ShadowDirection(rawValue: 1 << 1)
        public static let right = ShadowDirection(rawValue: 1 << 2)
        public static let bottom = ShadowDirection(rawValue: 1 << 3)
        public static let nonTop: ShadowDirection = [.left, .right, .bottom]
        public static let nonLeft: ShadowDirection = [.top, .right, .bottom]
        public static let nonRight: ShadowDirection = [.top, .left, .bottom]
        public static let nonBottom: ShadowDirection = [.top, .left, .right]
        public static let all: ShadowDirection = [.top, .left, .right, .bottom]
        
        public let rawValue: UInt
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
    }
}

extension BoxWrapper where Base: CALayer {
    
    /// 设置阴影方向
    ///
    /// - Parameters:
    ///   - offset: 阴影的偏移量.
    ///   - direction: 阴影出现的方向.
    /// NOTE: layer的frame必须已知
    /// NOTE: 适用于一点点小阴影，因为没有考虑shadowRadius和四角的阴影补全(有需求再补充吧)
    public func setShadowOffset(_ offset: CGSize, at direction: CALayer.ShadowDirection) {
        // shadowOffset会影响shadowPath的效果
        base.shadowOffset = .zero
        
        let shadowPath = CGMutablePath()
        
        if direction.contains(.top) {
            shadowPath.move(to: .zero)
            shadowPath.addLine(to: CGPoint(x: 0, y: offset.height))
            shadowPath.addLine(to: CGPoint(x: base.bounds.maxX, y: offset.height))
            shadowPath.addLine(to: CGPoint(x: base.bounds.maxX, y: 0))
            shadowPath.closeSubpath()
        }
        
        if direction.contains(.left) {
            shadowPath.move(to: .zero)
            shadowPath.addLine(to: CGPoint(x: offset.width, y: 0))
            shadowPath.addLine(to: CGPoint(x: offset.width, y: base.bounds.maxY))
            shadowPath.addLine(to: CGPoint(x: 0, y: base.bounds.maxY))
            shadowPath.closeSubpath()
        }
        
        if direction.contains(.right) {
            shadowPath.move(to: CGPoint(x: base.bounds.maxX, y: 0))
            shadowPath.addLine(to: CGPoint(x: base.bounds.maxX + offset.width, y: 0))
            shadowPath.addLine(to: CGPoint(x: base.bounds.maxX + offset.width, y: base.bounds.maxY))
            shadowPath.addLine(to: CGPoint(x: base.bounds.maxX, y: base.bounds.maxY))
            shadowPath.closeSubpath()
        }
        
        if direction.contains(.bottom) {
            shadowPath.move(to: CGPoint(x: 0, y: base.bounds.maxY))
            shadowPath.addLine(to: CGPoint(x: 0, y: base.bounds.maxY + offset.height))
            shadowPath.addLine(to: CGPoint(x: base.bounds.maxX, y: base.bounds.maxY + offset.height))
            shadowPath.addLine(to: CGPoint(x: base.bounds.maxX, y: base.bounds.maxY))
            shadowPath.closeSubpath()
        }
        
        base.shadowPath = shadowPath
    }
}
