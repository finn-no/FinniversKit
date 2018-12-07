//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

extension BottomSheetStateController {
    enum State {
        case expanded
        case compressed
        case dismissed
    }
}

class BottomSheetStateController {

    var state: State = .compressed
    var frame: CGRect = .zero
    var targetPosition: CGFloat {
        get {
            return targetPosition(for: state)
        }
    }
    
    private var minValue = 44 as CGFloat
    private var threshold = 75 as CGFloat

    func updateState(withTranslation translation: CGFloat) {
        state = nextState(forTranslation: translation, withCurrent: state, usingThreshold: threshold)
    }
}

private extension BottomSheetStateController {
    func nextState(forTranslation translation: CGFloat, withCurrent current: State, usingThreshold threshold: CGFloat) -> State {
        switch current {
        case .compressed:
            if translation < -threshold { return .expanded }
            else if translation > threshold { return .dismissed }
        case .expanded:
            if translation > threshold { return .compressed }
        case .dismissed:
            if translation < -threshold { return .compressed }
        }
        return current
    }

    func targetPosition(for state: State) -> CGFloat {
        switch state {
        case .compressed:
            return frame.height / 2
        case .expanded:
            return minValue
        case .dismissed:
            return frame.height
        }
    }
}
