//
//  BaseTableViewCell.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import ProductLib
import SnapKit
import RxCocoa

open class BaseTableViewCell: UITableViewCell, Storyboardable {

    open var viewModel: BaseTableViewCellViewModelable?

    public lazy var sepratorLine: ZLineView = {
        let view = ZLineView(asix: .horizontal, thickness: CGFloat.fy.px1)
        view.backgroundColor = UIColor.fy.line
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.tag = 999
        blurView.frame.size = view.frame.size
        view.addSubview(blurView)
        return view
    }()

    public required override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
        // Storyboardable 子类不支持 Storyboard 加载,统一错误入口
        StoryboardableFatal.notImplemented(coder: coder)
    }

    func setSepratorLine(height: CGFloat, insets: UIEdgeInsets) {
        guard sepratorLine.superview != nil, insets != .zero else {
            return
        }
        self.sepratorLine.snp.remakeConstraints { make in
            make.left.equalTo(insets.left)
            make.right.equalTo(-insets.right)
            make.bottom.equalTo(insets.top - insets.bottom)
            make.height.equalTo(height).priority(.high)
        }
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        if self is HasDisposeBag {
            // 解决Cell重用导致订阅取消或者多次订阅问题，避免内存泄漏和数据错乱
            // 重新创建一个新的，之前的所有订阅都会被释放，保证复用Cell都是全新的绑定
            (self as? HasDisposeBag)?.disposeBag = DisposeBag()
        }
        // 性能修复：清理 imageView.image，防止 cell 复用时显示旧数据
        clearReuseContent()
    }

    /// 清理复用内容（递归清理 contentView 子树中的 UIImageView.image）
    open func clearReuseContent() {
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
    
    private func setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCellClick))
        self.contentView.isUserInteractionEnabled = true
        self.contentView.addGestureRecognizer(tap)
        self.backgroundColor = UIColor.fy.background
        self.setupLines()
        self.setupConstraint()
        self.setupBindings()
        self.contentView.bringSubviewToFront(sepratorLine)
    }
    
    private func setupLines() {
        self.contentView.addSubview(sepratorLine)
        self.sepratorLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(CGFloat.fy.px1)
        }
    }
    
    @objc private func tapCellClick(_ tap: UIGestureRecognizer) {
        self.viewModel?.cellDidSelectedBlock?()
        self.viewModel?.cellDidSelectedEvent.accept(())
    }
    
    // MARK: - subview methods
    
    open func setupConstraint() { }
    
    open func setupBindings() { }
}

//extension Reactive where Base: BaseTableViewCell {
//    public var tapCell: Observable<Void> {
//        return Observable.create({ [weak base] observer in
//            if let base = base {
//                base.clickContentView.rx.event.subscribe(onNext: { _ in
//                    observer.onNext(())
//                })
//            } else {
//                observer.onCompleted()
//            }
//            return Disposables.create()
//        }).takeUntil(deallocated)
//    }
//}
