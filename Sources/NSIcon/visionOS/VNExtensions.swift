import SwiftUI

#if os(visionOS)
extension UIImage {
    public static var applicationIconName: String {
        guard let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? String
        else { return "AppIcon" }
        return primaryIcon
    }
}
#endif
