import SwiftUI

#if os(macOS)
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
        var classicIconPath: String
        if #available(macOS 13.0, *) {
            classicIconPath = coreTypesBundle.url(forResource: "GenericApplicationIcon", withExtension: "icns")!.path()
        } else {
            // Deprecated
            classicIconPath = coreTypesBundle.url(forResource: "GenericApplicationIcon", withExtension: "icns")!.path
        }
        switch self {
        case .default:
            return NSWorkspace.shared.icon(for: .applicationBundle)
        case .classic:
            return NSImage(contentsOfFile: classicIconPath)!
        }
    }
}

struct IconPlaceholderStyleKey: EnvironmentKey {
    static let defaultValue: NSIconPlaceholderStyle = .default
}

extension EnvironmentValues {
    var placeholderStyle: NSIconPlaceholderStyle {
        get { self[IconPlaceholderStyleKey.self] }
        set { self[IconPlaceholderStyleKey.self] = newValue }
    }
}
#endif
