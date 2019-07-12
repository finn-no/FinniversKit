//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

private class WeakImage {
    private(set) weak var value: UIImage?

    init(value: UIImage) {
        self.value = value
    }
}

class ImageMemoryCache {
    private var cache: [String: WeakImage] = [:]

    func add(_ image: UIImage, forKey key: String) {
        cache[key] = WeakImage(value: image)
    }

    func image(forKey key: String) -> UIImage? {
        guard cache.keys.contains(key) else {
            return nil
        }

        guard let ref = cache[key], ref.value != nil else {
            cache.removeValue(forKey: key)
            return nil
        }

        return ref.value
    }
}
