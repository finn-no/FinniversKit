//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol LoginViewModel {
    var headerText: String { get }
    var emailPlaceholder: String { get }
    var passwordPlaceholder: String { get }
    var forgotPasswordButtonTitle: String { get }
    var loginButtonTitle: String { get }
    var newUserButtonTitle: String { get }
    var customerServiceTitle: String { get }
    var customerServiceIntro: String { get }
    var privacyPolicyTitle: String { get }
}

public extension LoginViewModel {
    var accessibilityLabel: String {
        return ""
    }
}
