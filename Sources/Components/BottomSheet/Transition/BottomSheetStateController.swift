//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

class BottomSheetStateController {

    var frame: CGRect = .zero
    var state: BottomSheet.State
    var height: BottomSheet.Height

    var targetPosition: CGPoint {
        return targetPosition(for: state)
    }

    var expandedPosition: CGPoint {
        return CGPoint(x: 0, y: frame.height - height.expanded)
    }

    var compactPosition: CGPoint? {
        guard let height = height.compact else { return nil }
        return CGPoint(x: 0, y: frame.height - height)
    }

    private let threshold: CGFloat = 75

    init(height: BottomSheet.Height) {
        self.height = height
        self.state = height.compact == nil ? .expanded : .compact
    }

    func updateState(withTranslation translation: CGPoint) {
        state = nextState(forTranslation: translation, withCurrent: state, usingThreshold: threshold)
    }
}

private extension BottomSheetStateController {
    func nextState(forTranslation translation: CGPoint, withCurrent current: BottomSheet.State, usingThreshold threshold: CGFloat) -> BottomSheet.State {
        switch current {
        case .compact:
            if translation.y < -threshold {
                return .expanded
            } else if translation.y > threshold {
                return .dismissed
            }
        case .expanded:
            if translation.y > threshold {
                return height.compact == nil ? .dismissed : .compact
            }
        case .dismissed:
            if translation.y < -threshold {
                return .compact
            }
        }
        return current
    }

    func targetPosition(for state: BottomSheet.State) -> CGPoint {
        switch state {
        case .compact:
            return compactPosition ?? .zero
        case .expanded:
            return expandedPosition
        case .dismissed:
            return CGPoint(x: 0, y: frame.height)
        }
    }
}
