//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol RegisterViewModel {
    var headerText: String { get }
    var emailPlaceholder: String { get }
    var passwordPlaceholder: String { get }
    var loginButtonTitle: String { get }
    var newUserButtonTitle: String { get }
    var userTermsIntroText: String { get }
    var userTermsButtonTitle: String { get }
    var customerServiceTitle: String { get }
}

public extension RegisterViewModel {
    var accessibilityLabel: String {
        return ""
    }
}
