//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public struct MotorTransactionInvalidUserViewModel {
    public var title: String
    public var detail: NSAttributedString
    public var continueButtonText: String
    public var cancelButtonText: String

    public init(title: String, detail: NSAttributedString, continueButtonText: String, cancelButtonText: String) {
        self.title = title
        self.detail = detail
        self.continueButtonText = continueButtonText
        self.cancelButtonText = cancelButtonText
    }
}
