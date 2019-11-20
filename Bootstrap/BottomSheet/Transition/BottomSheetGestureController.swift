//
//  Copyright © 2018 FINN.no. All rights reserved.
//

protocol BottomSheetGestureControllerDelegate: AnyObject {
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
    private lazy var panGesture: BottomSheetPanGestureRecognizer = {
        let panGesture = BottomSheetPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        panGesture.draggableRect = bottomSheet.draggableRect
        return panGesture
    }()
    private let bottomSheet: BottomSheet
    private let containerView: UIView

    init(bottomSheet: BottomSheet, containerView: UIView) {
        self.bottomSheet = bottomSheet
        self.containerView = containerView
        bottomSheet.view.addGestureRecognizer(panGesture)
    }
}

private extension BottomSheetGestureController {
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        self.translation = gesture.translation(in: containerView)
        self.velocity = gesture.velocity(in: containerView)

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

private class BottomSheetPanGestureRecognizer: UIPanGestureRecognizer {
    var draggableRect: CGRect?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let firstTouch = touches.first, let view = view, let draggableRect = draggableRect else {
            return super.touchesBegan(touches, with: event)
        }

        let touchPoint = firstTouch.location(in: view)
        if draggableRect.contains(touchPoint) {
            super.touchesBegan(touches, with: event)
        }
    }
}
