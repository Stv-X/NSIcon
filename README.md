

<p align="center">
    <img src="https://github.com/Stv-X/NSIcon/assets/30586070/ff00cd60-d6df-4b1d-b9ab-a1069a2ccdf3" 
    alt="NSIcon Framework" width="144"/>
</p>

# NSIcon [![GitHub License](https://img.shields.io/github/license/stv-x/nsicon)](https://raw.githubusercontent.com/Stv-X/NSIcon/master/LICENSE) [![GitHub Release](https://img.shields.io/github/v/release/stv-x/nsicon)](https://github.com/Stv-X/NSIcon/releases/latest) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FStv-X%2FNSIcon%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/Stv-X/NSIcon) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FStv-X%2FNSIcon%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Stv-X/NSIcon)

NSIcon provides a easy-to-use Mac app icon view for SwiftUI programming, reducing the need for manually storing additional resources by utilizing high-definition assets from the system's native resources.

## Overview

### NSIcon
#### Available: macOS 13.0+

Using `NSIcon` is as simple as the built-in `Image` view in SwiftUI.
You can get access to almost any app icon installed on your Mac.

```swift
// Use `init()` if you want to access the icon of your app itself.
NSIcon()

// Get an app icon view by name.
NSIcon("Safari")

// You can also access app icon by its bundle identifier.
NSIcon(bundleIdentifier: "com.apple.safari")
```

If the corresponding icon cannot be provided, NSIcon displays the GenericApplicationIcon that comes with macOS by default.

You can use `iconPlaceholderStyle` modifier to get a different appearance of the placeholder.

```swift
NSIcon("unknown")
    .iconPlaceholderStyle(.classic)
```

![GenericAppIconStyles](https://github.com/Stv-X/NSIcon/assets/30586070/3a151568-b0b5-433b-9662-d3dca5f26290)


### UIIcon
#### Available: iOS 16.0+, iPadOS 16.0+, Mac Catalyst 16.0+, watchOS 9.0+, visionOS 1.0+

Considering the app sandbox environment on these platforms, the icon file assets of other apps are inaccessible, `UIIcon` only provides the ability to access icon of the app itself.

Unlike the behavior of `NSIcon`, `UIIcon` adds mask to the icon by default. Use parameter `addMask: Bool` to control.

On different platforms, the appearance of masks are different.

| Platform |                             iOS                              | iPadOS                                                       |                         Mac Catalyst                         | watchOS | visionOS |
| :------: | :----------------------------------------------------------: | ------------------------------------------------------------ | :----------------------------------------------------------: | :-----: | :------: |
|   Mask   | [AppIconMask](https://github.com/Stv-X/NSIcon/tree/main/Sources/NSIcon/Media.xcassets/AppIconMask.imageset) | [AppIconMask](https://github.com/Stv-X/NSIcon/tree/main/Sources/NSIcon/Media.xcassets/AppIconMask.imageset) | [MacAppIconMask](https://github.com/Stv-X/NSIcon/tree/main/Sources/NSIcon/Media.xcassets/MacAppIconMask.imageset) | Circle  |  Circle  |

```swift
UIIcon()
UIIcon(addMask: false)
```

In visionOS, the app icon consists of three different layers. Use `init()` to render a merged version by default.
You can also use `init(_ layer: AppIconlayer)` or `init(_ layers: [AppIconlayer])` to select which parts of the icon to display.

```swift
UIIcon(.back)
UIIcon([.middle, .front])
```

> Note: `UIIcon` does not support `iconPlaceholderStyle` modifier.

### NSAsyncIcon
#### Available: macOS 13.0+

`NSAsyncIcon` behaves similarly to `NSIcon`, it obtains app icon from the App Store by accessing [iTunes Search API](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI).

```swift
NSAsyncIcon("Pages")
NSAsyncIcon(bundleIdentifier: "com.apple.iwork.pages")
```

When using `appName` as an initialization parameter, you can set your preferences for iOS, macOS, watchOS or visionOS app to decide the results you receive. The default is `.macOS`. 

```swift
NSAsyncIcon("Pages", for: .iOS)
```

iOS app icons and a few of macOS app icons present in a opaque square shape. Therefore, consider whether to add a rounded rectangle mask to it. The default is `false`.

> Note: `NSAsyncIcon` will check if this icon contains transparent pixels. If so, the mask will not be added to the view.

```swift
NSAsyncIcon("Pages", for: .iOS, addMask: true)
```

![NSAsyncIconPreview](https://github.com/Stv-X/NSIcon/assets/30586070/a24cb2b5-e54e-4e28-a1e5-798c5d03cc30)

> Note: The iOS app icons appear slightly larger than Mac app icons, as determined by Apple's [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/app-icons). This framework does not intend to undermine these rules. Please handle it according to your specific use case as needed.

Sometimes, you may want to access certain apps that are only available in specific countries or regions' App Store. You can easily achieve this by inputting a country code.

```swift
NSAsyncIcon("原神", country: "CN")
```

![NSAsyncIconCountryPreview](https://github.com/Stv-X/NSIcon/assets/30586070/b88c6e18-8907-4be5-b855-0584c1d8eaf2)

### UIAsyncIcon
#### Available: iOS 16.0+, iPadOS 16.0+, Mac Catalyst 16.0+, watchOS 9.0+, visionOS 1.0+

`UIAsyncIcon` works almost exactly the same as `NSAsyncIcon`, check the differences below:
1. Add a mask to the icon by default
2. `for platform: AppPlatform` parameter defaults to `.iOS`
3. Support custom placeholder
4. The `placeholderStyle` modifier is not supported

`UIAsyncIcon` uses a `ProgressView()` as the default placeholder, to create a custom placeholder, just add a custom view to the `placeholder` closure.

```swift
UIAsyncIcon("Pages") { CustomPlaceholder() }
```


## Installation

NSIcon is available with Swift Package Manager.

```swift
dependencies: [
    .package(url: "https://github.com/Stv-X/NSIcon.git", branch: "main")
]
```
