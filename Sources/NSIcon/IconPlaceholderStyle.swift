import SwiftUI

public struct IconPlaceholderStyle: ViewModifier {
    let style: NSIconPlaceholderStyle

    public func body(content: Content) -> some View {
        content.environment(\.placeholderStyle, style)
    }
}

public enum NSIconPlaceholderStyle {
    case `default`, classic
}

extension NSIconPlaceholderStyle {
    var iconImage: NSImage {
        let coreTypesBundle = Bundle(path: "/System/Library/CoreServices/CoreTypes.bundle")!
        let classicIconPath = coreTypesBundle.url(forResource: "GenericApplicationIcon", withExtension: "icns")!.path()
        switch self {
        case .default:
            return NSWorkspace.shared.icon(for: .applicationBundle)
        case .classic:
            return NSImage(contentsOfFile: classicIconPath)!
        }
    }
}
