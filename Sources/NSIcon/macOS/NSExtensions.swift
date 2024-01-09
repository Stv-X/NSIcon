import SwiftUI

#if os(macOS)
extension NSImage: @unchecked Sendable {}

extension NSImage {
    public static var appIcon: NSImage {
        .init(named: applicationIconName) ?? .init()
    }
}
#endif
