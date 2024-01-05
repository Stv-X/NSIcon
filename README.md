# NSIcon

NSIcon provides a easy-to-use Mac app icon view for SwiftUI programming, reducing the need for manually storing additional resources by utilizing high-definition assets from the system's native resources.

## Usage

Using NSIcon is as simple as the built-in `Image` view in SwiftUI.
You can get access to almost any app icon installed on your Mac.

```swift
NSIcon() 				 // Use the parameterless initializer if you want to access the icon of your app itself.
NSIcon("Safari") // Get Safari app icon.
NSIcon(bundleIdentifier: "com.apple.safari") // You can also access app icon through the App's Bundle Identifier.
```

When the corresponding icon cannot be provided, NSIcon displays the GenericApplicationIcon that comes with macOS by default.

<p align="center">
<img src="https://github.com/Stv-X/NSIcon/blob/main/Sources/NSIcon/Resources/GenericAppIcon.png" 
alt="GenericApplicationIcon" width="256"/>
</p>


## Installation

NSIcon is available with Swift Package Manager.

```swift
dependencies: [
    .package(url: "https://github.com/Stv-X/NSIcon.git", branch: "main")
]
```
