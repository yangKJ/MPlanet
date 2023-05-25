//
//  AVSignatureView.swift
//  CommonView
//
//  Created by Condy on 2023/5/16.
//

import Foundation

open class AVSignatureView: UIView {
    
    public var lineWidth: CGFloat = 2.0
    public var lineColor: UIColor = UIColor.black
    
    private var drawBlock: ((_ isDrawed: Bool) -> Void)?
    public func setDrawBlock(block: @escaping ((_ isDrawed: Bool) -> Void)) {
        self.drawBlock = block
    }
    
    var path: UIBezierPath?
    var pathArray: [UIBezierPath] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func panGestureRecognizerAction(_ sender: UIPanGestureRecognizer) {
        let currentPoint = sender.location(in: self)
        if sender.state == .began {
            self.path = UIBezierPath()
            path?.lineWidth = lineWidth
            path?.move(to: currentPoint)
            pathArray.append(path!)
        } else if sender.state == .changed {
            path?.addLine(to: currentPoint)
        }
        self.setNeedsDisplay()
    }
    
    open override func draw(_ rect: CGRect) {
        self.drawBlock?(pathArray.count > 0)
        for path in pathArray {
            lineColor.set()
            path.stroke()
        }
    }
    
    public var isSigned: Bool {
        get {
            pathArray.count > 0
        }
    }
    
    public func clearSign() {
        pathArray.removeAll()
        self.setNeedsDisplay()
    }
    
    public func undoSign() {
        guard pathArray.count > 0 else {
            return
        }
        pathArray.removeLast()
        self.setNeedsDisplay()
    }
    
    public func saveSignToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
