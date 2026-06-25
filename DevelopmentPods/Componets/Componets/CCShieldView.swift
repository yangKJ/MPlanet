//
//  CCShieldView.swift
//  CommonView
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import UIKit

/// 防截屏控件
open class CCShieldView: UIView {

    private lazy var shieldView = {
        let view = UITextField()
        view.isSecureTextEntry = true
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        _setupUI()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func _setupUI() {
        addSubview(shieldView)
        shieldView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shieldView.widthAnchor.constraint(equalTo: widthAnchor),
            shieldView.heightAnchor.constraint(equalTo: heightAnchor),
        ])
    }
}
