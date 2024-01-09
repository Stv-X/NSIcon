import SwiftUI
import ImageIO

// MARK: UIKit
#if canImport(UIKit)
extension UIImage {
    public static var appIcon: UIImage {
        .init(named: applicationIconName) ?? .init()
    }
}
#endif

// MARK: Shared
extension Image {
    func iconDefault() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
    }

    func appIconMask(_ platform: AppPlatform) -> some View {
        switch platform {
        case .macOS:
            return AnyView (
                GeometryReader { geometry in
                    let shadowRadius = min(geometry.size.width, geometry.size.height) * (10/1024)
                    let iconScale = CGFloat(824/1024)
                    let shadowColor = Color.black.opacity(0.3)
                    self
                        .iconDefault()
                        .mask { platform.mask }
                        .scaleEffect(iconScale)
                        .shadow(color: shadowColor, radius: shadowRadius, y: shadowRadius)
                        .frame(width: geometry.frame(in: .global).width,
                               height: geometry.frame(in: .global).height)
                }
                .aspectRatio(1, contentMode: .fit)
            )
        default:
            return AnyView (
                self
                    .iconDefault()
                    .mask { platform.mask }
            )
        }
    }
}

extension CGImage {
    func containsTransparentPixels() async -> Bool {
        guard let imageData = self.dataProvider?.data,
              let data = CFDataGetBytePtr(imageData) else { return false }

        let totalPixels = self.width * self.height
        let bytesPerPixel = 4
        let alphaOffset = 3

        for pixelIndex in stride(from: 0, to: totalPixels * bytesPerPixel, by: bytesPerPixel) {
            let alpha = data[pixelIndex + alphaOffset]
            if alpha == 0 {
                return true
            }
        }
        return false
    }
}

extension CGImage {
    static func create(with url: URL) async -> CGImage? {
        guard let fetchedImage = CGImageSourceCreateWithURL(url as CFURL, nil),
              let cgImage = CGImageSourceCreateImageAtIndex(fetchedImage, 0, nil)
        else { return nil }
        return cgImage
    }
}
