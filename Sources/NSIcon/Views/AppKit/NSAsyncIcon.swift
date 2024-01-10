import SwiftUI

#if os(macOS)
public struct NSAsyncIcon: Icon {
    public var appName: String
    public var appBundleIdentifier: String
    var platform: AppPlatform
    var country: String
    var addMask: Bool

    public init(
        _ appName: String,
        for platform: AppPlatform = .macOS,
        country: String = "",
        addMask: Bool = false
    ) {
        self.appName = appName
        self.platform = platform
        self.country = country
        self.addMask = addMask
        self.appBundleIdentifier = ""
    }

    public init(
        bundleIdentifier: String,
        addMask: Bool = false
    ) {
        self.appName = ""
        self.platform = .macOS
        self.country = ""
        self.addMask = addMask
        self.appBundleIdentifier = bundleIdentifier
    }

    @Environment(\.placeholderStyle) var placeholderStyle: NSIconPlaceholderStyle
    @State private var appIconUrl: URL?
    @State private var containsTransparentPixel = true

    public var body: some View {
        AsyncImage(url: appIconUrl) { image in
            Group {
                if addMask && !containsTransparentPixel {
                    image.appIconMask(platform)
                } else { image.iconDefault() }
            }
            .onAppear {
                if addMask {
                    Task {
                        guard let url = appIconUrl,
                              let image = await CGImage.create(with: url)
                        else { return }
                        containsTransparentPixel = await image.containsTransparentPixels()
                    }
                }
            }
            .overlay {
                if addMask && !containsTransparentPixel && platform == .iOS {
                    Image("AppIconMaskBorder", bundle: .module)
                        .resizable()
                }
            }
        } placeholder: {
            Image(nsImage: placeholderStyle.iconImage)
                .iconDefault()
        }
        .task { await loadIcon() }
    }

    private func loadIcon() async {
        let model = AsyncIconVM(appName: appName,
                             appBundleIdentifier: appBundleIdentifier,
                             platform: platform,
                             country: country)
        appIconUrl = await model.loadImage()
    }
}
#endif
