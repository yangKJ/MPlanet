//
//  MineUsersPhotoCell.swift
//  WMMine
//
//  Created by Condy on 2023/6/6.
//

import Foundation
import FeatBox

class MineUsersPhotoCellViewModel: BaseTableViewCellViewModelable {
    var cellType: FeatBox.BaseTableViewCell.Type {
        MineUsersPhotoCell.self
    }
    var maxPhotos: Int = 9
    let tapUploadPhoto = PublishRelay<Int>()
}

class MineUsersPhotoCell: BaseTableViewCell, HasDisposeBag {
    
    override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            guard let viewModel = viewModel as? MineUsersPhotoCellViewModel,
                  let photos = viewModel.datasource as? [MinePhotoAlbum] else {
                return
            }
            self.setupSubviewPhotos(photos, maxPhotos: viewModel.maxPhotos)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = BaseLabel.init()
        // 美化：标题用 bold_16，文字色用 title（深色）
        label.font = UIFont.fy.bold_16
        label.textColor = UIColor.fy.title
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
        var view = BaseView()
        view.fy.cornerRadius = 6
        // 美化：上传占位用虚线浅灰边框
        view.layer.borderWidth = CGFloat.fy.px1
        view.layer.borderColor = UIColor.fy.line.cgColor
        view.backgroundColor = UIColor.fy.backgroundGray
        view.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let viewModel = self?.viewModel as? MineUsersPhotoCellViewModel,
                  let photos = viewModel.datasource as? [MinePhotoAlbum] else {
                return
            }
            let count = max(0, min(viewModel.maxPhotos, viewModel.maxPhotos - photos.count))
            viewModel.tapUploadPhoto.accept(count)
        }).disposed(by: rx.disposeBag)
        let label = BaseLabel()
        label.closedAdjustsFontSizeToFitWidth = true
        label.text = Res.text("+")
        // 美化：+ 号字体从硬编码 50pt 改用 token，并使用主色
        label.font = UIFont.fy.system_20
        label.textColor = UIColor.fy.mainColor
        view.addSubview(label)
        let label2 = BaseLabel()
        label2.tag = 480
        label2.font = UIFont.fy.system_12
        label2.textColor = UIColor.fy.gray_999999
        label2.closedAdjustsFontSizeToFitWidth = false
        view.addSubview(label2)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-8)
            make.height.equalTo(28)
        }
        label2.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(2)
            make.left.right.equalToSuperview().inset(5)
        }
        return view
    }()

    /// 美化：白卡容器，把内容包成圆角卡片
    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.white
        v.layer.cornerRadius = 12
        v.layer.masksToBounds = true
        return v
    }()

    override func setupConstraint() {
        // 美化：从全绿底改成"灰背景 + 白卡"
        backgroundColor = UIColor.fy.backgroundGray
        contentView.backgroundColor = UIColor.fy.backgroundGray

        contentView.addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(photoScrollView)

        cardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-4)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(14)
            make.height.equalTo(22)
        }
        photoScrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(70)
        }
    }
    
    func setupSubviewPhotos(_ photos: [MinePhotoAlbum], maxPhotos: Int) {
        photoScrollView.subviews.forEach { $0.removeFromSuperview() }
        let space = 10.0
        /// 实时获取控件高度
        let height = photoScrollView.systemLayoutSizeFitting(.zero).height
        var lastImageView: BaseImageView?
        let count = photos.count
        for (index, photo) in photos.enumerated() {
            let imageView = BaseImageView()
            // 美化：照片缩略图占位色用 backgroundGray，与卡片风格统一
            imageView.backgroundColor = UIColor.fy.backgroundGray
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 6
            imageView.layer.masksToBounds = true
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
                    make.left.equalToSuperview().offset(space)
                }
                if index == count - 1, count >= maxPhotos {
                    make.right.equalToSuperview().offset(-space)
                }
            }
            lastImageView = imageView
            imageView.fy.setImage(with: photo.imagePath, placeholder: Placeholder.webImage)
        }
        if count < maxPhotos {
            if let label = lastAddView.viewWithTag(480) as? BaseLabel {
                label.text = Res.text("还可上传") + "\(maxPhotos - count)" + Res.text("张")
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
