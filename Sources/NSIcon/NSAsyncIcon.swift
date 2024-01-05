import SwiftUI

public struct NSAsyncIcon: View {
    var appName: String
    var country: String
    var appBundleIdentifier: String
    var addMask: Bool
    
    public init(_ appName: String, addMask: Bool = true) {
        self.appName = appName
        self.country = ""
        self.appBundleIdentifier = ""
        self.addMask = addMask
    }
    
    public init(_ appName: String, country: String, addMask: Bool = true) {
        self.appName = appName
        self.country = country
        self.appBundleIdentifier = ""
        self.addMask = addMask
    }

    public init(bundleIdentifier: String, addMask: Bool = true) {
        self.appName = ""
        self.country = ""
        self.appBundleIdentifier = bundleIdentifier
        self.addMask = addMask
    }

    @State private var appIconUrl: URL?
    @State private var isMacApp = true
    
    public var body: some View {
        AsyncImage(url: appIconUrl) { image in
            Group {
                if addMask && !isMacApp {
                    image
                        .resizable()
                        .mask(Image(packageResource: "AppIconMask", ofType: "svg").resizable())
                        .aspectRatio(contentMode: .fit)
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
                        isMacApp = await image.containsTransparentPixels()
                    }
                }
            }
        } placeholder: {
            Image(packageResource: "GenericAppIcon", ofType: "png")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .overlay {
            if addMask && !isMacApp {
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
        components.queryItems = [
            URLQueryItem(name: "term", value: appName),
            URLQueryItem(name: "country", value: countryCode),
            URLQueryItem(name: "entity", value: "software"),
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
        let data = try! await URLSession.shared.data(from: url).0
        if let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let results = json["results"] as? [[String: Any]],
           let appIconUrl = results.first?["artworkUrl512"] as? String,
           let url = URL(string: appIconUrl.replacing("512x512bb", with: "1024x1024bb")) {
            return url
        } else {
            return nil
        }
    }

    private func loadCGImage(url: URL) async -> CGImage? {
        do {
            let imageData = try await URLSession.shared.data(from: url).0
            guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
                  let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
                return nil
            }

            return cgImage
        } catch {
            print("Error fetching image: \(error)")
            return nil
        }
    }
}
