//
//  UISegmentedControl+Rx.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UISegmentedControl {
    
    public var tap: Observable<Int> {
        return base.rx.controlEvent(.valueChanged).flatMap { [weak base] in
            guard let weakbase = base else {
                return Observable<Int>.empty()
            }
            return weakbase.rx.selectedSegmentIndex.asObservable()
        }
    }
}
