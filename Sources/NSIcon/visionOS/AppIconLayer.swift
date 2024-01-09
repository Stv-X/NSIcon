import SwiftUI

#if os(visionOS)
public enum AppIconLayer: String, CaseIterable {
    case back, middle, front
}

extension AppIconLayer {
    public var name: String {
        let iconName = UIImage.applicationIconName
        return iconName.appending("/" + rawValue.capitalized + "/Content")
    }
}

extension [AppIconLayer] {
    var sorted: [AppIconLayer] {
        let layerOrder: [AppIconLayer: Int] = [
            .back: 0,
            .middle: 1,
            .front: 2
        ]
        return self.sorted {
            layerOrder[$0]! < layerOrder[$1]!
        }
    }
}
#endif
