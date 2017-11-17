//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol ToastModel {
    var type: ToastType { get }
    var messageTitle: String { get }
    var accessibilityLabel: String { get }
    var actionButtonTitle: String? { get }
    var imageThumbnail: UIImage? { get }
}

public extension ToastModel {
    var accessibilityLabel: String {
        return messageTitle
    }
}
