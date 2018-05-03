//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol AdsGridViewModel {
    var imagePath: String? { get }
    var imageSize: CGSize { get }
    var iconImage: UIImage? { get }
    var title: String { get }
    var subTitle: String? { get }
    var imageText: String? { get }
    var accessibilityLabel: String { get }
}

public extension AdsGridViewModel {
    var accessibilityLabel: String {
        var message = title

        if let subTitle = subTitle {
            message += ". " + subTitle
        }

        if let imageText = imageText {
            message += ". " + imageText
        }

        return message
    }
}
