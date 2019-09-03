//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

final class IntegerNumberSuffixFormatter: NumberFormatter {
    let suffix: String

    init(suffix: String) {
        self.suffix = suffix
        super.init()
        numberStyle = .decimal
        maximumFractionDigits = 0
        allowsFloats = false
        groupingSize = 3
        groupingSeparator = " "
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Formatter

    func string(for value: Float) -> String? {
        return "\(super.string(from: value) ?? "") \(suffix)"
    }
}

// MARK: - Extensions

private extension NumberFormatter {
    @objc func string(from value: Float) -> String? {
        return string(from: NSNumber(value: value))
    }
}
