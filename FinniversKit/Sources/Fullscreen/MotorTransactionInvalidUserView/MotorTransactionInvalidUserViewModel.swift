//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public struct MotorTransactionInvalidUserViewModel {
    public var title: String
    public var detail: NSAttributedString
    public var continueButton: String
    public var cancelButton: String

    public init(title: String, detail: NSAttributedString, continueButton: String, cancelButton: String) {
        self.title = title
        self.detail = detail
        self.continueButton = continueButton
        self.cancelButton = cancelButton
    }
}
