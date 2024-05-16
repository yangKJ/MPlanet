//
//  FSPagerView+Rx.swift
//  WMDiscover
//
//  Created by Condy on 2024/5/10.
//

import Foundation
import RxCocoa
import RxSwift
@testable import FSPagerView // 访问私有内部属性方法等

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
                    base.numberOfItems = Int(Int16.max)
                    base.numberOfSections = datas.count
                    let loop = datas.count > 1 || base.removesInfiniteLoopForSingleItem == false
                    let count = base.isInfinite && loop ? base.numberOfItems / datas.count : 1
                    return Array.init(repeating: datas, count: count).reduce([], +)
                }
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
