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
        let defaultIconImage = NSWorkspace.shared.icon(for: .applicationBundle)
        let coreTypesBundle = Bundle(path: "/System/Library/CoreServices/CoreTypes.bundle")!
        let classicIconPath = coreTypesBundle.url(forResource: "GenericApplicationIcon", withExtension: "icns")!.path()
        let classicIconImage = NSImage(contentsOfFile: classicIconPath) ?? NSImage()

        switch self {
        case .default:
            return defaultIconImage
        case .classic:
            return classicIconImage
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
