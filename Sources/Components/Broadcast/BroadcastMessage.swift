//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct BroadcastMessage: Hashable {
    public let id: Int
    public let text: String

    public init(id: Int, text: String) {
        self.id = id
        self.text = text
    }

    var messageWithHTMLLinksReplacedByAttributedStrings: NSAttributedString {
        guard let messageData = text.data(using: .utf16) else {
            return NSAttributedString(string: text)
        }

        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        guard let attributedString = try? NSMutableAttributedString(data: messageData, options: options, documentAttributes: nil) else {
            return NSAttributedString(string: text  )
        }

        return attributedString
    }
}
