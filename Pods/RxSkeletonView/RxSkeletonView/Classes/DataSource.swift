//
//  DataSource.swift
//  RxSkeletonView
//
//  Created by Condy on 2022/2/5.
//

import Foundation
import RxDataSources
import SkeletonView
import protocol Differentiator.AnimatableSectionModelType

public final class RxTableViewSkeletonDataSource<Section: AnimatableSectionModelType>: RxTableViewSectionedAnimatedDataSource<Section> {
    
    public typealias SkeletonNumberSections = (RxTableViewSkeletonDataSource<Section>, UITableView) -> Int
    public typealias SkeletonNumberOfRowsInSection = (RxTableViewSkeletonDataSource<Section>, UITableView, Int) -> Int
    public typealias SkeletonReusableCellIdentifierAtIndexPath = (RxTableViewSkeletonDataSource<Section>, UITableView, IndexPath) -> ReusableCellIdentifier
    public typealias SkeletonCellForRowAtIndexPath = (RxTableViewSkeletonDataSource<Section>, UITableView, IndexPath) -> UITableViewCell?
    
    fileprivate let skeletonNumberSections: SkeletonNumberSections
    fileprivate let skeletonNumberOfRowsInSection: SkeletonNumberOfRowsInSection
    fileprivate let skeletonReusableCellIdentifierAtIndexPath: SkeletonReusableCellIdentifierAtIndexPath
    fileprivate let skeletonCellForRowAtIndexPath: SkeletonCellForRowAtIndexPath
    
    public required init(
        animationConfiguration: AnimationConfiguration = AnimationConfiguration(),
        decideViewTransition: @escaping DecideViewTransition = { _, _, _ in ViewTransition.animated },
        configureCell: @escaping ConfigureCell,
        titleForHeaderInSection: @escaping TitleForHeaderInSection = { _, _ in nil },
        titleForFooterInSection: @escaping TitleForFooterInSection = { _, _ in nil },
        canEditRowAtIndexPath: @escaping CanEditRowAtIndexPath = { _, _ in false },
        canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath = { _, _ in false },
        sectionIndexTitles: @escaping SectionIndexTitles = { _ in nil },
        sectionForSectionIndexTitle: @escaping SectionForSectionIndexTitle = { _, _, index in index },
        skeletonNumberSections: @escaping SkeletonNumberSections = { _, _ in 1 },
        skeletonNumberOfRowsInSection: @escaping SkeletonNumberOfRowsInSection = { _, _, _ in UITableView.automaticNumberOfSkeletonRows },
        skeletonReusableCellIdentifierAtIndexPath: @escaping SkeletonReusableCellIdentifierAtIndexPath,
        skeletonCellForRowAtIndexPath: @escaping SkeletonCellForRowAtIndexPath = { _, _, _ in nil }
    ) {
        self.skeletonNumberSections = skeletonNumberSections
        self.skeletonNumberOfRowsInSection = skeletonNumberOfRowsInSection
        self.skeletonReusableCellIdentifierAtIndexPath = skeletonReusableCellIdentifierAtIndexPath
        self.skeletonCellForRowAtIndexPath = skeletonCellForRowAtIndexPath
        
        super.init(
            animationConfiguration: animationConfiguration,
            decideViewTransition: decideViewTransition,
            configureCell: configureCell,
            titleForHeaderInSection: titleForHeaderInSection,
            titleForFooterInSection: titleForFooterInSection,
            canEditRowAtIndexPath: canEditRowAtIndexPath,
            canMoveRowAtIndexPath: canMoveRowAtIndexPath,
            sectionIndexTitles: sectionIndexTitles,
            sectionForSectionIndexTitle: sectionForSectionIndexTitle
        )
    }
}

extension RxTableViewSkeletonDataSource: SkeletonTableViewDataSource {
    
    public func numSections(in collectionSkeletonView: UITableView) -> Int {
        return skeletonNumberSections(self, collectionSkeletonView)
    }
    
    public func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skeletonNumberOfRowsInSection(self, skeletonView, section)
    }
    
    public func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return skeletonReusableCellIdentifierAtIndexPath(self, skeletonView, indexPath)
    }
    
    public func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        return skeletonCellForRowAtIndexPath(self, skeletonView, indexPath)
    }
}
