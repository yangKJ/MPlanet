//
//  BaseCollectionViewCell.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import ProductLib

open class BaseCollectionViewCell: UICollectionViewCell {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.fy.background
        self.setupConstraint()
        self.setupBindings()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = UIColor.fy.background
        self.setupConstraint()
        self.setupBindings()
    }

    // 性能修复：override prepareForReuse，清理 imageView.image / DisposeBag
    // 防止 cell 复用时显示旧数据 / 订阅多次绑定造成内存泄漏
    public override func prepareForReuse() {
        super.prepareForReuse()
        clearReuseContent()
        if self is HasDisposeBag {
            (self as? HasDisposeBag)?.disposeBag = DisposeBag()
        }
    }

    /// 清理复用内容，子类可 override 实现更彻底的清理
    open func clearReuseContent() {
        // 递归清除 imageView.image（cell 中常见的 UIImageView 子树）
        for subview in contentView.subviews {
            cleanupImageView(in: subview)
        }
    }

    private func cleanupImageView(in view: UIView) {
        if let imageView = view as? UIImageView {
            imageView.image = nil
        }
        for sub in view.subviews {
            cleanupImageView(in: sub)
        }
    }

    // MARK: - 子类实现
    open func setupConstraint() {

    }

    open func setupBindings() {

    }
}
