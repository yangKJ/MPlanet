//
//  BaseTableViewCell.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import ProductLib
import RxCocoa
import SnapKit

open class BaseTableViewCell: UITableViewCell {
    
    public let sepratorLineHeight = BehaviorRelay<CGFloat>(value: CGFloat.fy.px1)
    public let sepratorLineInsets = BehaviorRelay<UIEdgeInsets>(value: .zero)
    
    public lazy var sepratorLine: UIView = {
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
        fatalError("init(coder:) has not been implemented")
        self.setup()
    }
    
    private func setup() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.fy.background
        self.contentView.addSubview(sepratorLine)
        self.contentView.bringSubviewToFront(sepratorLine)
        self.sepratorLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            self.sepratorLineHeightConstraint = make.height.equalTo(sepratorLineHeight.value).constraint
        }
        self.setupCustomViewBinding__()
        self.setupConstraint()
        self.setupBindings()
    }
    
    // MARK: - subview methods
    
    open func setupConstraint() { }
    
    open func setupBindings() { }
    
    // MARK: - private methods
    
    let disposeBag = DisposeBag()
    var sepratorLineHeightConstraint: Constraint?
    
    lazy var clickContentView: UITapGestureRecognizer = {
        let click = UITapGestureRecognizer()
        click.numberOfTapsRequired = 1
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(click)
        return click
    }()
    
    private func setupCustomViewBinding__() {
        self.sepratorLineHeight.distinctUntilChanged().subscribe(onNext: { [weak self] height in
            self?.sepratorLineHeightConstraint?.update(offset: height)
        }).disposed(by: disposeBag)
        self.sepratorLineInsets.distinctUntilChanged().subscribe(onNext: { [weak self] _ in
            self?.setupLines()
        }).disposed(by: disposeBag)
    }
    
    private func setupLines() {
        guard sepratorLine.superview != nil else {
            return
        }
        self.sepratorLine.snp.remakeConstraints { (make) in
            make.left.equalTo(self.sepratorLineInsets.value.left)
            make.right.equalTo(self.sepratorLineInsets.value.right)
            make.bottom.equalToSuperview().offset(self.sepratorLineInsets.value.top - self.sepratorLineInsets.value.bottom)
            make.height.equalTo(self.sepratorLineHeight.value)
        }
    }
}

extension Reactive where Base: BaseTableViewCell {
    public var tapCell: Observable<Void> {
        return Observable.create({ [weak base] observer in
            if let base = base {
                base.clickContentView.rx.event.subscribe(onNext: { _ in
                    observer.onNext(())
                })
            } else {
                observer.onCompleted()
            }
            return Disposables.create()
        }).takeUntil(deallocated)
    }
}
