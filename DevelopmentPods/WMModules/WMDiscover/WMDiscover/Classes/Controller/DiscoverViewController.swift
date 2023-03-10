//
//  DiscoverViewController.swift
//  WMDiscover
//
//  Created by Condy on 2020/12/28.
//

import FeatBox
import Wintersweet

class DiscoverViewController: VMTableViewController<DiscoverViewModel> {

    private static let identifier = "DiscoverCellIdentifier"
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        return view
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
        self.setupUI()
        self.testGIF()
    }
    
    func setupInit() {
        self.hbd_barShadowHidden = true
        self.navigationItem.leftBarButtonItem = nil
    }
    
    func setupUI() {
        view.addSubview(imageView)
        view.addSubview(label)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(imageView.snp.width)
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
    }
    
    let filters: [C7FilterProtocol] = [
        C7SoulOut(soul: 0.75),
        C7Storyboard(ranks: 2),
    ]
    func testGIF() {
        let links = [
            "pikachu",
            "https://raw.githubusercontent.com/yangKJ/Wintersweet/master/Images/IMG_0139.gif",
            "https://raw.githubusercontent.com/yangKJ/Harbeth/master/Demo/Harbeth-iOS-Demo/Resources/Assets.xcassets/IMG_3960.imageset/IMG_3960.heic"
        ]
        let named = links.randomElement() ?? ""
        let options = AnimatedOptions(
            loop: .forever,
            placeholder: .image(FeatBox.Placeholder.mainColor),
            contentMode: .scaleAspectFit,
            bufferCount: 20,
            cacheOption: .disk,
            cacheCrypto: .sha1,
            cacheDataZip: .gzip,
            moduleName: DiscoverUtil.moduleName,
            preparation: { [weak self] in
                guard let `self` = self else { return }
                self.label.text = "\(self.imageView.frameCount) frames / \(String(format: "%.2f", self.imageView.loopDuration))s"
            }, animated: { _ in
                print("Played end!!!")
            })
        imageView.mt.displayImage(named: named, filters: filters, options: options)
    }
}
