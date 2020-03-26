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

extension Array {
    func chunked(by size: Int) -> [[Element]] {
        guard !isEmpty else { return [[]] }

        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }

    func split(in columns: Int) -> [[Element]] {
        guard columns > 0 else {
            return []
        }

        let size = chunkSize(forColumns: columns)
        return chunked(by: size)
    }

    func chunkSize(forColumns columns: Int) -> Int {
        Int(ceil(Double(count) / Double(columns)))
    }
}
