# NSIcon

![logo](https://github.com/Stv-X/NSIcon/blob/main/Sources/NSIcon/Resources/NSIconFramework.png)

NSIcon provides a easy-to-use Mac app icon view for SwiftUI programming, reducing the need for manually storing additional resources by utilizing high-definition assets from the system's native resources.

## Usage

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
alt="GenericApplicationIcon" width="256"/>
</p>

### NSAsyncIcon
`NSAsyncIcon` behaves similarly to `NSIcon`, it obtains app icon from the App Store by accessing [iTunes Search API](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI).

```swift
NSAsyncIcon("Pages")
NSAsyncIcon(bundleIdentifier: "com.apple.iwork.Pages")
```


When using `appName` as an initialization parameter, there's a high probability of obtaining icon from an iOS app, presented in a opaque square shape. Therefore, consider whether to add a rounded rectangle mask to it with the mask material sourced from apps.apple.com.. The default is `true`.

```swift
NSAsyncIcon("Pages", addMask: false)
```

> Note: The iOS app icons appear slightly larger compared to Mac app icons, as determined by Apple's Human Interface Guidelines. This framework does not intend to provide a solution for this; therefore, please handle it according to your specific use case as needed.

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
