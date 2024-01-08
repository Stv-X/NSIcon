import SwiftUI

extension NSImage: @unchecked Sendable {}

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

struct IconPlaceholderStyleKey: EnvironmentKey {
    static let defaultValue: NSIconPlaceholderStyle = .default
}

extension EnvironmentValues {
    var placeholderStyle: NSIconPlaceholderStyle {
        get { self[IconPlaceholderStyleKey.self] }
        set { self[IconPlaceholderStyleKey.self] = newValue }
    }
}
