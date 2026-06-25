//
//  MineViewModel.swift
//  WMMine
//
//  Created by Condy on 2020/12/28.
//

import FeatBox

class MineViewModel: BaseTableViewModel, ViewModelEmptiable {

    let users = BehaviorRelay<MineUsers?>(value: nil)

    let tapUploadPhoto = PublishRelay<Int>()
    let rankingEvent = PublishRelay<Void>()
    let signInEvent = PublishRelay<Void>()
    let tapPostMoreEvent = PublishRelay<Void>()

    // 修复：`rx.disposeBag = DisposeBag()` 在 Swift 不可写（Reactive 是 struct），
    // 用独立 bag 字段做"重置 = 替换"，旧 bag 被替换时 ARC 自动 dispose，
    // 新 bag 接管后续订阅，避免 bag 叠加。
    private var bag = DisposeBag()

    func requestUserInfo(with userId: String?) {
        // 修复：原 userId 为 nil 时，MineAPI.mine 的 path 变成 "/users/"（空），
        // GitHub API 返回 404，deserialized 失败，UI 无数据。
        // 默认用 "yangKJ"（项目作者）作为 fallback，保证 demo 数据展示。
        let id = userId ?? "yangKJ"
        // 修复 bag 叠加：替换为新 bag（旧的会被 ARC 自动 dispose）
        bag = DisposeBag()
        let user = userInfo(id).asObservable()
        let photo = photoAlbum(userId: id).asObservable()
        let ranking = ranking(userId: id).asObservable()
        let post = myPosts(userId: id).asObservable()
        let zip = Observable.zip(user, photo, ranking, post)
        
        user.bind(to: users).disposed(by: bag)
        
        zip.subscribe(onNext: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let section0 = BaseTableViewHeaderFooterSection(cells: [])
            
            if let user = $0 {
                let userCell = MineUsersHeaderCellViewModel()
                userCell.sepratorLineHeight = 5
                userCell.cellHeight = 160
                userCell.datasource = $0
                userCell.signInEvent.bind(to: weakSelf.signInEvent).disposed(by: weakSelf.bag)
                section0.cells.append(userCell)
            }
            
            let photoCell = MineUsersPhotoCellViewModel()
            photoCell.sepratorLineHeight = 5
            photoCell.cellHeight = 120
            photoCell.datasource = $1
            photoCell.maxPhotos = 9
            photoCell.tapUploadPhoto.bind(to: weakSelf.tapUploadPhoto).disposed(by: weakSelf.bag)
            section0.cells.append(photoCell)
            
            let rankingCell = MineUsersRankingCellViewModel()
            rankingCell.cellHeight = 50
            rankingCell.datasource = $2
            rankingCell.cellDidSelectedEvent.bind(to: weakSelf.rankingEvent).disposed(by: weakSelf.bag)
            section0.cells.append(rankingCell)
            
            let section1 = CXTitleHeaderFooterViewModel(cells: [])
            section1.sectionHeaderViewType = CXTitleHeaderFooterView.self
            section1.sectionHeaderBackgroundColor = UIColor.fy.mainColor
            section1.sectionHeaderHeight = $3.count > 0 ? 40 : 0
            section1.sectionHeaderTitle = Res.text("我的帖子")
            section1.sectionHeaderTitleColor = UIColor.fy.white
            section1.sectionHeaderAccessoryText = Res.text("更多 >")
            section1.sectionHeaderAccessoryTitleColor = UIColor.fy.white
            section1.sectionHeaderLineColor = UIColor.fy.line
            section1.setAccessoryTap(block: { [weak self] _ in
                self?.tapPostMoreEvent.accept(())
            })
            
            for (index, post) in $3.enumerated() {
                var postCell = MineUsersPostsCellViewModel()
                postCell.datasource = post
                postCell.isFirst = index == 0
                postCell.isLast = index == $3.count-1
                postCell.sepratorLineHeight = CGFloat.fy.px1
                postCell.sepratorLineInsets = .init(horizontal: 15, vertical: 0)
                section1.cells.append(postCell)
            }
            
            self?.sections = [section0, section1]
            self?.reloadTableView()
        }, onError: { [weak self] error in
            UIViewController.fy.currentViewController()?.view.fy.showHUD(title: error.localizedDescription)
        }, onCompleted: { [weak self] in
            Booming.X.removeLoadingHUDs()
            self?.refreshSubject.onNext(.endHeaderRefresh)
        }).disposed(by: bag)
    }
    
    /// 签到日历数据
    func requestCalendar(date: Date, complete: @escaping ([String: MineSignInCalendarDTO]) -> Void) {
        // 模拟加载数据
        // 修复 bag 叠加：替换为新 bag（旧的会被 ARC 自动 dispose）
        bag = DisposeBag()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let tags: [CalendarTagType] = [.establish, .buy, .establish, .expire]
            // 适配 Date+Ext.adding 返回 Date?（修复 D.1 后的 API 变化）
            let dates: [Date] = [
                date.fy.adding(.day, value: 2),
                date.fy.adding(.day, value: 4),
                date.fy.adding(.day, value: 5),
                date.fy.adding(.day, value: 9),
            ].compactMap { $0 }
            let days = dates.map {
                var model = MineSignInCalendarDTO.init()
                model.time = $0.timeIntervalSince1970
                model.tag = CalendarTagType.allCases.randomElement()
                model.date = $0
                model.sysDate = $0.fy.format(with: .yyyy_mm_dd)
                return model
            }
            let dict = Dictionary.init(days.compactMap {
                $0.sysDate != nil ? ($0.sysDate!, $0) : nil
            }) { $1 }
            complete(dict)
        }
    }
}

extension MineViewModel: ViewModelHeaderable {
    public var enterBeginRefresh: Bool {
        return false
    }
    
    public var header: MJRefreshHeader {
        return MJRefreshAnimationHeader()
    }
}

extension MineViewModel {
    
    // 获取用户信息
    private func userInfo(_ userId: String?) -> Observable<MineUsers?> {
        guard let userId = userId else {
            return Observable.just(nil)
        }
        return MineAPI.mine(userId: userId).request()
            .deserialized(MineUsers.self)
    }
    
    // 相册列表
    private func photoAlbum(userId: String?) -> Observable<[MinePhotoAlbum]> {
        guard let userId = userId else {
            return Observable.from([]) // empty: 无数据的成功状态，直接触发 .completed
        }
        return MineAPI.photos(userId: userId).request()
            .deserialized(ApiResponse<[MinePhotoAlbum]>.self)
            .compactMap { $0?.data }
    }
    
    // 世界排名
    private func ranking(userId: String?) -> Single<String> {
        return Single.just(Res.text("世界排行榜"))
    }
    
    // 我的帖子
    private func myPosts(userId: String?) -> Single<[MinePostsDetail]> {
        guard let _ = userId else {
            return Single.just([])
        }
        return Single<[MinePostsDetail]>.create { single in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let mockTitles = [
                    "学钢琴三个月的心路历程",
                    "【新手必看】吉他调弦标准方法",
                    "周末编了一首 Lo-fi 风格曲子",
                    "发声练习三大基础：腹式呼吸/气息控制/共鸣位置",
                    "架子鼓入门：先练这 5 个节奏型"
                ]
                let mockContents = [
                    "今天终于把《卡农》前 16 小节练下来了，分享一下心得：节拍器 60 bpm 起步，慢练比快练更有效！",
                    "A=440Hz 基准，调弦顺序 6→5→4→3→2→1，新手建议买个调音器别靠耳朵。",
                    "用到的和弦走向是 ii-V-I，工程文件放在 GitHub 仓库里，需要的朋友自取。",
                    "新同学建议每天 10 分钟基础功，比直接唱歌 3 小时进步更快。",
                    "从 Rock 到 Jazz 都通用的节奏型，建议先用哑鼓练，熟了再上真鼓。"
                ]
                let mockImages = [
                    ["https://raw.githubusercontent.com/yangKJ/Harbeth/master/Screenshot/launch.jpeg"],
                    [],
                    ["https://raw.githubusercontent.com/yangKJ/Harbeth/master/Screenshot/launch.jpeg"],
                    [],
                    ["https://raw.githubusercontent.com/yangKJ/Harbeth/master/Screenshot/launch.jpeg"]
                ]
                let posts: [MinePostsDetail] = (0..<5).map { i in
                    var post = MinePostsDetail()
                    post.id = "\(i)"
                    post.title = mockTitles[i]
                    post.content = mockContents[i]
                    post.userId = 1001 + i
                    post.userName = "寻音小白"
                    post.userAvatar = "https://avatars.githubusercontent.com/u/17396101?v=4"
                    post.imageUrls = mockImages[i]
                    post.likeCount = [256, 1024, 512, 768, 333][i]
                    post.commentCount = [18, 86, 42, 55, 21][i]
                    post.createTime = ["5 分钟前", "1 小时前", "3 小时前", "今天 09:20", "昨天"][i]
                    post.time = Date().timeIntervalSince1970
                    return post
                }
                single(.success(posts))
            }
            return Disposables.create()
        }
    }
}
