//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

protocol BottomSheetGestureControllerDelegate: class {
    // Expects to get the current y position of the bottom sheet
    func bottomSheetGestureControllerDidBeginGesture(_ controller: BottomSheetGestureController) -> CGFloat
    func bottomSheetGestureControllerDidChangeGesture(_ controller: BottomSheetGestureController)
    func bottomSheetGestureControllerDidEndGesture(_ controller: BottomSheetGestureController)
}

class BottomSheetGestureController {

    var position: CGFloat = 0
    var velocity: CGFloat = 0
    var translation: CGFloat = 0
    weak var delegate: BottomSheetGestureControllerDelegate?

    private var initialConstant: CGFloat = 0
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
        self.translation = translation.y
        let velocity = gesture.velocity(in: containerView)
        self.velocity = velocity.y

        switch gesture.state {
        case .began:
            initialConstant = delegate?.bottomSheetGestureControllerDidBeginGesture(self) ?? 0

        case .changed:
            position = initialConstant + translation.y
            delegate?.bottomSheetGestureControllerDidChangeGesture(self)

        case .ended:
            delegate?.bottomSheetGestureControllerDidEndGesture(self)

        default:
            return
        }
    }
}
