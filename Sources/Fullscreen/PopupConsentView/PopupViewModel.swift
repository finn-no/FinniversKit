//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol PopupViewModel {
    var bottomRightButtonTitle: String { get }
    var bottomLeftButtonTitle: String { get }
    var topRightButtonTitle: String? { get }
    var linkButtonTitle: String? { get }
    var descriptionTitle: String { get }
    var descriptionText: String { get }
    var image: UIImage { get }
}
