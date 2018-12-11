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

    var size: BottomSheet.Size = .zero
    var state: State = .compact
    var frame: CGRect = .zero
    var targetPosition: CGFloat {
        return targetPosition(for: state)
    }

    private var threshold: CGFloat = 75

    func updateState(withTranslation translation: CGFloat) {
        state = nextState(forTranslation: translation, withCurrent: state, usingThreshold: threshold)
    }
}

private extension BottomSheetStateController {
    func nextState(forTranslation translation: CGFloat, withCurrent current: State, usingThreshold threshold: CGFloat) -> State {
        switch current {
        case .compact:
            if translation < -threshold { return .expanded }
            else if translation > threshold { return .dismissed }
        case .expanded:
            if translation > threshold { return .compact }
        case .dismissed:
            if translation < -threshold { return .compact }
        }
        return current
    }

    func targetPosition(for state: State) -> CGFloat {
        switch state {
        case .compact:
            return frame.height - size.compact
        case .expanded:
            return frame.height - (size.expanded ?? 0)
        case .dismissed:
            return frame.height
        }
    }
}
