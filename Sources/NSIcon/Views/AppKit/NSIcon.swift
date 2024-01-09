import SwiftUI

#if os(macOS)
public struct NSIcon: Icon {
    public var appName: String
    public var appBundleIdentifier: String

    public init() {
        self.appName = ""
        self.appBundleIdentifier = ""
    }

    public init(_ appName: String) {
        self.appName = appName
        self.appBundleIdentifier = ""
    }

    public init(bundleIdentifier: String) {
        self.appName = ""
        self.appBundleIdentifier = bundleIdentifier
    }

    @Environment(\.placeholderStyle) var placeholderStyle: NSIconPlaceholderStyle
    @State private var iconImage: NSImage?

    public var body: some View {
        Group {
            if let icon = iconImage {
                Image(nsImage: icon)
                    .iconDefault()
            } else {
                Image(nsImage: placeholderStyle.iconImage)
                    .iconDefault()
            }
        }
        .task { await loadIcon() }
    }

    private func loadIcon() async {
        let vm = NSIconVM(appName: appName, 
                          appBundleIdentifier: appBundleIdentifier)
        iconImage = await vm.loadImage()
    }
}
#endif
