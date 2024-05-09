//
//  MineViewModel.swift
//  WMMine
//
//  Created by Condy on 2020/12/28.
//

import FeatBox
import RxNetworks

class MineViewModel: BaseViewModel, ViewModelEmptiable {
    
    public let users = BehaviorRelay<MineUsers?>(value: nil)
    
    public let datas = PublishRelay<[MineUsersSection]>()
    
    func requestUserInfo(with userId: String?) {
        let user = userInfo(userId).asObservable()
        let photo = photoAlbum(userId: userId).asObservable()
        let ranking = ranking(userId: userId).asObservable()
        let post = myPosts(userId: userId).asObservable()
        let zip = Observable.zip(user, photo, ranking, post)
        
        user.bind(to: users).disposed(by: rx.disposeBag)
        
        zip.subscribe(onNext: { [weak self] in
            let header = MineUsersSection.header(items: [.header(item: $0)])
            let photo = MineUsersSection.photo(items: [.photo(item: $1)])
            let ranking = MineUsersSection.ranking(items: [.ranking(item: $2)])
            let post = MineUsersSection.posts(items: [.posts(item: $3)])
            self?.datas.accept([header, photo, ranking, post])
        }, onCompleted: { [weak self] in
            X.removeLoadingHUDs()
            self?.refreshSubject.onNext(.endHeaderRefresh)
        }).disposed(by: rx.disposeBag)
    }
    
    /// 签到日历数据
    func requestCalender(date: Date, complete: @escaping ([MineSignInCalenderModel]?) -> Void) {
        // 模拟加载数据
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let tags: [CalenderTagType] = [.establish, .buy, .establish, .expire]
            let dates = [
                date.fy.adding(.day, value: 2),
                date.fy.adding(.day, value: 4),
                date.fy.adding(.day, value: 5),
                date.fy.adding(.day, value: 9),
            ]
            let days = dates.map {
                var model = MineSignInCalenderModel()
                model.time = $0.timeIntervalSince1970
                model.tag = tags[Int.random(in: 1..<tags.count)].rawValue
                model.date = $0
                model.sysDate = $0.fy.format(with: .yyyy_mm_dd)
                return model
            }
            complete(days)
        }
    }
}

extension MineViewModel: ViewModelHeaderable {
    public var enterBeginRefresh: Bool {
        return false
    }
}

extension MineViewModel {
    
    // 获取用户信息
    private func userInfo(_ userId: String?) -> Observable<MineUsers?> {
        guard let userId = userId else {
            return Observable.of(nil)
        }
        return MineAPI.mine(userId: userId).request()
            .mapHandyJSON(MineUsers.self)
            .map { $0 }
    }
    
    // 相册列表
    private func photoAlbum(userId: String?) -> Observable<[MinePhotoAlbum]> {
        guard let _ = userId else {
            return Observable.empty()
        }
        var album = MinePhotoAlbum()
        album.imagePahth = "https://raw.githubusercontent.com/yangKJ/Harbeth/master/Demo/Harbeth-iOS-Demo/Resources/Assets.xcassets/IMG_3960.imageset/IMG_3960.heic"
        album.sort = 0
        
        var album2 = MinePhotoAlbum()
        album2.imagePahth = "https://raw.githubusercontent.com/yangKJ/Harbeth/master/Screenshot/launch.jpeg"
        album2.sort = 1
        
        return Observable.of([album, album2])
    }
    
    // 世界排名
    private func ranking(userId: String?) -> Observable<String> {
        return Observable.of(Res.text("世界排行榜"))
    }
    
    // 我的帖子
    private func myPosts(userId: String?) -> Observable<[MinePostsDetail]> {
        guard let _ = userId else {
            return Observable.empty()
        }
        let posts: [MinePostsDetail] = (0...4).map {
            var post = MinePostsDetail()
            post.title = "标题000" + "\($0 + 1)"
            post.id = "\($0)"
            post.time = Date().timeIntervalSince1970
            return post
        }
        return Observable.of(posts)
    }
}
