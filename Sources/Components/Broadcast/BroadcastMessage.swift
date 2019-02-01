//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct BroadcastMessage: Hashable, Codable {
    public let id: Int
    public let text: String
    public let broadcastAreas: [String]

    enum CodingKeys: String, CodingKey {
        case text = "message"
        case id, broadcastAreas
    }

    public init(id: Int, text: String) {
        self.id = id
        self.text = text
        broadcastAreas = []
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id.hashValue)
    }

    public static func == (lhs: BroadcastMessage, rhs: BroadcastMessage) -> Bool {
        return lhs.id == rhs.id
    }
}

extension BroadcastMessage {
    func attributedString(for text: String) -> NSAttributedString {
        guard let messageData = text.data(using: .utf16) else {
            return NSAttributedString(string: text)
        }

        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        guard let attributedString = try? NSMutableAttributedString(data: messageData, options: options, documentAttributes: nil) else {
            return NSAttributedString(string: text)
        }

        return attributedString
    }
}
