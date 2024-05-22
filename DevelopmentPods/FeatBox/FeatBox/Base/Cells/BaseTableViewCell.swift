//
//  BaseTableViewCell.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import ProductLib
import RxCocoa
import Rickenbacker
import SnapKit

open class BaseTableViewCell: UITableViewCell {
    
    public let lineHeight = BehaviorRelay<CGFloat>(value: 0.0002)
    public let lineConstraint = PublishRelay<(top: CGFloat?, leading: CGFloat?, trailing: CGFloat?)>()
    public let lineColor = BehaviorRelay<UIColor>(value: UIColor.fy.white)
    
    public required override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.fy.background
        self.setupCustomView__()
        self.setupCustomViewBinding__()
        self.setupConstraint()
        self.setupBindings()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - subview methods
    
    open func setupConstraint() { }
    
    open func setupBindings() { }
    
    // MARK: - private methods
    
    lazy var sepratorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.fy.white
        return view
    }()
    
    lazy var clickContentView: UITapGestureRecognizer = {
        let click = UITapGestureRecognizer()
        click.numberOfTapsRequired = 1
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(click)
        return click
    }()
    
    private var lineTConstraint: Constraint?
    private var lineLConstraint: Constraint?
    private var lineRConstraint: Constraint?
    private var lineHConstraint: Constraint?
    
    func setupCustomView__() {
        contentView.addSubview(sepratorLine)
        contentView.bringSubviewToFront(sepratorLine)
        sepratorLine.snp.makeConstraints { make in
            self.lineTConstraint = make.top.equalToSuperview().constraint
            self.lineLConstraint = make.leading.equalToSuperview().constraint
            self.lineRConstraint = make.trailing.equalToSuperview().constraint
            self.lineHConstraint = make.height.equalTo(lineHeight.value).constraint
        }
    }
    
    func setupCustomViewBinding__() {
        self.lineColor.bind(to: sepratorLine.rx.backgroundColor).disposed(by: rx.disposeBag)
        self.lineHeight.subscribe(onNext: { [weak self] height in
            self?.lineHConstraint?.update(offset: height)
        }).disposed(by: rx.disposeBag)
        self.lineConstraint.subscribe(onNext: { [weak self] in
            if let top = $0.top {
                self?.lineTConstraint?.update(offset: top)
            }
            if let left = $0.leading {
                self?.lineLConstraint?.update(offset: left)
            }
            if let right = $0.trailing {
                self?.lineRConstraint?.update(offset: right)
            }
        }).disposed(by: rx.disposeBag)
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
