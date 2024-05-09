//
//  ImageX.h
//
//  Copyright (c) 2023 Condy https://github.com/YangKJ
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

// 该组件是一款快速让控件播放GIF和添加滤镜效果的框架，同时也是一款网络图像orGIF显示框架，支持iOS系统和macOS系统。

// 支持多种控件和多种数据源，简单直接使用！！！
// 如果觉得好用，希望您能STAR支持，你的 ⭐️ 是我持续更新的动力!
// 传送门：https://github.com/yangKJ/ImageX/blob/master/README_CN.md <备注：快捷打开浏览器命令，command + 鼠标左键>

// ImageX is a powerful library that quickly allows controls to play gifs and add filters.
// The core is to use CADisplayLink to constantly refresh and update gif frames.
// Support more platform system，macOS、iOS、tvOS、watchOS.
// Support local and network play gifs animated.
// Support asynchronous downloading and caching images or gifs from the web.
// Support network sharing with the same link url, and will not download the same resource data multiple times.
// Support breakpoint continuous transmission and download of network resource data.
// Support any control play gif if used the protocol [AsAnimatable].
// Support extension `NSImageView` or `UIImageView`,`UIButton`,`NSButton`,`WKInterfaceImage` display image or gif and add the filters.
// Support six image or gif content modes.
// Support disk and memory cached network data, And the data is compressed by GZip.
// Support secondary compression of cache data, occupying less disk space.
// Support clean up disk expired data in your spare time and size limit.
// Support setting different types of named encryption methods, Such as md5, sha1, base58, And user defined.
// Support to set the response time of download progress interval.
// Support dynamic display in multiple formats, Such as gif, heic, webp.


// And it is easy to use when summarizing it, so let's add it slowly.
// If you find it easy to use, I hope you can support STAR. Your ⭐️ is my motivation for updating!
// Portal: https://github.com/YangKJ/ImageX <Note: Open the browser command quickly, command + left mouse button>

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double ImageXVersionNumber;

FOUNDATION_EXPORT const unsigned char ImageXVersionString[];
