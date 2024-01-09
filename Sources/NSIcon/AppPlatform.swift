import SwiftUI

public enum AppPlatform {
    case iOS, macOS, watchOS, visionOS
}

extension AppPlatform {
    var queryEntity: String {
        switch self {
        case .iOS:
            return "software"
        case .macOS:
            return "macSoftware"
        case .watchOS:
            return "watchSoftware"
        case .visionOS:
            return "visionSoftware"
        }
    }
}

extension AppPlatform {
    var mask: some View {
        switch self {
        case .iOS:
            AnyView {
                Image("AppIconMask", bundle: .module)
                    .resizable()
            }
        case .macOS:
            AnyView {
                Image("MacAppIconMask", bundle: .module)
                    .resizable()
            }
        case .watchOS:
            AnyView { Circle() }
        case .visionOS:
            AnyView { Circle() }
        }
    }
}
