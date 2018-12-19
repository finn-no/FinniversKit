//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

protocol BottomSheetGestureControllerDelegate: class {
    // Expects to get the current position of the bottom sheet
    func bottomSheetGestureControllerDidBeginGesture(_ controller: BottomSheetGestureController) -> CGPoint
    func bottomSheetGestureControllerDidChangeGesture(_ controller: BottomSheetGestureController)
    func bottomSheetGestureControllerDidEndGesture(_ controller: BottomSheetGestureController)
}

class BottomSheetGestureController {

    var position: CGPoint = .zero
    var velocity: CGPoint = .zero
    var translation: CGPoint = .zero
    weak var delegate: BottomSheetGestureControllerDelegate?

    private var initialPosition: CGPoint = .zero
    private lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
    private let presentedView: UIView
    private let containerView: UIView

    init(presentedView: UIView, containerView: UIView) {
        self.presentedView = presentedView
        self.containerView = containerView
        presentedView.addGestureRecognizer(panGesture)
    }
}

private extension BottomSheetGestureController {
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: containerView)
        self.translation = translation
        let velocity = gesture.velocity(in: containerView)
        self.velocity = velocity

        switch gesture.state {
        case .began:
            initialPosition = delegate?.bottomSheetGestureControllerDidBeginGesture(self) ?? .zero

        case .changed:
            position = initialPosition + translation
            delegate?.bottomSheetGestureControllerDidChangeGesture(self)

        case .ended:
            delegate?.bottomSheetGestureControllerDidEndGesture(self)

        default:
            return
        }
    }
}
