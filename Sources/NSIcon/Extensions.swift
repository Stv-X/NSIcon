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
        let width = self.width
        let height = self.height

        guard let imageData = self.dataProvider?.data,
              let data = CFDataGetBytePtr(imageData) else {
            return false
        }

        let bytesPerPixel = 4
        _ = bytesPerPixel * width

        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = (y * width + x) * bytesPerPixel
                let alpha = data[pixelIndex + 3]

                if alpha == 0 {
                    return true
                }
            }
        }
        return false
    }
}
