#
# Be sure to run 'pod lib lint WMChat.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WMChat'
  s.version          = '1.0.0'
  s.summary          = '寻音星球 - 消息模块。'

  s.homepage         = 'https://github.com/yangKJ/WMChat'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangKJ' => 'your_email@example.com' }
  s.source           = { :git => 'https://github.com/yangKJ/WMChat.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'
  s.swift_version    = '5.0'
  s.requires_arc     = true
  s.static_framework = true

  s.dependency 'FeatBox'

  s.source_files = 'Sources/Classes/**/**/*.swift'

  s.subspec 'Resources' do |xx|
    xx.resource_bundles = { s.name => ['Sources/Assets/*.{xcassets,lproj,json,gif}'] }
  end

end
