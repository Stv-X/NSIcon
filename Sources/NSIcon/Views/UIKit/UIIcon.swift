import SwiftUI

#if os(visionOS)
public struct UIIcon: View {
    public var addMask: Bool

    public init(addMask: Bool = true) {
        self.addMask = addMask
        self.layerNames = AppIconLayer.allCases.map(\.name)
    }

    public init(_ layer: AppIconLayer, addMask: Bool = true) {
        self.addMask = addMask
        self.layerNames = [layer].sorted.map(\.name)
    }

    public init(_ layers: [AppIconLayer], addMask: Bool = true) {
        self.addMask = addMask
        self.layerNames = layers.sorted.map(\.name)
    }

    @State private var layerNames: [String]

    public var body: some View {
        Group {
            if addMask {
                icon
                    .mask { AppPlatform.visionOS.mask }
            } else {
                icon
            }
        }
    }

    private var icon: some View {
        ZStack {
            ForEach(layerNames, id: \.self) { layer in
                Image(layer)
                    .iconDefault()
            }
        }
    }
}
#elseif canImport(UIKit)
public struct UIIcon: View {
    var addMask: Bool
    public init(addMask: Bool = true) {
        self.addMask = addMask
    }
    public var body: some View {
        Group {
            if addMask {
                maskedIcon
            } else {
                Image(uiImage: UIImage.appIcon)
                    .iconDefault()
            }
        }
#if os(iOS) && !targetEnvironment(macCatalyst)
        .overlay {
            if addMask {
                Image("AppIconMaskBorder", bundle: .module)
                    .resizable()
            }
        }
#endif
    }
    private var maskedIcon: some View {
        Image(uiImage: UIImage.appIcon)
#if os(iOS) && !targetEnvironment(macCatalyst)
            .appIconMask(.iOS)
#elseif os(watchOS)
            .appIconMask(.watchOS)
#else
            .appIconMask(.macOS)
#endif
    }
}
#endif
