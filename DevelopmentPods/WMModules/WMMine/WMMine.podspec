#
# Be sure to run 'pod lib lint WMMine.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WMMine'
  s.version          = '1.0.0'
  s.summary          = 'A short description of WMMine.'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.homepage         = 'https://github.com/yangKJ/WMMine'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangKJ' => 'your_email@example.com' }
  s.source           = { :git => 'https://github.com/yangKJ/WMMine.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '10.0'
  s.swift_version    = '5.0'
  s.requires_arc     = true
  s.static_framework = true
  
  s.dependency 'FeatBox'
  #s.dependency 'ZLPhotoBrowser' # 相册框架，https://github.com/longitachi/ZLPhotoBrowser
  
  s.source_files = 'Sources/Classes/**/**/*.swift'
  
  s.subspec 'Resources' do |xx|
    xx.resource_bundles = { s.name => ['Sources/Assets/*.{xcassets,lproj,json,gif}'] }
  end
  
end
