//
//  AVSignatureView.swift
//  CommonView
//
//  Created by Condy on 2023/5/16.
//

import Foundation
import UIKit

open class AVSignatureView: UIView {
    
    public var lineWidth: CGFloat = 2.0 {
        didSet {
            self.path.lineWidth = lineWidth
        }
    }
    public var lineColor: UIColor = UIColor.black
    
    private var drawBlock: ((_ isDrawed: Bool) -> Void)?
    public func setDrawBlock(block: @escaping ((_ isDrawed: Bool) -> Void)) {
        self.drawBlock = block
    }
    
    private var path = UIBezierPath()
    private var pts = [CGPoint](repeating: CGPoint(), count: 5)
    private var ctr = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        self.path.lineWidth = self.lineWidth
    }
    
    override open func draw(_ rect: CGRect) {
        self.drawBlock?(!self.path.isEmpty)
        self.lineColor.setStroke()
        self.path.stroke()
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let touchPoint = firstTouch.location(in: self)
            self.ctr = 0
            self.pts[0] = touchPoint
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let touchPoint = firstTouch.location(in: self)
            self.ctr += 1
            self.pts[self.ctr] = touchPoint
            if (self.ctr == 4) {
                self.pts[3] = CGPoint(x: (self.pts[2].x + self.pts[4].x)/2.0, y: (self.pts[2].y + self.pts[4].y)/2.0)
                self.path.move(to: self.pts[0])
                self.path.addCurve(to: self.pts[3], controlPoint1:self.pts[1], controlPoint2:self.pts[2])
                self.setNeedsDisplay()
                self.pts[0] = self.pts[3]
                self.pts[1] = self.pts[4]
                self.ctr = 1
            }
            self.setNeedsDisplay()
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.ctr == 0 {
            let touchPoint = self.pts[0]
            self.path.move(to: CGPoint(x: touchPoint.x-1.0,y: touchPoint.y))
            self.path.addLine(to: CGPoint(x: touchPoint.x+1.0,y: touchPoint.y))
            self.setNeedsDisplay()
        } else {
            self.ctr = 0
        }
    }
    
    public var isSigned: Bool {
        get {
            return !self.path.isEmpty
        }
    }
    
    public func clearSign() {
        self.path.removeAllPoints()
        self.setNeedsDisplay()
    }
    
    public func saveSignToImage(scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
