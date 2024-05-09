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
  
  s.homepage         = 'https://github.com/Condy/FeatBox'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Condy' => 'yangkj310@gmail.com' }
  s.source           = { :git => 'https://github.com/Condy/FeatBox.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '10.0'
  s.swift_version    = '5.0'
  s.requires_arc     = true
  s.static_framework = true
  
  s.dependency 'ProductLib' ## 百宝箱工具库
  
  s.dependency 'Booming' # 插件网络架构，https://github.com/yangKJ/RxNetworks
  s.dependency 'RxNetworks' # 响应式网络架构，https://github.com/yangKJ/RxNetworks
  s.dependency 'RxCocoa' # 响应式架构，https://github.com/ReactiveX/RxSwift
  s.dependency 'RxGesture' # 手势响应式，https://github.com/RxSwiftCommunity/RxGesture
  s.dependency 'RxDataSources' # 列表响应式，https://github.com/RxSwiftCommunity/RxDataSources
  s.dependency 'RxSkeletonView' # 骨架架构，https://github.com/yangKJ/RxSkeletonView
  s.dependency 'Rickenbacker' # 基础架构，https://github.com/yangKJ/Rickenbacker
  s.dependency 'SnapKit' # 布局架构，https://github.com/SnapKit/SnapKit
  s.dependency 'Harbeth' # 滤镜框架，https://github.com/yangKJ/Harbeth
  s.dependency 'ImageX' # 图像框架，https://github.com/yangKJ/ImageX
  s.dependency 'SDWebImage' # 图像框架，https://github.com/SDWebImage/SDWebImage
  s.dependency 'YYText' # 富文本，https://github.com/ibireme/YYText
  s.dependency 'UITableView+FDTemplateLayoutCell' # Cell高度缓存，https://github.com/forkingdog/UITableView-FDTemplateLayoutCell
  s.dependency 'HandyJSON' # JSON解析，https://github.com/alibaba/HandyJSON
  s.dependency 'FSCalendar' # 日历框架，https://github.com/WenchaoD/FSCalendar
  
  
  s.source_files = 'FeatBox/**/**/*.{h,swift}'
  #s.resource = 'FeatBox/**/*.bundle'
  
  s.subspec 'Resources' do |xx|
    xx.resource_bundles = { s.name => [ 'FeatBox/**/**/*.{xcassets,Lproj}' ] }
  end
  
end
