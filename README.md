# MPlanet

<p align="left">
<img src="https://raw.githubusercontent.com/yangKJ/MPlanet/master/Screenshot/WX@2x.png" width=75% hspace="15px">
</p>

- 寻音星球是多年以前做的一款[**原型图**](https://org.modao.cc/app/2C7FGGwfYcSUtp8igAKA3BZm79F6SCT)，忘记因为什么原因就被搁置，准备搭建一个纯组件化项目，索性就拿来练手玩玩，分享知识点共同进步学习。
- 原型图链接密码：123

- 老铁们点个星🌟支持一下，有空我就来补充完善！！！
- 仅开源供大家学习使用，禁止从事商业活动，如出现一切法律问题自行承担。

---

### Feats
- 如何使用纯宿主工程，全部采用CocoaPods组件化模块引入；
- 如何制作私有仓库，引入项目以及私有仓库之间单向引用；
- 如何使用组件以及组件之间互相交互处理；
- 如何使用组件资源文件，包括图片、多语言、颜色、字体图标等；
- 如何使用响应式搭建MVVM项目架构，基础架构 [Rickenbacker](https://github.com/yangKJ/Rickenbacker)，包括自动刷新、空视图等；
- 如何搭建网络架构 [RxNetworks](https://github.com/yangKJ/RxNetworks)，包括处理链式和批量网络请求等；
- 如何使用插件实现网络请求，包括数据缓存、密钥验证、动画加载、压缩、共享、下载等插件；
- 如何快速自动生成组件化模块 [PT](https://github.com/yangKJ/PT)，单元测试等；
- 如何对AppDelegate瘦身分类处理，例如根控制器管理、悼念模式等；
- 如何使用开屏动画并切换根控制器；
- 如何使用RxSwift实现数据驱动视图，数据双向绑定，以及RxSwift高级用法等；
- 如何使用Swift部分高级用法，例如属性包装器、范型协议、前缀命名空间、下标语法、操作符等；
- 如何使用滤镜 [Harbeth](https://github.com/yangKJ/Harbeth)，代码零侵入处理图像和视频等；
- 如何使用图像框架 [ImageX](https://github.com/yangKJ/ImageX)，快速实现网图和本地图GIF混播，以及加入滤镜；
- 如何使用微信开源的数据库 [WCDB](https://github.com/Tencent/wcdb)，加密增删改查等；
- 如何使用 [RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources)，列表数据源绑定等；

### MVVM架构设计
- 下面介绍如何搭建MVVM响应式组件化架构

<p align="left">
<img src="https://img-blog.csdnimg.cn/20191031141318529.png" width=85% hspace="15px">
</p>

MVVM 支持出色的开发人员 - 设计人员工作流程，提供以下优势：

- 在开发过程中，开发人员和设计人员可以在他们的组件上更加独立和并发地工作。
	- 设计人员可以专注于视图，可以轻松生成示例数据以进行处理。
	- 开发人员可以处理视图模型和模型组件。
- 开发人员可以在不使用视图的情况下为视图模型和模型创建单元测试。视图模型的单元测试可以执行与视图使用的完全相同的功能。
- 无需接触代码即可轻松重新设计应用程序的 UI，因为视图完全在 XAML 中实现。新版本的视图应该与现有的视图模型一起使用。
- 如果存在封装现有业务逻辑的模型的现有实现，则更改可能很困难或有风险。在这种情况下，视图模型充当模型类的适配器，使您能够避免对模型代码进行任何重大更改。

### 组件化

- 设计组件化中间层有两种比较有代表性的方案：
  - 基于URL注册跳转的方式，参考蘑菇街开源 [MGJRouter](https://github.com/lyujunwei/MGJRouter)
  - 基于Objective-C运行时的Mediator方式，参考 [CTMediator](https://github.com/casatwy/CTMediator)

- 简单谈谈二者优势区别：
  - URL注册的方式在使用上非常繁琐而且很多时候其实没有必要。首先每一个页面跳转都需要事先注册好URL，这里会牵涉到非常多字符串硬编码。
  - 基于runtime的Mediator方式，首先它不需要注册，省去了很多比对字符串的过程，其次它可以非常容易的传递各种参数来进行组建间通信。

### Rickenbacker基础架构

- 采用RxSwift封装基类，内部包含基类、自动刷新、空数据展示、资源读取几大模块；

```ruby
Ex: 导入项目响应式基类模块
- pod 'Rickenbacker/Adapter'

Ex: 导入组件化模块
- pod 'Rickenbacker/Mediatror'

Ex: 导入自动刷新模块
- pod 'Rickenbacker/MJRefresh'

Ex: 导入空数据自动展示模块
- pod 'Rickenbacker/DZNEmptyDataSet'
```

### RxNetworks网络架构

基于 **RxSwift + Moya** 搭建响应式数据绑定网络API架构

- 提供网络数据解析HandyJSON并支持RxSwift封装；
- 目前已封装10款插件供您使用：
    - [Cache](https://github.com/yangKJ/RxNetworks/blob/master/Plugins/Cache/NetworkCachePlugin.swift)：网络数据缓存插件
    - [Loading](https://github.com/yangKJ/RxNetworks/blob/master/Plugins/Loading/NetworkLoadingPlugin.swift)：加载动画插件
    - [Indicator](https://github.com/yangKJ/RxNetworks/blob/master/Plugins/Indicator/NetworkIndicatorPlugin.swift)：指示器插件
    - [Warning](https://github.com/yangKJ/RxNetworks/blob/master/Plugins/Warning/NetworkWarningPlugin.swift)：网络失败提示插件
    - [Debugging](https://github.com/yangKJ/RxNetworks/blob/master/Plugins/Debugging/NetworkDebuggingPlugin.swift): 网络打印，内置插件
    - [GZip](https://github.com/yangKJ/RxNetworks/blob/master/Sources/GZip/NetworkGZipPlugin.swift): 解压缩插件
    - [Shared](https://github.com/yangKJ/RxNetworks/blob/master/Sources/Shared/NetworkSharedPlugin.swift): 网络共享插件
    - [Lottie](https://github.com/yangKJ/RxNetworks/blob/master/Plugins/Lottie/AnimatedLoadingPlugin.swift): 基于lottie动画加载插件
    - [Header](https://github.com/yangKJ/RxNetworks/blob/master/Plugins/Header/NetworkHttpHeaderPlugin.swift): 网络HTTP头插件
    - [Files](https://github.com/yangKJ/RxNetworks/blob/master/Plugins/Files/NetworkFilesPlugin.swift): 网络下载文件和上传资源插件

### Harbeth滤镜框架

基于GPU快速实现图片or视频注入滤镜特效，代码零侵入实现图像显示and视频导出功能；

- 支持macOS和iOS平台系统，也支持SwiftUI使用；
- 高性能在如下数据源快速添加过滤器效果：  
  UIImage, NSImage, CIImage, CGImage, CMSampleBuffer, CVPixelBuffer
- 支持两种查找滤镜 [LUTs](https://github.com/yangKJ/Harbeth/tree/master/Sources/Compute/Lookup/C7LookupTable.swift) 和 [Cube](https://github.com/yangKJ/Harbeth/tree/master/Sources/CoreImage/CIColorCube.swift) 来定制专属滤镜；
- 支持相机采集特效和视频播放加入滤镜效果；
- Metal滤镜部分大致分为以下几个模块：  
  [Blend](https://github.com/yangKJ/Harbeth/tree/master/Sources/Compute/Blend), [Blur](https://github.com/yangKJ/Harbeth/tree/master/Sources/Compute/Blur), [Pixel](https://github.com/yangKJ/Harbeth/tree/master/Sources/Compute/Pixel), [Coordinate](https://github.com/yangKJ/Harbeth/tree/master/Sources/Compute/Coordinate), [Lookup](https://github.com/yangKJ/Harbeth/tree/master/Sources/Compute/Lookup), [Matrix](https://github.com/yangKJ/Harbeth/tree/master/Sources/Compute/Matrix), [Shape](https://github.com/yangKJ/Harbeth/tree/master/Sources/Compute/Shape), [Generator](https://github.com/yangKJ/Harbeth/tree/master/Sources/Compute/Generator).
- 支持使用 [Kakapos](https://github.com/yangKJ/Kakapos) 库对已有视频添加滤镜并导出；
- 支持系统 MetalPerformanceShaders 和 CoreImage 滤镜混合使用；

### ImageX图像框架

快速让控件播放GIF和添加滤镜的框架，核心其实就是使用CADisplayLink不断刷新和更新GIF帧图。

- 支持播放本地和网络GIF动图；
- 支持同链接地址网络共享，不会多次下载同一资源数据；
- 支持 [**NSImageView 或 UIImageView**](https://github.com/yangKJ/ImageX/blob/master/Sources/Extensions/UIImageView+Ext.swift) 显示网络图像或GIF并添加 [**Harbeth**](https://github.com/yangKJ/Harbeth) 滤镜；
- 支持 [**UIButton 或 NSButton**](https://github.com/yangKJ/ImageX/blob/master/Sources/Extensions/UIButton+Ext.swift) 显示和下载图像并添加滤镜；
- 支持任何控件并使用协议 [**AsAnimatable**](https://github.com/yangKJ/ImageX/blob/master/Sources/Animated/AsAnimatable.swift) 即可快速达到支持播放GIF功能；
- 支持六种 [**ContentMode**](https://github.com/yangKJ/ImageX/blob/master/Sources/Base/ResizingMode.swift) 图片或GIF内容填充模式；
- 支持缓存 [**Cached**](https://github.com/yangKJ/ImageX/blob/master/Sources/Cache/Cached.swift) 网络图片或GIF数据，指定时间空闲时刻清理过期数据；
- 支持磁盘和内存缓存网络数据，提供多种命名加密 [**Crypto**](https://github.com/yangKJ/ImageX/blob/master/Sources/Base/CryptoType.swift) 方式；
- 支持缓存数据再次压缩，占用更小的磁盘空间，例如 [**GZip**](https://github.com/yangKJ/ImageX/blob/master/Sources/Base/Zip.swift) 压缩方式；
- 支持断点续传下载网络资源数据，支持设置下载进度间隔响应时间；
