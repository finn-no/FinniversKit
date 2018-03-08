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
        var result = NSMutableAttributedString(string: message)

        while let htmlLink = HTMLLink.links(in: result.string).first {
            var string = result.string
            string.replaceSubrange(htmlLink.range, with: htmlLink.text)

            let linkRange = NSString(string: string).range(of: htmlLink.text)

            let attributedString = NSMutableAttributedString(string: string)
            attributedString.addAttribute(NSAttributedStringKey.link, value: htmlLink.url, range: linkRange)

            result = attributedString
        }

        return result
    }
}

extension BroadcastViewModel {
    var htmlLinksInMessage: [HTMLLink] {
        return HTMLLink.links(in: message)
    }
}

extension BroadcastViewModel {
    struct HTMLLink {
        let range: Range<String.Index>
        let text: String
        let url: URL

        static var htmlAnchorRegexPattern: String {
            // <\s*a\s+[^>]*href\s*=\s*["']?([^\"' >]+)["']\s*>(.+?(?=<))<\s*\/a\s*>
            let openingTagRegex = "<\\s*a\\s+[^>]*href\\s*=\\s*[\"']?([^\"' >]+)[\"']\\s*>"
            let linkTextRegex = "(.+?(?=<))"
            let closingTagRegex = "<\\s*\\/a\\s*>"

            return openingTagRegex + linkTextRegex + closingTagRegex
        }

        init?(from textCheckingResult: NSTextCheckingResult, in searchString: String) {
            guard textCheckingResult.numberOfRanges == 3 else {
                return nil
            }

            let urlCaptureGroupRange = textCheckingResult.range(at: 1)
            let urlStartIndex = String.Index(encodedOffset: urlCaptureGroupRange.lowerBound)
            let urlEndIndex = String.Index(encodedOffset: urlCaptureGroupRange.upperBound)
            let urlString = String(searchString[urlStartIndex ..< urlEndIndex])

            let linkTextCaptureGroupRange = textCheckingResult.range(at: 2)
            let linkTextStartIndex = String.Index(encodedOffset: linkTextCaptureGroupRange.lowerBound)
            let linkTextEndIndex = String.Index(encodedOffset: linkTextCaptureGroupRange.upperBound)
            let linkText = String(searchString[linkTextStartIndex ..< linkTextEndIndex])

            guard let url = URL(string: urlString), let range = Range<String.Index>(textCheckingResult.range, in: searchString) else {
                return nil
            }

            self.range = range
            text = linkText
            self.url = url
        }

        static func links(in searchString: String) -> [HTMLLink] {
            guard let regex = try? NSRegularExpression(pattern: HTMLLink.htmlAnchorRegexPattern, options: .caseInsensitive) else {
                return []
            }

            let matches = regex.matches(in: searchString, range: NSMakeRange(0, searchString.utf16.count))
            let links = matches.flatMap { HTMLLink(from: $0, in: searchString) }

            return links
        }
    }
}
