#
# Be sure to run `pod lib lint FeatBox.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FeatBox'
  s.version          = '0.1.0'
  s.summary          = 'A short description of FeatBox.'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.homepage         = 'https://github.com/Condy/FeatBox'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Condy' => 'ykj310@126.com' }
  s.source           = { :git => 'https://github.com/Condy/FeatBox.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '10.0'
  s.swift_version    = '5.0'
  s.requires_arc     = true
  s.static_framework = true
  
  s.dependency 'RxNetworks' # 网络架构
  s.dependency 'RxCocoa' # 响应式架构
  s.dependency 'Rickenbacker' # 基础架构
  s.dependency 'SnapKit' # 布局架构
  s.dependency 'Harbeth' # 滤镜框架
  
  s.source_files = 'FeatBox/Classes/**/*'
  
end
