//
//  MineUsersPhotoCell.swift
//  WMMine
//
//  Created by Condy on 2023/6/6.
//

import Foundation
import FeatBox

class MineUsersPhotoCell: BaseTableViewCell, HasDisposeBag {
    
    static let maxPhotos = 9
    
    public let photos = BehaviorRelay<[MinePhotoAlbum]>(value: [])
    
    public let tapUploadPhoto = PublishRelay<Int>()
    
    lazy var titleLabel: UILabel = {
        let label = BaseLabel.init()
        label.font = UIFont.fy.system_14
        label.textColor = UIColor.fy.white
        label.text = Res.text("头像相册")
        return label
    }()
    
    lazy var photoScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.isPagingEnabled = false
        //scroll.bounces = false
        return scroll
    }()
    
    lazy var lastAddView: UIView = {
        var view = UIView()
        view.fy.cornerRadius = 2
        view.fy.borderPxwidthAndColor(UIColor.fy.gray_999999, px: 6)
        view.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let photos = self?.photos.value else {
                return
            }
            self?.tapUploadPhoto.accept(Self.maxPhotos - photos.count)
        }).disposed(by: rx.disposeBag)
        let label = UILabel()
        label.tag = 380
        label.text = Res.text("+")
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textColor = UIColor.fy.white
        view.addSubview(label)
        let label2 = BaseLabel()
        label2.tag = 480
        label2.font = UIFont.fy.system_10
        label2.textColor = UIColor.fy.white
        view.addSubview(label2)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-8)
            make.height.equalTo(30)
        }
        label2.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        return view
    }()
    
    override func setupConstraint() {
        self.lineHeight.accept(10)
        backgroundColor = UIColor.fy.mainColor
        contentView.addSubview(titleLabel)
        contentView.addSubview(photoScrollView)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(20)
        }
        photoScrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    override func setupBindings() {
        self.photos.subscribe(onNext: { [weak self] photos in
            self?.setupSubviewPhotos(photos)
        }).disposed(by: rx.disposeBag)
    }
    
    func setupSubviewPhotos(_ photos: [MinePhotoAlbum]) {
        photoScrollView.subviews.forEach { $0.removeFromSuperview() }
        let space = 10.0
        photoScrollView.layoutIfNeeded()
        let height = 70//photoScrollView.frame.size.height
        var lastImageView: UIImageView?
        let count = photos.count
        for (index, photo) in photos.enumerated() {
            let imageView = UIImageView.init()
            imageView.backgroundColor = UIColor.fy.white
            imageView.tag = 520 + index
            photoScrollView.addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.height.equalTo(height)
                make.width.equalTo(imageView.snp.height).multipliedBy(1.0).priority(999)
                if let lastImageView = lastImageView {
                    make.left.equalTo(lastImageView.snp.right).offset(space)
                }
                if index == 0 {
                    make.left.equalToSuperview()
                }
                if index == count - 1, count >= Self.maxPhotos {
                    make.right.equalToSuperview().offset(-space)
                }
            }
            lastImageView = imageView
            imageView.fy.setImage(with: photo.imagePahth)
        }
        if count < Self.maxPhotos {
            if let label = lastAddView.viewWithTag(480) as? BaseLabel {
                label.text = Res.text("还可上传") + "\(Self.maxPhotos - count)" + Res.text("张")
            }
            photoScrollView.addSubview(lastAddView)
            lastAddView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.height.equalTo(height)
                make.width.equalTo(lastAddView.snp.height).multipliedBy(1.0).priority(999)
                make.right.equalToSuperview().offset(-space)
                if let lastImageView = lastImageView {
                    make.left.equalTo(lastImageView.snp.right).offset(space)
                }
            }
        }
    }
}
