//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol ContactFormViewModel {
    var title: String { get }
    var detailText: String { get }
    var accessoryText: String { get }
    var namePlaceholder: String { get }
    var emailPlaceholder: String { get }
    var showPhoneNumberQuestion: String { get }
    var showPhoneNumberAnswer: String { get }
    var phoneNumberPlaceholder: String { get }
    var submitButtonTitle: String { get }
}
