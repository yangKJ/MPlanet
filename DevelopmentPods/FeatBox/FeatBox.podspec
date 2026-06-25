#
# Be sure to run 'pod lib lint FeatBox.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FeatBox'
  s.version          = '2.0.0'
  s.summary          = 'A short description of FeatBox.'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.homepage         = 'https://github.com/yangKJ/FeatBox'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangKJ' => 'your_email@example.com' }
  s.source           = { :git => 'https://github.com/yangKJ/FeatBox.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '10.0'
  s.swift_version    = '5.0'
  s.requires_arc     = true
  s.static_framework = true
  
  s.dependency 'ProductLib' ## 百宝箱工具库
  s.dependency 'Componets' ## 独立公共控件
  s.dependency 'Networks' ## 网络组件
  s.dependency 'Mediator' ## 路由
  #s.dependency 'Database' ## 数据库
  
  s.dependency 'RxCocoa' # 响应式架构，https://github.com/ReactiveX/RxSwift
  s.dependency 'RxGesture' # 手势响应式，https://github.com/RxSwiftCommunity/RxGesture
  s.dependency 'RxDataSources' # 列表响应式，https://github.com/RxSwiftCommunity/RxDataSources
  s.dependency 'RxSkeletonView' # 骨架架构，https://github.com/yangKJ/RxSkeletonView
  s.dependency 'Rickenbacker/Core' # 基础架构，https://github.com/yangKJ/Rickenbacker
  s.dependency 'Rickenbacker/DZNEmptyDataSet'
  s.dependency 'Rickenbacker/MJRefresh'
  s.dependency 'SnapKit' # 布局架构，https://github.com/SnapKit/SnapKit
  s.dependency 'Harbeth' # 滤镜框架，https://github.com/yangKJ/Harbeth
  #s.dependency 'ImageX' # 图像框架，https://github.com/yangKJ/ImageX
  s.dependency 'SDWebImage' # 图像框架，https://github.com/SDWebImage/SDWebImage
  s.dependency 'YYText' # 富文本，https://github.com/ibireme/YYText
  s.dependency 'MPITextKit' # 富文本（替代YYText），https://github.com/meitu/MPITextKit
  s.dependency 'UITableView+FDTemplateLayoutCell' # Cell高度缓存，https://github.com/forkingdog/UITableView-FDTemplateLayoutCell
  s.dependency 'FSCalendar' # 日历框架，https://github.com/WenchaoD/FSCalendar
  s.dependency 'FSPagerView' # 轮播图，https://github.com/WenchaoD/FSPagerView
  #s.dependency 'Presentation' # 动画幻灯片，https://github.com/hyperoslo/Presentation
  s.dependency 'SwifterSwift/UIKit' # 扩展库，https://github.com/SwifterSwift/SwifterSwift
  s.dependency 'SwifterSwift/Foundation' # 扩展库，https://github.com/SwifterSwift/SwifterSwift
  s.dependency 'WKWebViewJavascriptBridge' # 网页扩展库，https://github.com/Lision/WKWebViewJavascriptBridge
  s.dependency 'CHIPageControl' # 指示器，https://github.com/ChiliLabs/CHIPageControl
  #s.dependency 'ImageViewer' # 图像浏览器，https://github.com/Krisiacik/ImageViewer
  #s.dependency 'YPImagePicker' # 相册框架，https://github.com/Yummypets/YPImagePicker
  s.dependency 'ViewAnimator' # 动画框架，https://github.com/marcosgriselli/ViewAnimator
  
  s.source_files = 'FeatBox/**/**/*.{h,m,swift}'
  #s.resource = 'FeatBox/**/*.bundle'
  
  s.subspec 'Resources' do |xx|
    xx.resource_bundles = { s.name => [ 'FeatBox/**/**/*.{xcassets,Lproj,json}' ] }
  end
  
end
