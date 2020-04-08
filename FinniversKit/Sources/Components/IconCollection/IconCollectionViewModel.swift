//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct IconCollectionViewModel {
    public let title: String?
    public let text: String
    public let image: UIImage

    public init(title: String? = nil, text: String, image: UIImage) {
        self.title = title
        self.text = text
        self.image = image
    }
}
