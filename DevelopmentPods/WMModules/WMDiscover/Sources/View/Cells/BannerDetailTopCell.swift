//
//  BannerDetailTopCell.swift
//  WMDiscover
//
//  Created by Condy on 2023/5/29.
//

import Foundation
import FeatBox

class BannerDetailTopCell: BaseTableViewCell, HasDisposeBag {
    
    static let spaceing = 15.0
    
    typealias BannerAndIndexType = (index: Int?, banners: [Banner])
    public let bannersAndIndex = BehaviorRelay<BannerAndIndexType>(value: (0, []))
    public let currentIndex = PublishRelay<Int>()
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = BannerDetailTopCellFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = BannerDetailTopCell.spaceing
        layout.scrollDirection = .horizontal
        let width = C.width - BannerDetailTopCell.spaceing * 4
        layout.itemSize = CGSize(width: width, height: width * 250.0 / 375.0)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isPagingEnabled = true
        view.isScrollEnabled = true
        view.scrollsToTop = false
        view.clipsToBounds = false
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
        
        bannersAndIndex.map { $0.banners.count > 1 }
            .bind(to: collectionView.rx.isScrollEnabled)
            .disposed(by: rx.disposeBag)
        
        bannersAndIndex.map { $0.banners }
            .bind(to: collectionView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let item = collectionView.ai.dequeueReusableCell(BannerDetailTopCellCollectionViewCell.self, indexPath: indexPath)
                item.banner = element
                return item
            }.disposed(by: rx.disposeBag)
        
        bannersAndIndex
            .delaySubscription(.milliseconds(5), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let index = $0.index, $0.banners.count > index else {
                    return
                }
                self?.gotoIndex(at: index)
            }).disposed(by: rx.disposeBag)
        
        self.collectionView.rx.didEndDecelerating.subscribe(onNext: { [weak self] _ in
            guard let page = self?.page else {
                return
            }
            self?.gotoIndex(at: page)
            self?.currentIndex.accept(page)
        }).disposed(by: rx.disposeBag)
    }
    
    private var page: Int {
        get {
            let content = layout.minimumLineSpacing + layout.itemSize.width
            let dex = (self.collectionView.contentOffset.x + content * 0.5) / content
            return Int(max(0, dex))
        }
    }
    
    private func gotoIndex(at page: Int) {
        let content = layout.minimumLineSpacing + layout.itemSize.width
        let x = CGFloat(page) * content
        collectionView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
}

fileprivate class BannerDetailTopCellFlowLayout: UICollectionViewFlowLayout {
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepare() {
        super.prepare()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let elements = super.layoutAttributesForElements(in: rect)
        //let centerX = collectionView.contentOffset.x + collectionView.bounds.size.width / 2
        elements?.forEach({ attributes in
            //let centerDistance = abs(attributes.center.x - centerX)
            //let scale = 1.0 / (1 + centerDistance * 0.001)
            //attributes.transform = CGAffineTransformMakeScale(scale, scale)
            attributes.center.x = attributes.center.x + self.minimumLineSpacing * 2 // 向右偏移
        })
        return elements
    }
}

fileprivate class BannerDetailTopCellCollectionViewCell: BaseCollectionViewCell {
    
    var banner: Banner? {
        didSet {
            guard let banner = banner else {
                return
            }
            titleLabel.text = banner.title
            if let imagePath = banner.imagePath {
                backImageView.ai.setImage(with: imagePath, module: DiscoverUtil.moduleName, contentMode: .scaleAspectFill)
            }
        }
    }
    
    lazy var backImageView: UIImageView = {
        var view = UIImageView()
        view.ai.cornerRadius = 22
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = DynamicFontSizeLabel.init()
        label.font = UIFont.ai.system_20
        label.textColor = UIColor.ai.title
        return label
    }()
    
    lazy var seeCardNoButton: UIButton = {
        var button = CustomButton.init(type: .custom)
        button.setTitle(R.text("查看卡号"), for: .normal)
        button.setTitleColor(UIColor.ai.gray_666666, for: .normal)
        button.titleLabel?.font = UIFont.ai.system_14
        button.backgroundColor = UIColor.ai.gray_F7F7F7
        button.ai.corOfShadow = 20
        return button
    }()
    
    override func setupConstraint() {
        contentView.addSubview(backImageView)
        contentView.addSubview(seeCardNoButton)
        backImageView.addSubview(titleLabel)
        backImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-BannerDetailTopCell.spaceing)
            make.left.right.equalToSuperview()
            make.height.equalTo(backImageView.snp.width).multipliedBy(230.0/375.0).priority(999)
        }
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        seeCardNoButton.snp.makeConstraints { make in
            make.top.equalTo(backImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(75)
            make.height.equalTo(22)
        }
    }
}
