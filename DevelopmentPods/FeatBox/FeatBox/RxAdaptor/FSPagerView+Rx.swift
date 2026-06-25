//
//  FSPagerView+Rx.swift
//  WMDiscover
//
//  Created by Condy on 2024/5/10.
//

import Foundation
import RxCocoa
import RxSwift
// @testable 是必要的：本扩展访问 FSPagerView 内部成员（dataSource、numberOfItems、numberOfSections、
// scrollOffset、isInfinite 等），这些是 internal 级别，常规 import 无法访问。
// 对一个学习项目来说，演示如何桥接第三方库的内部状态是合理的教学价值。
@testable import FSPagerView

extension Reactive where Base: FSPagerView {
    
    /// Binds sequences of elements to collection view items.
    /// - Parameter cellIdentifier: Identifier used to dequeue cells.
    /// - Returns: Disposable object that can be used to unbind.
    func items<Seq: Sequence, Cell: FSPagerViewCell, Source: ObservableType>(cellIdentifier: String? = nil)
    -> (_ source: Source)
    -> (_ configureCell: @escaping (Int, Seq.Element, Cell) -> Void)
    -> Disposable where Source.Element == Seq {
        base.collectionView.dataSource = nil
        return { source in
            let queue = DispatchQueue(label: "com.condy.fspagerview.items.queue.\(UUID().uuidString)")
            let type: ImmediateSchedulerType = ConcurrentDispatchQueueScheduler(queue: queue)
            let source = source.observe(on: type).map { sequence -> [Seq.Element] in
                let datas = Array(sequence)
                switch datas.count {
                case 0:
                    return []
                case 1:
                    base.numberOfItems = 1
                    base.numberOfSections = 1
                    return datas
                default:
                    base.numberOfItems = datas.count//Int(Int16.max)
                    let loop = datas.count > 1 || base.removesInfiniteLoopForSingleItem == false
                    let count = base.isInfinite && loop ? Int(Int16.max) / datas.count : 1
                    base.numberOfSections = count
                    return Array.init(repeating: datas, count: count).reduce([], +)
                }
            }
            defer {
                base.reloadData()
            }
            let cellIdentifier = cellIdentifier ?? "FSPagerViewCell"
            return base.collectionView.rx.items(cellIdentifier: cellIdentifier, cellType: Cell.self)(source)
        }
    }
    
    /// Reactive wrapper for `delegate` message `FSPagerView(_:didSelectItemAtIndex:)`.
    var didSelectItemAtIndex: ControlEvent<Int> {
        let source = base.collectionView.rx.itemSelected.flatMap { IndexPath in
            return Observable.just(IndexPath.row % base.numberOfSections)
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for `delegate` message `FSPagerView(pagerViewDidScroll:)`.
    var pagerViewDidScroll: ControlEvent<Int> {
        let source = base.collectionView.rx.didScroll.flatMap { () -> Observable<Int> in
            if base.numberOfItems > 0 {
                let currentIndex = lround(Double(base.scrollOffset)) % base.numberOfItems
                if (currentIndex != base.currentIndex) {
                    return Observable.just(currentIndex % base.numberOfSections)
                }
            }
            return Observable.never()
        }
        return ControlEvent(events: source)
    }
    
    /// A Boolean value indicates that whether the pager view has infinite items. Default is false.
    var isInfinite: Binder<Bool> {
        return Binder(base) {
            $0.isInfinite = $1
        }
    }
}

// MARK: - FSPageControl
extension Reactive where Base: FSPageControl {
    
    var numberOfPages: Binder<Int> {
        return Binder(base) {
            $0.numberOfPages = $1
        }
    }
    
    var currentPage: Binder<Int> {
        return Binder(base) {
            $0.currentPage = $1
        }
    }
}
