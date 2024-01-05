# NSIcon

<p align="center">
    <img src="https://github.com/Stv-X/NSIcon/blob/main/Sources/NSIcon/Resources/NSIconFramework.png" 
    alt="GenericApplicationIcon" width="144"/>
</p>
<p align="center">
    <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FStv-X%2FNSICon%2Fbadge%3Ftype%3Dswift-versions">
    <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FStv-X%2FNSICon%2Fbadge%3Ftype%3Dplatforms">
</p>

NSIcon provides a easy-to-use Mac app icon view for SwiftUI programming, reducing the need for manually storing additional resources by utilizing high-definition assets from the system's native resources.

## Overview

### NSIcon
Using `NSIcon` is as simple as the built-in `Image` view in SwiftUI.
You can get access to almost any app icon installed on your Mac.

```swift
NSIcon() // Use the parameterless initializer if you want to access the icon of your app itself.
NSIcon("Safari") // Get Safari app icon.
NSIcon(bundleIdentifier: "com.apple.safari") // You can also access app icon through the App's Bundle Identifier.
```

If the corresponding icon cannot be provided, NSIcon displays the GenericApplicationIcon that comes with macOS by default.

<p align="center">
<img src="https://github.com/Stv-X/NSIcon/blob/main/Sources/NSIcon/Resources/GenericAppIcon.png" 
alt="GenericApplicationIcon" width="128"/>
</p>

### NSAsyncIcon
`NSAsyncIcon` behaves similarly to `NSIcon`, it obtains app icon from the App Store by accessing [iTunes Search API](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI).

```swift
NSAsyncIcon("Pages")
NSAsyncIcon(bundleIdentifier: "com.apple.iwork.pages")
```

When using `appName` as an initialization parameter, you can set your preferences for iOS app or macOS app to decide the results you receive. The default is `.macOS`. 

```swift
NSAsyncIcon("Pages", for: .iOS)
```

iOS app icons and a few of macOS app icons present in a opaque square shape. Therefore, consider whether to add a rounded rectangle mask to it. The default is `false`.

```swift
NSAsyncIcon("Pages", for: .iOS, addMask: true)
```

> Note: The iOS app icons appear slightly larger than Mac app icons, as determined by Apple's [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/app-icons). This framework does not intend to undermine these rules. Please handle it according to your specific use case as needed.

Sometimes, you may want to access certain apps that are only available in specific countries or regions' App Store. You can easily achieve this by inputting a country code.

```swift
NSAsyncIcon("原神", country: "CN")
```

## Installation

NSIcon is available with Swift Package Manager.

```swift
dependencies: [
    .package(url: "https://github.com/Stv-X/NSIcon.git", branch: "main")
]
```
