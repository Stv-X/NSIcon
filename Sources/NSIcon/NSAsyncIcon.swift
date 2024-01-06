import SwiftUI

public struct NSAsyncIcon: View {
    var appName: String
    var platform: AppPlatform
    var country: String
    var addMask: Bool
    var appBundleIdentifier: String

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
                                .mask(Image(packageResource: "MacAppIconMask", ofType: "svg").resizable())
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(824/1024)
                                .shadow(color: .black.opacity(0.3), radius: shadowRadius, y: shadowRadius)
                        }
                    case .iOS:
                        image
                            .resizable()
                            .mask(Image(packageResource: "AppIconMask", ofType: "svg").resizable())
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
            let genericAppIconImage = NSWorkspace.shared.icon(for: .applicationBundle)
            Image(nsImage: genericAppIconImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .overlay {
            if addMask && !containsTransparentPixel && platform == .iOS {
                Image(packageResource: "AppIconMaskBorder", ofType: "svg").resizable()
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
        let software = switch platform {
        case .iOS: "software"
        case .macOS: "macSoftware"
        }
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
            let resultUrl = URL(string: appIconUrl.replacing("512x512bb", with: "1024x1024bb"))
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
