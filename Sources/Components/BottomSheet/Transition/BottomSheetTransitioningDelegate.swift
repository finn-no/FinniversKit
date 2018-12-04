//
//  BottomSheetTransition.swift
//  bottom-sheets
//
//  Created by Granheim Brustad , Henrik on 09/10/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit

class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    var presentationController: BottomSheetPresentationController?
    let interactionController: BottomSheetInteractionController
    let animationController: BottomSheetAnimationController

    override init() {
        animationController = BottomSheetAnimationController()
        interactionController = BottomSheetInteractionController(animationController: animationController)
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        presentationController = BottomSheetPresentationController(presentedViewController: presented, presenting: presenting, interactionController: interactionController)
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
