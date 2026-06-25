//
//  FloatButton.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import ProductLib
import SnapKit

public final class FloatButton: UIWindow {
    
    public var text: String? {
        didSet {
            label.text = text
        }
    }
    
    public var textColor: UIColor = UIColor.fy.white {
        didSet {
            label.textColor = textColor
        }
    }
    
    public var backgroundImage: UIImage? {
        didSet {
            backgroundView.image = backgroundImage
        }
    }
    
    public func setTabBlock(block: ((FloatButton) -> Void)?) {
        self.tabBlock = block
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public func show() {
        if !self.isHidden {
            return
        }
        self.rootViewController = UIViewController()
        self.isHidden = false
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    public func hide() {
        self.isHidden = true
    }
    
    // MARK: - private
    
    private var tabBlock: ((FloatButton) -> Void)?
    
    private lazy var backgroundView: UIImageView = {
        let imageView = BaseImageView.init(frame: .zero)
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = BaseLabel.init(frame: .zero)
        label.lineBreakMode = .byTruncatingTail
        label.closedAdjustsFontSizeToFitWidth = false
        label.textAlignment = .center
        label.textColor = textColor
        label.font = UIFont.fy.system_14
        return label
    }()
    
    private func setup() {
        self.windowLevel = .statusBar
        self.addSubview(label)
        self.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        label.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.greaterThanOrEqualTo(12)
            make.centerY.equalToSuperview().offset(-2)
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedGesture))
        self.addGestureRecognizer(gesture)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture(gestrue:)))
        self.addGestureRecognizer(pan)
    }
    
    @objc private func tappedGesture() {
        tabBlock?(self)
    }
    
    @objc private func panGesture(gestrue: UIPanGestureRecognizer) {
        let offsetPoint = gestrue.translation(in: gestrue.view)
        gestrue.setTranslation(CGPoint.zero, in: gestrue.view)
        let panView = gestrue.view
        var newCenter = CGPoint(x: center.x + offsetPoint.x, y: center.y + offsetPoint.y)
        let width  = self.frame.size.width
        let height = self.frame.size.height
        newCenter.x = min(max(width/2 + 10, newCenter.x), UIScreen.main.bounds.size.width - width/2 - 10)
        newCenter.y = min(max(height/2 + 10, newCenter.y), UIScreen.main.bounds.size.height - height/2 - 10)
        panView?.center = newCenter
    }
}
