# MPlanet

<p align="left">
<img src="https://raw.githubusercontent.com/yangKJ/MPlanet/master/Screenshot/WX@2x.png" width=75% hspace="15px">
</p>

- 寻音星球是多年以前做的一款[**原型图**](https://org.modao.cc/app/2C7FGGwfYcSUtp8igAKA3BZm79F6SCT)，忘记因为什么原因就被搁置，准备搭建一个纯组件化项目，索性就拿来练手玩玩，分享知识点共同进步学习；
- 原型图链接密码：123

- 老铁们点个星🌟支持一下，有空我就来补充完善！！！

---

### Feats
- 如何使用纯宿主工程，全部采用CocoaPods组件化模块引入；
- 如何制作私有仓库，引入项目以及私有仓库之间单向引用
- 如何使用响应式搭建MVVM项目架构，基础架构[Rickenbacker](https://github.com/yangKJ/Rickenbacker)、网络架构[RxNetworks](https://github.com/yangKJ/RxNetworks)
- 如何快速自动生成组件化模块 [PT](https://github.com/yangKJ/PT)
- 如何使用开屏动画并切换根控制器
- 如何使用组件以及组件之间互相交互处理
- 如何使用组件资源文件，包括图片、多语言、颜色、字体图标等

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

### Rickenbacker基础架构

- 采用RxSwift封装基类，内部包含基类、自动刷新、空数据展示、资源读取几大模块；

```
Ex: 导入项目响应式基类模块
- pod 'Rickenbacker/Adapter'

Ex: 导入组件化模块
- pod 'Rickenbacker/Mediatror'

Ex: 导入导航栏基础模块
- pod 'Rickenbacker/HBDNavigationBar'

Ex: 导入自动刷新模块
- pod 'Rickenbacker/MJRefresh'

Ex: 导入空数据自动展示模块
- pod 'Rickenbacker/DZNEmptyDataSet'
```

### RxNetworks网络架构


