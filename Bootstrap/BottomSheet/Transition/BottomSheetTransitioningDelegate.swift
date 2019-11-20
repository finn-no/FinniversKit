//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    var presentationController: BottomSheetPresentationController?
    weak var presentationControllerDelegate: BottomSheetPresentationControllerDelegate?

    private let interactionController: BottomSheetInteractionController
    private let animationController: BottomSheetAnimationController

    private(set) lazy var dimView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .dimmingColor
        view.alpha = 0
        return view
    }()

    var height: BottomSheet.Height {
        didSet {
            presentationController?.height = height
        }
    }

    init(height: BottomSheet.Height) {
        self.height = height
        animationController = BottomSheetAnimationController()
        interactionController = BottomSheetInteractionController(animationController: animationController)
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        presentationController = BottomSheetPresentationController(presentedViewController: presented,
                                                                   presenting: presenting,
                                                                   height: height,
                                                                   interactionController: interactionController,
                                                                   dimView: dimView)
        presentationController?.presentationControllerDelegate = presentationControllerDelegate
        return presentationController
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animationController
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animationController
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}
