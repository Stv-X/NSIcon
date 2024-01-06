import SwiftUI

public protocol Icon: View {
    var appName: String { get }
    var appBundleIdentifier: String { get }
}

extension Icon {
    public func iconPlaceholderStyle(_ style: NSIconPlaceholderStyle) -> some View {
        modifier(IconPlaceholderStyle(style: style))
    }
}
