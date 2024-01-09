import SwiftUI

public protocol Icon: View {
    var appName: String { get }
    var appBundleIdentifier: String { get }
}

#if os(macOS)
extension Icon {
    public func iconPlaceholderStyle(_ style: NSIconPlaceholderStyle) -> some View {
        modifier(IconPlaceholderStyle(style: style))
    }
}
#endif
