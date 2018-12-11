//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    // MARK: - Public properties

    var height: BottomSheet.Height = .zero

    // MARK: - Private properties

    private var presentationController: BottomSheetPresentationController?
    private let interactionController: BottomSheetInteractionController
    private let animationController: BottomSheetAnimationController

    override init() {
        animationController = BottomSheetAnimationController()
        interactionController = BottomSheetInteractionController(animationController: animationController)
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        presentationController = BottomSheetPresentationController(presentedViewController: presented, presenting: presenting, interactionController: interactionController)
        presentationController?.height = height
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
