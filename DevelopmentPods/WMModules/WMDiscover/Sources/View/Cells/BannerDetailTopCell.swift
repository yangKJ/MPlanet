//
//  BannerDetailTopCell.swift
//  WMDiscover
//
//  Created by Condy on 2023/5/29.
//

import Foundation
import FeatBox

class BannerDetailTopCell: BaseTableViewCell, HasDisposeBag {
    
    public let banners = BehaviorRelay<[Banner]>(value: [])
    public let currentIndex = PublishRelay<Int>()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30);
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .horizontal
        let width = self.frame.size.width - 60
        layout.itemSize = CGSize(width: width, height: 200)
        
        let view = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.delegate = self
        view.ai.register(BannerDetailTopCellCollectionViewCell.self)
        return view
    }()
    
    override func setupConstraint() {
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(collectionView.snp.width).multipliedBy(250.0/375.0).priority(999)
        }
    }
    
    override func setupBindings() {
        
        banners.bind(to: collectionView.rx.items) { (collectionView, row, element) in
            let indexPath = IndexPath.init(index: row)
            let item = collectionView.ai.dequeueReusableCell(BannerDetailTopCellCollectionViewCell.self, indexPath: indexPath)
            item.banner = element
            item.backgroundColor = UIColor.ai.random
            return item
        }.disposed(by: rx.disposeBag)
    }
}

extension BannerDetailTopCell: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.currentIndex.accept(indexPath.row)
    }
}

fileprivate class BannerDetailTopCellCollectionViewCell: BaseCollectionViewCell {
    
    var banner: Banner? {
        didSet {
            guard let banner = banner else {
                return
            }
            titleLabel.text = banner.title
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = DynamicFontSizeLabel.init()
        label.font = UIFont.ai.system_20
        label.textColor = UIColor.ai.title
        return label
    }()
    
    override func setupConstraint() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
