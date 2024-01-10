import SwiftUI

#if canImport(UIKit)
public struct UIAsyncIcon<P: View>: Icon {
    public var appName: String
    public var appBundleIdentifier: String
    var platform: AppPlatform
    var country: String
    var addMask: Bool
    var placeholder: P

    public static var defaultPlaceholder: some View {
        Color.clear
            .overlay { ProgressView() }
            .aspectRatio(1, contentMode: .fit)
    }

    public init(
        _ appName: String,
        for platform: AppPlatform = .iOS,
        country: String = "",
        addMask: Bool = true,
        @ViewBuilder placeholder: @escaping () -> P = { defaultPlaceholder }
    ) {
        self.appName = appName
        self.platform = platform
        self.country = country
        self.addMask = addMask
        self.appBundleIdentifier = ""
        self.placeholder = placeholder()
    }

    public init(
        bundleIdentifier: String,
        addMask: Bool = true,
        @ViewBuilder placeholder: @escaping () -> P = { defaultPlaceholder }
    ) {
        self.appName = ""
        self.platform = .iOS
        self.country = ""
        self.addMask = addMask
        self.appBundleIdentifier = bundleIdentifier
        self.placeholder = placeholder()
    }

    @State private var appIconUrl: URL?
    @State private var containsTransparentPixel = true

    public var body: some View {
        AsyncImage(url: appIconUrl) { image in
            Group {
                if addMask && !containsTransparentPixel {
                    image
                        .appIconMask(platform)
                } else {
                    image
                        .iconDefault()
                }
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
        } placeholder: { placeholder }
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
