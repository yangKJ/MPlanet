# Wintersweet

<p align="left">
<img src="https://raw.githubusercontent.com/yangKJ/Wintersweet/master/Images/tutieshi_640x524_1s.gif" width="555" hspace="1px">
</p>

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg?style=flat&colorA=28a745&&colorB=4E4E4E)](https://github.com/yangKJ/Wintersweet)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Wintersweet.svg?style=flat&label=Wintersweet&colorA=28a745&&colorB=4E4E4E)](https://cocoapods.org/pods/Wintersweet)
![Platform](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20watchOS-4E4E4E.svg?colorA=28a745)

[**Wintersweet**](https://github.com/yangKJ/Wintersweet) is a powerful library that quickly allows controls to play gifs and add filters. The core is to use CADisplayLink to constantly refresh and update gif frames.

-------

English | [**简体中文**](README_CN.md)

## Features
🧢 At the moment, the most important features of [**GIF Animatable**](https://github.com/yangKJ/Wintersweet) can be summarized as follows:

- Support more platform system，macOS、iOS、tvOS、watchOS.
- Support local and network play gif animated.
- Support asynchronous image or gif displaying and caching.
- Support any control play gif if used the protocol [AsAnimatable](https://github.com/yangKJ/Wintersweet/blob/master/Sources/AsAnimatable.swift).
- Support extension `NSImageView` or `UIImageView` display image or gif and add the filters.
- Support six image or gif content modes.
- Support disk and memory cached network data, And the data is compressed by GZip.
- Support clean up disk expired data in your spare time.
- Support setting different types of named encryption methods, Such as md5, sha1, base58, And user defined.

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

- `NSImageView` or `UIImageView` display network image or gif and add the filters.

```swift
let links = [``GIF Link URL``, ``Picture Link URL``, ``GIF Named``, ``Image Named``]
let named = links.randomElement() ?? ""
let options = AnimatedOptions(
    loop: .count(3),
    placeholder: .image(R.image("IMG_0020")!),
    contentMode: .scaleAspectBottomRight,
    bufferCount: 20,
    cacheOption: .disk,
    cacheCrypto: .user { "Condy" + CryptoType.SHA.sha1(string: $0) },
    cacheDataZip: .gzip,
    preparation: {
        // do something..
    }, animated: { _ in
        // play is complete and then do something..
    })
imageView.mt.displayImage(named: named, filters: filters, options: options)
```

----------------------------------------------------------------
😘😘 And other methods:

```
/// Display image or gif and add the filters.
/// - Parameters:
///   - named: Picture or gif name.
///   - filters: Harbeth filters apply to image or gif frame.
///   - options: Represents gif playback creating options used in Wintersweet.
public func displayImage(
    named: String, 
    filters: [C7FilterProtocol], 
    options: AnimatedOptions = .default
)

/// Display image or gif and add the filters.
/// - Parameters:
///   - data: Picture data.
///   - filters: Harbeth filters apply to image or gif frame.
///   - options: Represents gif playback creating options used in Wintersweet.
/// - Returns: A uniform type identifier UTI.
public func displayImage(
    data: Data?, 
    filters: [C7FilterProtocol], 
    options: AnimatedOptions = .default
) -> AssetType

/// Display network image or gif and add the filters.
/// - Parameters:
///   - url: Link url.
///   - filters: Harbeth filters apply to image or gif frame.
///   - options: Represents gif playback creating options used in Wintersweet.
///   - failed: Network failure callback.
/// - Returns: Current network URLSessionDataTask.
public func displayImage(
    url: URL, 
    filters: [C7FilterProtocol], 
    options: AnimatedOptions = .default, 
    failed: FailedCallback? = nil
) -> URLSessionDataTask?
```

- Any control can play the local gif data.

```swift
let filters: [C7FilterProtocol] = [ ``Harbeth Filter`` ]
let data = R.gifData(``GIF Name``)
let options = AnimatedOptions(loop: .count(5), placeholder: .color(.cyan))
animatedView.play(data: data, filters: filters, options: options)
```

- Any control implementation protocol ``AsAnimatable`` can support gif animated playback.

```swift
class GIFView: UIView, AsAnimatable {
    ...
}
```

**GIF animated support has been implemented here for [ImageView](https://github.com/yangKJ/Wintersweet/blob/master/Sources/Extensions/ImageView%2BExt.swift), so you can use it directly.✌️**

### ContentMode

- Mainly for the image filling content to change the size.

Example | ContentMode
---- | ---------
![original](https://raw.githubusercontent.com/yangKJ/Wintersweet/master/Images/original.png)|**original**<br/>Dimensions of the original image. Do nothing with it.<br/><br/>`AnimatedOptions(contentMode: .original)`
![scaleToFill](https://raw.githubusercontent.com/yangKJ/Wintersweet/master/Images/scaleToFill.png)|**scaleToFill**<br/>The option to scale the content to fit the size of itself by changing the aspect ratio of the content if necessary.<br/><br/>`AnimatedOptions(contentMode: .scaleToFill)`
![scaleAspectFit](https://raw.githubusercontent.com/yangKJ/Wintersweet/master/Images/scaleAspectFit.png)|**scaleAspectFit**<br/>Contents scaled to fit with fixed aspect. remainder is transparent.<br/><br/>`AnimatedOptions(contentMode: .scaleAspectFit)`
![scaleAspectFill](https://raw.githubusercontent.com/yangKJ/Wintersweet/master/Images/scaleAspectFill.png)|**scaleAspectFill**<br/>Contents scaled to fill with fixed aspect. some portion of content may be clipped.<br/><br/>`AnimatedOptions(contentMode: .scaleAspectFill)`
![scaleAspectBottomRight](https://raw.githubusercontent.com/yangKJ/Wintersweet/master/Images/scaleAspectBottomRight.png)|**scaleAspectBottomRight**<br/>Contents scaled to fill with fixed aspect. top or left portion of content may be clipped.<br/><br/>`AnimatedOptions(contentMode: .scaleAspectBottomRight)`
![scaleAspectTopLeft](https://raw.githubusercontent.com/yangKJ/Wintersweet/master/Images/scaleAspectTopLeft.png)|**scaleAspectTopLeft**<br/>Contents scaled to fill with fixed aspect. bottom or right portion of content may be clipped.<br/><br/>`AnimatedOptions(contentMode: .scaleAspectTopLeft)`

### AnimatedOptions

- Other parameters related to GIF playback.
- Represents gif playback creating options used in Wintersweet.

```swift
public struct AnimatedOptions {
    
    public static let `default` = AnimatedOptions()
    
    /// Desired number of loops. Default  is ``forever``.
    public let loop: Wintersweet.Loop
    
    /// Content mode used for resizing the frames. Default is ``original``.
    public let contentMode: Wintersweet.ContentMode
    
    /// The number of frames to buffer. Default is 50.
    public let bufferCount: Int
    
    /// Weather or not we should cache the URL response. Default is ``all``.
    public let cacheOption: Wintersweet.Cached.Options
    
    /// Placeholder image. default gray picture.
    public let placeholder: Wintersweet.Placeholder
    
    /// Network data cache naming encryption method, Default is ``md5``.
    public let cacheCrypto: Wintersweet.CryptoType
    
    /// Network data compression or decompression method, default ``gzip``.
    /// This operation is done in the subthread.
    public let cacheDataZip: Wintersweet.ZipType
}
```

### AsAnimatable

- The protocol that view classes need to conform to to enable gif animated support.

```swift
public protocol AsAnimatable: HasAnimatable {
    
    /// Total duration of one animation loop.
    var loopDuration: TimeInterval { get }
    
    /// The first frame that is not nil of GIF.
    var fristFrame: C7Image? { get }
    
    /// Returns the active frame if available.
    var activeFrame: C7Image? { get }
    
    /// Total frame count of the GIF.
    var frameCount: Int { get }
    
    /// Introspect whether the instance is animating.
    var isAnimatingGIF: Bool { get }
    
    /// Bitmap memory cost with bytes.
    var costGIF: Int { get }
    
    /// Stop animating and free up GIF data from memory.
    func prepareForReuseGIF()
    
    /// Start animating GIF.
    func startAnimatingGIF()
    
    /// Stop animating GIF.
    func stopAnimatingGIF()
    
    /// Prepare for animation and start play GIF.
    /// - Parameters:
    ///   - data: gif data.
    ///   - filters: Harbeth filters apply to image or gif frame.
    ///   - options: Represents gif playback creating options used in Wintersweet.
    func play(data: Data?, filters: [C7FilterProtocol], options: AnimatedOptions)
}
```

#### Placeholder

- Represent a placeholder type which could be set while loading as well as loading finished without getting an image.

```swift
public enum Placeholder {
    /// Do not use any placeholder.
    case none
    /// Use solid color image as placeholder.
    case color(C7Color)
    /// Use image as placeholder.
    case image(C7Image)
    /// Use a custom view as placeholder.
    case view(View)
}
```

### Cached

- Network data caching type. There are two modes: memory and disk storage.
- Among them, the disk storage uses GZip to compress data, so it will occupy less space.

```
/// Do not use any cache.
public static let none = Options(rawValue: 1 << 0)
/// Cache the data in memory.
public static let memory = Options(rawValue: 1 << 1)
/// Cache the data in disk, Use ``GZip`` to compress data.
public static let disk = Options(rawValue: 1 << 2)
/// Use memory and disk cache at the same time to read memory first.
public static let all: Options = [.memory, .disk]
```

- Support setting different types of named encryption methods, such as md5, sha1, base58, And user defined.

```
public enum Crypto {
    case md5
    case sha1
    case base58
    case user(CryptoUserType)
}
```

- Considering different degrees of security, the data source compression and decompression method is opened here. The library provides [GZip](https://github.com/yangKJ/Wintersweet/blob/master/Sources/Core/GZip.swift) compression or decompression. Of course, users can also customize it.

```
public enum ZipType {
    /// There is no processing for Data.
    case none
    /// Use GZip to compress or decompress data.
    case gzip
    /// User defined compression and decompression methods.
    case user(compressed: ZipUserType, decompress: ZipUserType)
}
```

### Loop

- Gif animated played count.

```
public enum Loop {
    /// Incessant cycle.
    case forever
    /// Play it once.
    case never
    /// Loop the specified ``count`` times.
    case count(_ count: Int)
    /// Displayed the first frame.
    case fristFrame
    /// Displayed the last frame.
    case lastFrame
}
```

## Installation

**CocoaPods**

```ruby
pod 'Wintersweet'
```

**Swift Package Manager**

```swift
dependencies: [
    .package(url: "https://github.com/yangKJ/Wintersweet.git", branch: "master"),
]
```

## Contact
- 🎷 **E-mail address: [yangkj310@gmail.com](yangkj310@gmail.com) 🎷**
- 🎸 **GitHub address: [yangKJ](https://github.com/yangKJ) 🎸**

-----

## License
Wintersweet is available under the [MIT](LICENSE) license. See the [LICENSE](LICENSE) file for more info.

-----
