//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct ContractActionViewModel {
    public let identifier: String?
    public let strings: [String]
    public let buttonTitle: String
    public let buttonUrl: URL

    public init(identifier: String?, strings: [String], buttonTitle: String, buttonUrl: URL) {
        self.identifier = identifier
        self.strings = strings
        self.buttonTitle = buttonTitle
        self.buttonUrl = buttonUrl
    }
}
