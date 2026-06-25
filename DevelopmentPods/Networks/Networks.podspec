#
# Be sure to run 'pod lib lint Networks.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Networks'
  s.version          = '1.0.0'
  s.summary          = 'A short description of Networks.'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.homepage         = 'https://github.com/yangKJ/Networks'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangKJ' => 'your_email@example.com' }
  s.source           = { :git => 'https://github.com/yangKJ/Networks.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '10.0'
  s.swift_version    = '5.0'
  s.requires_arc     = true
  s.static_framework = true
  
  s.dependency 'RxSwift' # 响应式架构，https://github.com/ReactiveX/RxSwift
  
  s.dependency 'Booming', '~> 1.1.2' # 插件网络基础架构，https://github.com/yangKJ/RxNetworks
  s.dependency 'NetworkHudsPlugin' # 插件，https://cocoapods.org/pods/NetworkHudsPlugin
  s.dependency 'NetworkCachePlugin' # 缓存插件，https://cocoapods.org/pods/NetworkCachePlugin
  s.dependency 'NetworkLottiePlugin' # 加载插件，https://cocoapods.org/pods/NetworkLottiePlugin
  s.dependency 'SmartCodable' # 数据序列化架构，https://github.com/intsig171/SmartCodable，替代HandyJSON
  #s.dependency 'HollowCodable' # 数据序列化架构，https://github.com/yangKJ/HollowCodable
  #s.dependency 'HandyJSON' # JSON解析，https://github.com/alibaba/HandyJSON
  
  s.source_files = 'Networks/**/**/*.{h,swift}'
  
end
