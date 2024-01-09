import SwiftUI

#if os(macOS)
public class NSIconVM {
    private var appName: String
    private var appBundleIdentifier: String

    init(appName: String, appBundleIdentifier: String) {
        self.appName = appName
        self.appBundleIdentifier = appBundleIdentifier
    }

    public func loadImage() async -> NSImage? {
        guard !(appName.isEmpty && appBundleIdentifier.isEmpty)
        else { return NSImage.appIcon }

        let id = appBundleIdentifier.isEmpty ? await getBundleId() : appBundleIdentifier

        guard let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: id)
        else { return nil }

        var appFile: String
        if #available(macOS 13.0, *) {
            appFile = appURL.path(percentEncoded: false)
        } else {
            // Deprecated
            appFile = appURL.path
        }

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
#endif
