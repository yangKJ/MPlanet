# Uncomment the next line to define a global platform for your project

source 'https://github.com/CocoaPods/Specs.git'
#source 'git@github.com:Condy/PrivatePod.git' # 私有索引

#platform :ios, '10.0' # 这个版本为所有CocoaPods里面`s.ios.deployment_target`支持的最低版本
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
  
  ## 公共部分《项目耦合》
  pod 'FeatBox', :path => 'DevelopmentPods/FeatBox'
  
  ## 数据库部分
  pod 'Database', :path => 'DevelopmentPods/Database'
  
  ## 独立公共控件
  pod 'CommonView', :path => 'DevelopmentPods/CommonView'
  
  ## 百宝箱工具
  pod 'Extensions', :path => 'DevelopmentPods/Extensions'
  
  modules_pods
  
end

target 'MainProject_Tests' do
  inherit! :search_paths
  
end

## https://github.com/CocoaPods/CocoaPods/issues/11402
post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
            target.build_configurations.each do |config|
                config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
            end
        end
    end
    ## Fixed run mac book 14 os 13.2.1
    ## See: https://stackoverflow.com/questions/75574268/missing-file-libarclite-iphoneos-a-xcode-14-3
    installer.generated_projects.each do |project|
       project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
          end
       end
    end
end

