# NSIcon

<p align="center">
    <img src="https://github.com/Stv-X/NSIcon/assets/30586070/ff00cd60-d6df-4b1d-b9ab-a1069a2ccdf3" 
    alt="NSIcon Framework" width="144"/>
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
// Use the parameterless initializer if you want to access the icon of your app itself.
NSIcon()

// Get an app icon view by name.
NSIcon("Safari")

// You can also access app icon by its bundle identifier.
NSIcon(bundleIdentifier: "com.apple.safari")
```

If the corresponding icon cannot be provided, NSIcon displays the GenericApplicationIcon that comes with macOS by default.

<p align="center">
<img src="https://github.com/Stv-X/NSIcon/assets/30586070/de3a0c5c-8517-4887-9d65-04335d53c812" 
alt="GenericApplicationIcon" width="128"/>
</p>

You can use `iconPlaceholderStyle` modifier to get a different appearance of the placeholder.

```swift
NSIcon("unknown")
    .iconPlaceholderStyle(.classic)
```

<p align="center">
<img src="https://github.com/Stv-X/NSIcon/assets/30586070/56374d34-cd6b-48fc-9b1f-c005be6dea3d" 
alt="GenericApplicationIconClassic" width="128"/>
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

![NSAsyncIconPreview](https://github.com/Stv-X/NSIcon/assets/30586070/a24cb2b5-e54e-4e28-a1e5-798c5d03cc30)

> Note: The iOS app icons appear slightly larger than Mac app icons, as determined by Apple's [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/app-icons). This framework does not intend to undermine these rules. Please handle it according to your specific use case as needed.

Sometimes, you may want to access certain apps that are only available in specific countries or regions' App Store. You can easily achieve this by inputting a country code.

```swift
NSAsyncIcon("原神", country: "CN")
```

![NSAsyncIconCountryPreview](https://github.com/Stv-X/NSIcon/assets/30586070/b88c6e18-8907-4be5-b855-0584c1d8eaf2)

## Installation

NSIcon is available with Swift Package Manager.

```swift
dependencies: [
    .package(url: "https://github.com/Stv-X/NSIcon.git", branch: "main")
]
```
