//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

extension BottomSheetStateController {
    enum State {
        case expanded
        case compact
        case dismissed
    }
}

class BottomSheetStateController {

    var state: State = .compact
    var frame: CGRect = .zero
    var height: BottomSheet.Height = .zero

    var targetPosition: CGPoint {
        return targetPosition(for: state)
    }

    private let threshold: CGFloat = 75

    func updateState(withTranslation translation: CGPoint) {
        state = nextState(forTranslation: translation, withCurrent: state, usingThreshold: threshold)
    }
}

private extension BottomSheetStateController {
    func nextState(forTranslation translation: CGPoint, withCurrent current: State, usingThreshold threshold: CGFloat) -> State {
        switch current {
        case .compact:
            if translation.y < -threshold {
                return .expanded
            } else if translation.y > threshold { return .dismissed }
        case .expanded:
            if translation.y > threshold { return .compact }
        case .dismissed:
            if translation.y < -threshold { return .compact }
        }
        return current
    }

    func targetPosition(for state: State) -> CGPoint {
        switch state {
        case .compact:
            return CGPoint(x: 0, y: frame.height - height.compact)
        case .expanded:
            return CGPoint(x: 0, y: frame.height - height.expanded)
        case .dismissed:
            return CGPoint(x: 0, y: frame.height)
        }
    }
}
