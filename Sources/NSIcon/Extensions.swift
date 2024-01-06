import SwiftUI

extension NSImage: @unchecked Sendable {}

extension Image {
    init(packageResource name: String, ofType type: String) {
        guard let path = Bundle.module.path(forResource: name, ofType: type),
              let image = NSImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(nsImage: image)
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

struct IconPlaceholderStyleKey: EnvironmentKey {
    static let defaultValue: NSIconPlaceholderStyle = .default
}

extension EnvironmentValues {
    var placeholderStyle: NSIconPlaceholderStyle {
        get { self[IconPlaceholderStyleKey.self] }
        set { self[IconPlaceholderStyleKey.self] = newValue }
    }
}
