import SwiftUI

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
        for platform: AppPlatform = .macOS,
        addMask: Bool = false
    ) {
        self.appName = ""
        self.platform = platform
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
                    switch platform {
                    case .macOS:
                        GeometryReader { geometry in
                            let shadowRadius = min(geometry.size.width, geometry.size.height) * (10/1024)
                            image
                                .resizable()
                                .mask(Image("MacAppIconMask", bundle: .module).resizable())
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(824/1024)
                                .shadow(color: .black.opacity(0.3), radius: shadowRadius, y: shadowRadius)
                                .frame(width: geometry.frame(in: .global).width,
                                       height: geometry.frame(in: .global).height)
                        }
                        .aspectRatio(1, contentMode: .fit)
                    case .iOS:
                        image
                            .resizable()
                            .mask(Image("AppIconMask", bundle: .module).resizable())
                            .aspectRatio(contentMode: .fit)
                    }
                } else {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .onAppear {
                if addMask {
                    Task {
                        guard let image = await loadCGImage(url: appIconUrl!) else { return }
                        containsTransparentPixel = await image.containsTransparentPixels()
                    }
                }
            }
        } placeholder: {
            Image(nsImage: placeholderStyle.iconImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .overlay {
            if addMask && !containsTransparentPixel && platform == .iOS {
                Image("AppIconMaskBorder", bundle: .module).resizable()
            }
        }
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
#if swift(>=5.9)
        let software = switch platform {
        case .iOS: "software"
        case .macOS: "macSoftware"
        }
#else
        let software: String
        switch platform {
        case .iOS: software = "software"
        case .macOS: software = "macSoftware"
        }
#endif
        components.queryItems = [
            URLQueryItem(name: "term", value: appName),
            URLQueryItem(name: "country", value: countryCode),
            URLQueryItem(name: "entity", value: software),
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

    private func loadCGImage(url: URL) async -> CGImage? {
        do {
            let imageData = try await URLSession.shared.data(from: url).0
            guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
                  let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
            else { return nil }
            return cgImage
        } catch { return nil }
    }
}

public enum AppPlatform {
    case iOS, macOS
}
