//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol PopupConsentViewModel {
    var yesButtonTitle: String { get }
    var noButtonTitle: String { get }
    var cancelButtonTitle: String? { get }
    var infoButtonTitle: String? { get }
    var descriptionTitle: String { get }
    var descriptionText: String { get }
    var image: UIImage { get }
}
