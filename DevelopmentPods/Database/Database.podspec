#
# Be sure to run `pod lib lint Database.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Database'
  s.version          = '0.0.4'
  s.summary          = 'Collection of database tables.'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.homepage         = 'https://github.com/Condy/Database'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Condy' => 'ykj310@126.com' }
  s.source           = { :git => 'https://github.com/Condy/Database.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '9.0'
  s.default_subspec  = "Manager"
  
  ## 数据库工具模块
  s.subspec 'Manager' do |xx|
    xx.source_files = 'Database/Classes/Manager/*.swift'
    xx.dependency 'WCDB.swift'
  end
  
  s.subspec 'DApp' do |xx|
    xx.source_files = 'Database/Classes/DApp/*.swift'
    xx.dependency 'Database/Manager'
  end
  
  s.subspec 'Wallet' do |xx|
    xx.source_files = 'Database/Classes/Wallet/*.swift'
    xx.dependency 'Database/Manager'
  end
  
end
