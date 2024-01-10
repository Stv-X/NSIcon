import SwiftUI

public class AsyncIconVM {
    private var appName: String
    private var appBundleIdentifier: String
    private var platform: AppPlatform
    private var country: String

    init(appName: String,
         appBundleIdentifier: String,
         platform: AppPlatform,
         country: String
    ) {
        self.appName = appName
        self.appBundleIdentifier = appBundleIdentifier
        self.platform = platform
        self.country = country
    }

    public func loadImage() async -> URL? {
        if appName.isEmpty {
            return await lookupAppIconUrlByBundleId()
        } else {
            if country.isEmpty {
                return await lookupAppIconUrlByName()
            } else {
                return await lookupAppIconUrlByName(countryCode: country)
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
