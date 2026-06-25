//
//  CCProgressView.swift
//  FeatBox
//
//  Created by Condy on 2022/4/25.
//

import Foundation
import UIKit

/// 进度控件
open class CCProgressView: UIView {
    
    public var radius: CGFloat = 0 {
        didSet {
            backgroundView.layer.cornerRadius = radius
            backgroundView.layer.masksToBounds = true
            backgroundView.layer.shouldRasterize = true
            backgroundView.layer.rasterizationScale = UIScreen.main.scale
            progressView.layer.cornerRadius = radius
            progressView.layer.masksToBounds = true
            progressView.layer.shouldRasterize = true
            progressView.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    public var progress: CGFloat = 0 {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.constraint = self.constraint.setMultiplier(min(1, max(0, self.progress)))
                self.progressView.layoutIfNeeded()
            }
        }
    }

    public func setProgress(_ progress: CGFloat, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.35) { [weak self] in
                self?.progress = progress
                //self.layoutIfNeeded()
            }
        } else {
            self.progress = progress
        }
    }
    
    public var backgroundViewColor: UIColor = UIColor.white {
        didSet {
            backgroundView.backgroundColor = backgroundViewColor
        }
    }
    
    public var progressColor: UIColor = UIColor.blue {
        didSet {
            progressView.backgroundColor = progressColor
            progressPoint.backgroundColor = progressColor
        }
    }
    
    public var showProgressPoint = false {
        didSet {
            progressPoint.isHidden = !showProgressPoint
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = backgroundViewColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var progressView: UIView = {
        let view = UIView()
        view.backgroundColor = progressColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var progressPoint: UIView = {
        let view = UIView()
        view.backgroundColor = progressColor
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        view.isHidden = !showProgressPoint
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var constraint: NSLayoutConstraint!
    
    private func setup() {
        addSubview(backgroundView)
        addSubview(progressView)
        addSubview(progressPoint)
        
        constraint = progressView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: min(1, max(0, progress)))
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: rightAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 2.0),
            
            progressView.topAnchor.constraint(equalTo: topAnchor),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor),
            progressView.leftAnchor.constraint(equalTo: leftAnchor),
            constraint,
            
            progressPoint.centerYAnchor.constraint(equalTo: centerYAnchor),
            progressPoint.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            progressPoint.widthAnchor.constraint(equalToConstant: 6),
            progressPoint.heightAnchor.constraint(equalToConstant: 6),
        ])
    }
}

extension NSLayoutConstraint {
    
    fileprivate func setMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        guard let firstItem = firstItem else {
            return self
        }
        NSLayoutConstraint.deactivate([self])
        let newConstraint = NSLayoutConstraint(item: firstItem,
                                               attribute: firstAttribute,
                                               relatedBy: relation,
                                               toItem: secondItem,
                                               attribute: secondAttribute,
                                               multiplier: multiplier,
                                               constant: constant)
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
