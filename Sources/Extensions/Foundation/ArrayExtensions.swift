//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

extension Array where Array.Element: ExpressibleByNilLiteral {
    subscript(safe index: Index) -> Element {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Array where Element == String {
    func bulletPoints(withFont font: UIFont) -> NSAttributedString {
        return NSAttributedString.bulletPoints(from: self, font: font)
    }
}
