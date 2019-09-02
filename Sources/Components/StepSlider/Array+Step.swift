//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

extension Array where Element == Int {
    func closestStep(for value: Int) -> Step {
        if let index = firstIndex(where: { $0 >= value }) {
            let previousIndex = index - 1
            let foundValue = self[index]

            if foundValue == value {
                return .value(index: index, rounded: false)
            } else if previousIndex >= 0 {
                return .value(index: previousIndex, rounded: true)
            } else {
                return .lowerBound
            }
        } else {
            return .upperBound
        }
    }

    func value(for step: Step) -> Int? {
        return step.index.map { self[safe: $0] } ?? nil
    }
}
