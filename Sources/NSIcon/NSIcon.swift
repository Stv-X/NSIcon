import SwiftUI

public struct NSIcon: View {
    var appName: String
    var appBundleIdentifier: String

    @State private var iconImage: NSImage?

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

    public var body: some View {
        Group {
            if let icon = iconImage {
                Image(nsImage: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                let genericAppIconImage = NSWorkspace.shared.icon(for: .applicationBundle)
                Image(nsImage: genericAppIconImage)
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

        var id: String
        if appBundleIdentifier.isEmpty {
            do {
                try await id = getBundleId()
            } catch {
                return nil
            }
        } else {
            id = appBundleIdentifier
        }
        let iconRect = NSRect(x: 0, y: 0, width: 1024, height: 1024)

        guard let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: id) else { return nil }
        let appFile = appURL.path().replacing("%20", with: " ")
        let icon = NSWorkspace.shared.icon(forFile: appFile)

        guard let rep = icon.bestRepresentation(for: iconRect, context: nil, hints: nil) else { return nil }
        let image = NSImage(size: rep.size)
        image.addRepresentation(rep)
        return image
    }

    private func getBundleId() async throws -> String {
        let task = Process()
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        let error = NSError(domain: "NSIcon", code: 1, userInfo: [
                              NSLocalizedDescriptionKey: "Error when getting app id for \(appName)"
                            ])

        task.standardOutput = outputPipe
        task.standardError = errorPipe

        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["-e", "id of app \"\(appName)\""]

        try task.run()

        let errorData = try errorPipe.fileHandleForReading.readToEnd()
        if errorData?.isEmpty == false { throw error } else {
            guard let outputData = try outputPipe.fileHandleForReading.readToEnd() else { throw error }
            let output = String(decoding: outputData, as: UTF8.self).replacing("\n", with: "")
            return output
        }
    }
}
