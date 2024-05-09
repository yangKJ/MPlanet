# ImageX

<p align="left">
<img src="https://raw.githubusercontent.com/yangKJ/ImageX/master/Images/tutieshi_640x524_1s.gif" width="555" hspace="1px">
</p>

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg?style=flat&colorA=28a745&&colorB=4E4E4E)](https://github.com/yangKJ/ImageX)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/ImageX.svg?style=flat&label=ImageX&colorA=28a745&&colorB=4E4E4E)](https://cocoapods.org/pods/ImageX)
![Platform](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20watchOS-4E4E4E.svg?colorA=28a745)

[**ImageX**](https://github.com/yangKJ/ImageX) is a powerful library that quickly allows controls to play animated images and add filters. The core is to use CADisplayLink to constantly refresh and update animated image frames.

-------

English | [**简体中文**](README_CN.md)

## Features
🧢 At the moment, the most important features of [**GIF Animatable**](https://github.com/yangKJ/ImageX) can be summarized as follows:

- Support more platform system，macOS、iOS、tvOS、watchOS.
- Support display and decode animated image with these formats:  
  webp, heic, gif, apng.
- Support display and decode still image with these formats:  
  jpeg, png, tiff, heif, webp, heic, gif.
- Support directly set an image or animated image from a URL witg these extensions:  
  [NSImageView](https://github.com/yangKJ/ImageX/blob/master/Sources/Extensions/NSImageView%2BExt.swift),  [UIImageView](https://github.com/yangKJ/ImageX/blob/master/Sources/Extensions/UIImageView%2BExt.swift),  [UIButton](https://github.com/yangKJ/ImageX/blob/master/Sources/Extensions/UIButton%2BExt.swift),  [NSButton](https://github.com/yangKJ/ImageX/blob/master/Sources/Extensions/NSButton%2BExt.swift),  [WKInterfaceImage](https://github.com/yangKJ/ImageX/blob/master/Sources/Extensions/WKInterfaceImage%2BExt.swift).
- Support any control play animated image and set filters if used the protocol [AsAnimatable](https://github.com/yangKJ/ImageX/blob/master/Sources/Animated/AsAnimatable.swift).
- Support asynchronous downloading and caching images or Animated from the web.
- Support network sharing with the same url, and will not download the same resource data multiple times.
- Support breakpoint continuous transmission and download of network resource data.
- Support six image or animated image [content modes](https://github.com/yangKJ/ImageX/blob/master/Sources/Base/ResizingMode.swift) .
- Support disk and memory cached network data, And the data is compressed by GZip.
- Support secondary compression of cache data, occupying less disk space.
- Support clean up disk expired data in your spare time and size limit.
- Support setting different types of named encryption methods, Such as md5, sha1, base58, And user defined.
- Support custom decoder/encoder, and also has some decoder/encoder for you to use.

------

## Requirements

| iOS Target | macOS Target | Xcode Version | Swift Version |
|:---:|:---:|:---:|:---:|
| iOS 10.0+ | macOS 10.13+ | Xcode 10.0+ | Swift 5.0+ |

## Support the Project
Buy me a coffee or support me on [GitHub](https://github.com/sponsors/yangKJ?frequency=one-time&sponsor=yangKJ).

<a href="https://www.buymeacoffee.com/yangkj3102">
<img width=25% alt="yellow-button" src="https://user-images.githubusercontent.com/1888355/146226808-eb2e9ee0-c6bd-44a2-a330-3bbc8a6244cf.png">
</a>

------

## Usage

- `NSImageView` or `UIImageView` display network image or animated image and add the filters.

```swift
// Set image from a url.
let url = URL(string: "https://example.com/image.png")!
imageView.kj.setImage(with: url)
```

- Or set other parameters play animated image or downloading image.

```swift
var options = ImageXOptions(moduleName: "Component Name")
options.placeholder = .image(R.image("AppIcon")!)
options.resizingMode = .scaleAspectBottomRight
options.Animated.loop = .count(3)
options.Animated.bufferCount = 20
options.Cache.cacheOption = .disk
options.Cache.cacheCrypto = .md5
options.Cache.cacheDataZip = .gzip
options.Network.retry = .max3s
options.Network.timeoutInterval = 30
options.Animated.setPreparationBlock(block: { [weak self] _ in
    // do something..
})
options.Animated.setAnimatedBlock(block: { _ in
    // play is complete and then do something..
})
options.Network.setNetworkProgress(block: { _ in
    // download progress..
})
options.Network.setNetworkFailed(block: { _ in
    // download failed.
})

let links = [``GIF URL``, ``Image URL``, ``GIF Named``, ``Image Named``]
let named = links.randomElement() ?? ""

// Setup filters.
let filters: [C7FilterProtocol] = [
    C7SoulOut(soul: 0.75),
    C7Storyboard(ranks: 2),
]
imageView.kj.setImage(with: named, filters: filters, options: options)
```

----------------------------------------------------------------
😘😘 And other methods:

```swift
/// Display image or animated image and add the filters.
/// - Parameters:
///   - named: Picture or gif name.
///   - filters: Harbeth filters apply to image or gif frame.
///   - options: Represents creating options used in ImageX.
public func setImage(with named: String, filters: [C7FilterProtocol], options: ImageXOptions = ImageXOptions.default)

/// Display image or animated image and add the filters.
/// - Parameters:
///   - data: Picture data.
///   - filters: Harbeth filters apply to image or gif frame.
///   - options: Represents creating options used in ImageX.
/// - Returns: A uniform type identifier UTI.
public func setImage(with data: Data?, filters: [C7FilterProtocol], options: ImageXOptions = .default) -> AssetType

/// Display network image or animated image and add the filters.
/// - Parameters:
///   - url: Link url.
///   - filters: Harbeth filters apply to image or gif frame.
///   - options: Represents gif playback creating options used in ImageX.
/// - Returns: Current network URLSessionDataTask.
public func setImage(with url: URL?, filters: [C7FilterProtocol], options: ImageXOptions = .default) -> Task?
```

- Any control can play the local animated image data.

```swift
let filters: [C7FilterProtocol] = [ ``Harbeth Filter`` ]
let data = R.gifData(``GIF Name``)
var options = ImageXOptions()
options.Animated.loop = .count(5)
options.placeholder = .color(.cyan)
animatedView.play(data: data, filters: filters, options: options)
```

- Any control implementation protocol ``AsAnimatable`` can support animated image playback.

```swift
class AnimatedView: UIView, AsAnimatable {
    ...
}
```

**GIF animated support has been implemented here for [**ImageView**](https://github.com/yangKJ/ImageX/blob/master/Sources/Extensions/UIImageView%2BExt.swift) , so you can use it directly.✌️**

### ResizingMode

- Mainly for the image filling content to change the size.

Example | ResizingMode
---- | ---------
![original](https://raw.githubusercontent.com/yangKJ/ImageX/master/Images/original.png)|**original**<br/>Dimensions of the original image. Do nothing with it.<br/><br/>`options.resizingMode = .original`
![scaleToFill](https://raw.githubusercontent.com/yangKJ/ImageX/master/Images/scaleToFill.png)|**scaleToFill**<br/>The option to scale the content to fit the size of itself by changing the aspect ratio of the content if necessary.<br/><br/>`options.resizingMode = .scaleToFill`
![scaleAspectFit](https://raw.githubusercontent.com/yangKJ/ImageX/master/Images/scaleAspectFit.png)|**scaleAspectFit**<br/>Contents scaled to fit with fixed aspect. remainder is transparent.<br/><br/>`options.resizingMode = .scaleAspectFit`
![scaleAspectFill](https://raw.githubusercontent.com/yangKJ/ImageX/master/Images/scaleAspectFill.png)|**scaleAspectFill**<br/>Contents scaled to fill with fixed aspect. some portion of content may be clipped.<br/><br/>`options.resizingMode = .scaleAspectFill`
![scaleAspectBottomRight](https://raw.githubusercontent.com/yangKJ/ImageX/master/Images/scaleAspectBottomRight.png)|**scaleAspectBottomRight**<br/>Contents scaled to fill with fixed aspect. top or left portion of content may be clipped.<br/><br/>`options.resizingMode = .scaleAspectBottomRight`
![scaleAspectTopLeft](https://raw.githubusercontent.com/yangKJ/ImageX/master/Images/scaleAspectTopLeft.png)|**scaleAspectTopLeft**<br/>Contents scaled to fill with fixed aspect. bottom or right portion of content may be clipped.<br/><br/>`options.resizingMode = .scaleAspectTopLeft`

### ImageXOptions

- Other parameters related to Animated playback and downloading and caching.
- Represents gif playback creating options used in ImageX.

```swift
public struct ImageXOptions {
    
    public static var `default` = ImageXOptions()
    
    /// Additional parameters that need to be set to play animated images.
    public var Animated: ImageXOptions.Animated = ImageXOptions.Animated.init()
    
    /// Download additional parameters that need to be configured to download network resources.
    public var Network: ImageXOptions.Network = ImageXOptions.Network.init()
    
    /// Caching data from the web need to be configured parameters.
    public var Cache: ImageXOptions.Cache = ImageXOptions.Cache.init()
    
    /// Appoint the decode or encode coder.
    public var appointCoder: ImageCodering?
    
    /// Placeholder image. default gray picture.
    public var placeholder: ImageX.Placeholder = .none
    
    /// Content mode used for resizing the frame image.
    /// When this property is `original`, modifying the thumbnail pixel size will not work.
    public var resizingMode: ImageX.ResizingMode = .original
    
    /// Whether or not to generate the thumbnail images.
    /// Defaults to CGSizeZero, Then take the size of the displayed control size as the thumbnail pixel size.
    public var thumbnailPixelSize: CGSize = .zero
    
    /// 做组件化操作时刻，解决本地GIF或本地图片所处于另外模块从而读不出数据问题。😤
    /// Do the component operation to solve the problem that the local GIF or Image cannot read the data in another module.
    public let moduleName: String
    
    /// Instantiation of configuration parameters.
    /// - Parameters:
    ///   - moduleName: Do the component operation to solve the problem that the local GIF or image cannot read the data in another module.
    public init(moduleName: String = "ImageX") {
        self.moduleName = moduleName
    }
}
```

### AsAnimatable

- The protocol that view classes need to conform to to enable animated image support at [AsAnimatable](https://github.com/yangKJ/ImageX/blob/master/Sources/Animated/AsAnimatable.swift).

### Cached

- For the use of caching modules, please refer to [CacheX](https://github.com/yangKJ/CacheX) for more information.
- Network data caching type. There are two modes: memory and disk storage.
- Among them, the disk storage uses GZip to compress data, so it will occupy less space.
- Support setting different types of named encryption methods, such as md5, sha1, base58, And user defined.
- Considering different degrees of security, the data source compression and decompression method is opened here. The library provides [GZip](https://github.com/yangKJ/ImageX/blob/master/Sources/Base/Zip.swift) compression or decompression. Of course, users can also customize it.

### Codering

Has the following coder:    
- [ImageIOCoder](https://github.com/yangKJ/ImageX/blob/master/Sources/Coder/ImageIOCoder.swift): Static universal image decoder/encoder, support still image format.
- [ImageJPEGCoder](https://github.com/yangKJ/ImageX/blob/master/Sources/Coder/ImageJPEGCoder.swift): Static jpeg image decoder/encoder. 
- [AnimatedAPNGCoder](https://github.com/yangKJ/ImageX/blob/master/Sources/Coder/AnimatedAPNGCoder.swift): Animated png image decoder/encoder.
- [AnimatedGIFsCoder](https://github.com/yangKJ/ImageX/blob/master/Sources/Coder/AnimatedGIFsCoder.swift): Animated gif image decoder/encoder.
- [AnimatedHEICCoder](https://github.com/yangKJ/ImageX/blob/master/Sources/Coder/AnimatedHEICCoder.swift): Animated heic image decoder/encoder.
- [AnimatedWebPCoder](https://github.com/yangKJ/ImageX/blob/master/Sources/Coder/AnimatedWebPCoder.swift): Animated webp image decoder/encoder.

Use: 

```
var options = ImageXOptions()
options.appointCoder = AnimatedAPNGCoder()
```
If no decoder/encoder is specified, the corresponding decoder/encoder will be automatically selected.

## Installation

**CocoaPods**

```ruby
pod 'ImageX'
```

**Swift Package Manager**

```swift
dependencies: [
    .package(url: "https://github.com/yangKJ/ImageX.git", branch: "master"),
]
```

## Contact
- 🎷 **E-mail address: [yangkj310@gmail.com](yangkj310@gmail.com) 🎷**
- 🎸 **GitHub address: [yangKJ](https://github.com/yangKJ) 🎸**

-----

## License
ImageX is available under the [MIT](LICENSE) license. See the [LICENSE](LICENSE) file for more info.

-----
