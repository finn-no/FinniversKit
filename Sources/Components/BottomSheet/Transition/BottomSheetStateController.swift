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

    enum Size: CGFloat {
        case normal = 510
        case large = 570
    }
}

class BottomSheetStateController {

    var state: State = .compressed
    var frame: CGRect = .zero
    var targetPosition: CGFloat {
        return targetPosition(for: state)
    }

    var size: Size {
        return UIScreen.main.bounds.height >= 812 ? .large : .normal
    }

    private var minValue: CGFloat = 44
    private var threshold: CGFloat = 75

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
            return frame.height - size.rawValue
        case .expanded:
            return minValue
        case .dismissed:
            return frame.height
        }
    }
}
