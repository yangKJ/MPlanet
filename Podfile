# ============================================================
# MPlanet Podfile
# ------------------------------------------------------------
# 部署目标: iOS 15.0
# 源仓库:   CocoaPods 官方 CDN (cdn.cocoapods.org)
#           说明: CI (GitHub Actions) 拉不动清华镜像,已切换到
#                 官方 CDN 以保证 CI / 国外开发者本地都能 install。
# ============================================================

platform :ios, '15.0'

source 'https://cdn.cocoapods.org/'
#source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git' # 国内可改回清华镜像
#source 'git@github.com:your-username/PrivatePod.git' # 私有索引

inhibit_all_warnings!
use_frameworks!

def modules_pods

  ## 发现模块
  pod 'WMDiscover', :path => 'DevelopmentPods/WMModules/WMDiscover'
  ## 学习模块
  pod 'WMLearn', :path => 'DevelopmentPods/WMModules/WMLearn'
  ## 主题模块
  pod 'WMTopics', :path => 'DevelopmentPods/WMModules/WMTopics'
  ## 消息模块
  pod 'WMChat', :path => 'DevelopmentPods/WMModules/WMChat'
  ## 我的模块
  pod 'WMMine', :path => 'DevelopmentPods/WMModules/WMMine'
  ## 钱包/会员模块（登录后动态插入）
  pod 'WMWallet', :path => 'DevelopmentPods/WMModules/WMWallet'
end

def test_tools_pods
  
  # DiDi开发工具
  pod 'DoraemonKit/Core', :configurations => ['Debug']
  #  pod 'DoraemonKit/WithMLeaksFinder', :configurations => ['Debug'] # 查找内存泄漏
  #  pod 'DoraemonKit/WithGPS', :configurations => ['Debug'] # 模拟定位功能
  #  pod 'DoraemonKit/WithLoad', :configurations => ['Debug'] # 集成Load耗时检测
  #  pod 'DoraemonKit/WithDatabase', :configurations => ['Debug'] # 网页端调式数据库
  #  pod 'DoraemonKit/WithLogger', :configurations => ['Debug'] # 基于CocoaLumberjack的日志
  #  pod 'GDPerformanceView', :configurations => ['Debug']
  
  # 猴子调试工具<UI压力测试>
  #pod "SwiftMonkeyPaws", :configurations => ['Debug']
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
  
  ## 独立公共控件
  pod 'Componets', :path => 'DevelopmentPods/Componets'
  
  ## 百宝箱工具
  pod 'ProductLib', :path => 'DevelopmentPods/ProductLib'
  
  ## 网络组件
  pod 'Networks', :path => 'DevelopmentPods/Networks'
  
  modules_pods
  
  #test_tools_pods
  
end

target 'MainProject_Tests' do
  inherit! :search_paths

  # 测试需要的依赖(Rx 用于 Once/Relay 等;ProductLib 是主仓 Tests 直接 @testable import 的目标)
  pod 'RxSwift', '~> 6.9.0'
  pod 'RxCocoa', '~> 6.9.0'

  # 业务模块挂载:让 Tests/Tests.swift 能 @testable import ProductLib/FeatBox/Mediator
  pod 'ProductLib',  :path => 'DevelopmentPods/ProductLib'
  pod 'FeatBox',     :path => 'DevelopmentPods/FeatBox'
  pod 'Mediator',    :path => 'DevelopmentPods/Mediator'
  pod 'Networks',    :path => 'DevelopmentPods/Networks'
  pod 'Componets',   :path => 'DevelopmentPods/Componets'
  pod 'RootManager', :path => 'DevelopmentPods/RootManager'
end

$static_framework = ['SnapKit']

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
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
          end
       end
    end
    ## 强制把 MainProject_Tests 的 deployment target 也升到 15.0,
    ## 否则 ProductLib/FeatBox 等 iOS 15 的 pod 会编译失败。
    installer.aggregate_targets.each do |aggregate|
        aggregate.user_project.targets.each do |target|
            if target.name == 'MainProject_Tests'
                target.build_configurations.each do |config|
                    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
                end
            end
        end
        aggregate.user_project.save
    end
    ## Fixed read framework library
    ## See: https://juejin.cn/post/7012995777727299591
#    puts install
#    install.pod_targets.each { | pod |
#      if $static_framework.include?(pod.name)
#        def pod.build_type;
#          Pod::BuildType.static_framework # 使用静态库
#        end
#      end
#    }
end
