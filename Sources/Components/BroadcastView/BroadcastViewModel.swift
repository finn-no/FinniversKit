//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct BroadcastViewModel {
    public let message: String

    public init(with message: String) {
        self.message = message
    }

    var messageWithHTMLLinksReplacedByAttributedStrings: NSAttributedString {
        guard let messageData = message.data(using: .utf16) else {
            return NSAttributedString(string: message)
        }

        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        guard let attributedString = try? NSMutableAttributedString(data: messageData, options: options, documentAttributes: nil) else {
            return NSAttributedString(string: message)
        }

        return attributedString
    }
}
