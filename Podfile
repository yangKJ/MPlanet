# Uncomment the next line to define a global platform for your project

source 'https://github.com/CocoaPods/Specs.git'
#source 'git@github.com:Condy/PrivatePod.git' # 私有索引

platform :ios, '10.0' # 这个版本为所有CocoaPods里面`s.ios.deployment_target`支持的最低版本
inhibit_all_warnings!
use_frameworks!

def modules_pods
  
  ## 发现模块
  pod 'WMDiscover', :path => 'DevelopmentPods/WMModules/WMDiscover'
  ## 我的模块
  pod 'WMMine', :path => 'DevelopmentPods/WMModules/WMMine'
  ## 钱包首页
  pod 'WMWallet', :path => 'DevelopmentPods/WMModules/WMWallet'
  
end

target 'MainProject_Example' do
  
  ## AppDelegate解偶拆解
  pod 'RootManager', :path => 'DevelopmentPods/RootManager'
  
  ## 主tabBar
  pod 'AppMain', :path => 'DevelopmentPods/AppMain'
  
  ## 路由组件
  pod 'Mediator', :path => 'DevelopmentPods/Mediator'
  
  ## 公共部分
  pod 'FeatBox', :path => 'DevelopmentPods/FeatBox'
  
  ## 数据库部分
  pod 'Database', :path => 'DevelopmentPods/Database'
  
  ## 公共UI
#  pod 'CommonView', :path => '../CommonView'
  
  modules_pods

end

target 'MainProject_Tests' do
  inherit! :search_paths

end
