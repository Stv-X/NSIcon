import SwiftUI

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
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(nsImage: placeholderStyle.iconImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .task { iconImage = await loadImage() }
    }

    private func loadImage() async -> NSImage? {
        guard !(appName.isEmpty && appBundleIdentifier.isEmpty) else {
            return NSImage(named: NSImage.applicationIconName)
        }

        let id = appBundleIdentifier.isEmpty ? await getBundleId() : appBundleIdentifier

        guard let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: id) else { return nil }
        let appFile = appURL.path().replacing("%20", with: " ")
        let icon = NSWorkspace.shared.icon(forFile: appFile)
        return icon
    }

    private func getBundleId() async -> String {
        let source = "id of app \"\(appName)\""
        let script = NSAppleScript(source: source)!
        var error: NSDictionary?
        return script.executeAndReturnError(&error).stringValue ?? ""
    }
}
