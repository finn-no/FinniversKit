//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol PopupViewModel {
    var callToActionButtonTitle: String { get }
    var alternativeActionButtonTitle: String { get }
    var dismissButtonTitle: String? { get }
    var linkButtonTitle: String? { get }
    var descriptionTitle: String { get }
    var descriptionText: String? { get }
    var attributedDescriptionText: NSAttributedString? { get }
    var image: UIImage { get }
}
