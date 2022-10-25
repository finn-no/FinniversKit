import Foundation

public protocol HTMLStringReaderDelegate: AnyObject {
    func reader(
        _ reader: HTMLStringReader,
        didStartTag tagName: String,
        attributes attributeDict: [String: String]
    )

    func reader(
        _ reader: HTMLStringReader,
        didEndTag tagName: String
    )

    func reader(
        _ reader: HTMLStringReader,
        foundText text: String
    )

    func reader(
        _ reader: HTMLStringReader,
        foundComment comment: String
    )

    func reader(
        _ reader: HTMLStringReader,
        foundDocumentTag text: String
    )
}

public final class HTMLStringReader {
    private struct BeginTag {
        let name: String
        let attributes: [String: String]
    }

    private struct EndTag {
        let name: String
    }

    private struct CommentTag {
        let comment: String
    }

    private struct DocumentTag {
        let name: String
        let text: String
    }

    private enum Tag {
        case begin(BeginTag)
        case end(EndTag)
        case comment(CommentTag)
        case document(DocumentTag)
    }

    private struct TagMatch {
        let tag: Tag
        let range: Range<String.Index>
    }

    public weak var delegate: HTMLStringReaderDelegate?

    /// Regex pattern with capture groups for / end tag marker (optional), tag name, and attributes (optional).
    private let tagPattern = #"<(\/)?(\w+)(?:\s*>|\s+(\w+=".*?")+\s*>)"#
    private let commentPattern = #"<!--(.*?)-->"#
    private let documentPattern = #"<!(\w+)(?:\s*>|\s+(.*?)\s*>)"#

    private let tagRegex: NSRegularExpression
    private let commentRegex: NSRegularExpression
    private let documentRegex: NSRegularExpression

    public init(delegate: HTMLStringReaderDelegate? = nil) {
        // The tag regex is predefined and validated, and should always compile
        // swiftlint:disable force_try
        self.tagRegex = try! NSRegularExpression(pattern: tagPattern, options: .dotMatchesLineSeparators)
        self.commentRegex = try! NSRegularExpression(pattern: commentPattern, options: .dotMatchesLineSeparators)
        self.documentRegex = try! NSRegularExpression(pattern: documentPattern, options: .dotMatchesLineSeparators)
        // swiftlint:enable force_try
    }

    func read(html: String) {
        var foundTagMatch: TagMatch?
        var substring = html[html.startIndex..<html.endIndex]
        while let tagStartIndex = substring.firstIndex(of: "<") {
            let nextIndex = substring.index(after: tagStartIndex)
            if nextIndex == substring.endIndex {
                break
            }
            let tagSubstring = substring[tagStartIndex..<substring.endIndex]
            if substring[nextIndex] == "!" {
                // Search for comment, then document tag
                if let commentMatch = matchCommentTag(in: tagSubstring) {
                    foundTagMatch = commentMatch
                } else if let documentMatch = matchDocumentTag(in: tagSubstring) {
                    foundTagMatch = documentMatch
                }
            } else if let tagMatch = matchTag(in: tagSubstring) {
                foundTagMatch = tagMatch
            }

            if let tagMatch = foundTagMatch {
                let text = substring[substring.startIndex..<tagMatch.range.lowerBound]
                // Emit text
                // Emit tag
                substring = substring[tagMatch.range.upperBound..<substring.endIndex]
                foundTagMatch = nil
            } else {
                substring = substring[nextIndex..<substring.endIndex]
            }
        }
        // Emit remaining text


    }

    private func matchCommentTag(in substring: Substring) -> TagMatch? {
        let searchString = String(substring)
        let nsRange = NSRange(searchString.startIndex..<searchString.endIndex, in: searchString)
        guard
            let match = commentRegex.firstMatch(in: searchString, range: nsRange),
            match.numberOfRanges == 2,
            let tagRange = Range(match.range(at: 0), in: searchString),
            let commentRange = Range(match.range(at: 1), in: searchString)
        else {
            return nil
        }
        let comment = String(searchString[commentRange])
        let tag = CommentTag(comment: comment)
        return TagMatch(tag: .comment(tag), range: tagRange)
    }

    private func matchDocumentTag(in substring: Substring) -> TagMatch? {
        let searchString = String(substring)
        let nsRange = NSRange(searchString.startIndex..<searchString.endIndex, in: searchString)
        guard
            let match = documentRegex.firstMatch(in: searchString, range: nsRange),
            match.numberOfRanges == 3,
            let tagRange = Range(match.range(at: 0), in: searchString),
            let nameRange = Range(match.range(at: 1), in: searchString),
            let textRange = Range(match.range(at: 2), in: searchString)
        else {
            return nil
        }
        let name = String(searchString[nameRange])
        let text = String(searchString[textRange])
        let tag = DocumentTag(name: name, text: text)
        return TagMatch(tag: .document(tag), range: tagRange)
    }

    private func matchTag(in substring: Substring) -> TagMatch? {
        let searchString = String(substring)
        let nsRange = NSRange(searchString.startIndex..<searchString.endIndex, in: searchString)
        guard
            let match = tagRegex.firstMatch(in: searchString, range: nsRange),
            match.numberOfRanges == 4,
            let tagRange = Range(match.range(at: 0), in: searchString),
            let nameRange = Range(match.range(at: 2), in: searchString),
            let attributesRange = Range(match.range(at: 3), in: searchString)
        else {
            return nil
        }
        let isEndTagNSRange = match.range(at: 1)
        let isEndTag = isEndTagNSRange.lowerBound != NSNotFound
        let name = String(searchString[nameRange])
        // Parse attributes
        if isEndTag {
            let tag = EndTag(name: name)
            return TagMatch(tag: .end(tag), range: tagRange)
        } else {
            let attributesString = String(searchString[attributesRange])
            let tag = BeginTag(name: name, attributes: [:])
            return TagMatch(tag: .begin(tag), range: tagRange)
        }
    }
}

/*
public protocol HTMLStringReaderDelegate: AnyObject {
    func reader(
        _ reader: HTMLStringCharacterReader,
        didStartTag tagName: String,
        attributes attributeDict: [String: String]
    )

    func reader(
        _ reader: HTMLStringCharacterReader,
        didEndTag tagName: String
    )

    func reader(
        _ reader: HTMLStringCharacterReader,
        foundText text: String
    )

    func reader(
        _ reader: HTMLStringCharacterReader,
        foundComment comment: String
    )

    func reader(
        _ reader: HTMLStringCharacterReader,
        foundDocumentTag text: String
    )
}

public final class HTMLStringCharacterReader {
    private struct BeginTag {
        let name: String
        let attributes: [String: String]
    }

    private struct EndTag {
        let name: String
    }

    private struct CommentTag {
        let comment: String
    }

    private struct OtherTag {
        let text: String
    }

    private enum Tag {
        case begin(BeginTag)
        case end(EndTag)
        case comment(CommentTag)
        case other(OtherTag)
    }

    public weak var delegate: HTMLStringReaderDelegate?

    public init(delegate: HTMLStringReaderDelegate? = nil) {
        self.delegate = delegate
    }

    public func read(html: String) {
        var status = ReadStatus(html: html)

        while let character = status.nextChar() {
            if character == "<" {
                status.tagText.append(character)
                if let tag = readTag(status: &status) {
                    // Emit text up to tag start
                    emitText(status: &status)
                    emitTag(tag, status: &status)
                } else {
                    // Not a tag after all, append found text and continue reading
                    status.foundText.append(status.tagText)
                    status.tagText.removeAll()
                }
            } else {
                status.foundText.append(character)
            }
        }
        // Emit remaining text if any
        emitText(status: &status)
    }

    private func emitTag(_ tag: Tag, status: inout ReadStatus) {
        switch tag {
        case .begin(let beginTag):
            delegate?.reader(self, didStartTag: beginTag.name, attributes: beginTag.attributes)
        case .end(let endTag):
            delegate?.reader(self, didEndTag: endTag.name)
        case .comment(let commentTag):
            delegate?.reader(self, foundComment: commentTag.comment)
        case .other(let otherTag):
            delegate?.reader(self, foundDocumentTag: otherTag.text)
        }
    }

    private func emitText(status: inout ReadStatus) {
        guard !status.foundText.isEmpty else { return }
        delegate?.reader(self, foundText: status.foundText)
        status.foundText.removeAll()
    }

    private func readTag(status: inout ReadStatus) -> Tag? {
        while var character = status.nextTagChar() {
            switch character {
            case "!":
                // Comment or document tag
                character = status.nextTagChar()
                break
            case "/":
                // End tag
                break
            default:
                // Name of
            }
        }
    }
}

extension HTMLStringCharacterReader {
    private struct ReadStatus {
        let html: String
        var isReadingTag: Bool
        var tagBeginIndex: String.Index
        var tagEndIndex: String.Index
        var readPos: String.Index
        var foundText: String
        var tagText: String

        init(html: String) {
            self.html = html
            self.isReadingTag = false
            self.tagBeginIndex = html.startIndex
            self.tagEndIndex = html.startIndex
            self.readPos = html.startIndex
            self.foundText = ""
            self.tagText = ""
        }

        mutating func advanceReadPos() {
            readPos = html.index(after: readPos)
        }

        func lookAhead(count: Int) -> Substring {
            guard readPos < html.endIndex else { return "" }
            let startIndex = html.index(after: readPos)
            guard startIndex < html.endIndex else { return "" }
            var stopIndex = html.index(startIndex, offsetBy: count)
            if stopIndex > html.endIndex { stopIndex = html.endIndex }
            return html[startIndex..<stopIndex]
        }

        mutating func nextChar() -> Character? {
            guard readPos != html.endIndex else { return nil }
            let character = html[readPos]
            advanceReadPos()
            return character
        }

        mutating func nextTagChar() -> Character? {
            guard let character = nextChar() else { return nil }
            tagText.append(character)
            return character
        }
    }
}
*/

