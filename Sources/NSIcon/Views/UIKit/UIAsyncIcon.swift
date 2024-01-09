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
                              let image = await url.loadCGImage()
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
            .task {
                if appName.isEmpty {
                    appIconUrl = await lookupAppIconUrlByBundleId()
                } else {
                    if country.isEmpty {
                        appIconUrl = await lookupAppIconUrlByName()
                    } else {
                        appIconUrl = await lookupAppIconUrlByName(countryCode: country)
                    }
                }
            }
    }

    private func lookupAppIconUrlByName(countryCode: String = "") async -> URL? {
        let endPoint = "https://itunes.apple.com/search"

        var components = URLComponents(string: endPoint)!
        components.queryItems = [
            URLQueryItem(name: "term", value: appName),
            URLQueryItem(name: "country", value: countryCode),
            URLQueryItem(name: "entity", value: platform.queryEntity),
            URLQueryItem(name: "limit", value: "1")
        ]
        return await lookup(using: components)
    }

    private func lookupAppIconUrlByBundleId() async -> URL? {
        let endPoint = "https://itunes.apple.com/lookup"
        var components = URLComponents(string: endPoint)!
        components.queryItems = [
            URLQueryItem(name: "bundleId", value: appBundleIdentifier)
        ]
        return await lookup(using: components)
    }

    private func lookup(using components: URLComponents) async -> URL? {
        let url = components.url!
        do {
            let data = try await URLSession.shared.data(from: url).0
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let results = json["results"] as? [[String: Any]],
               let appIconUrl = results.first?["artworkUrl512"] as? String
            else { return nil }
            let resultUrl = URL(string: appIconUrl.replacingOccurrences(of: "512x512bb", with: "1024x1024bb"))
            return resultUrl
        } catch { return nil }
    }
}
#endif
