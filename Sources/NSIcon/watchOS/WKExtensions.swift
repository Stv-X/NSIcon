import SwiftUI

#if os(watchOS)
extension UIImage {
    public static var applicationIconName: String {
        guard let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconName = primaryIcon["CFBundleIconName"] as? String
        else { return "AppIcon" }
        return iconName
    }
}
#endif
