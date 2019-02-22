//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

class FullscreenGalleryDismissalTransition: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Private properties

    private let presenterDelegate: FullscreenGalleryTransitionPresenterDelegate
    private let destinationDelegate: FullscreenGalleryTransitionDestinationDelegate

    // MARK: - Init

    required init(toPresenter presenter: FullscreenGalleryTransitionPresenterDelegate, fromDestination destination: FullscreenGalleryTransitionDestinationDelegate) {
        presenterDelegate = presenter
        destinationDelegate = destination
        super.init()
    }

    // MARK: - UIViewControllerAnimatedTransitioning

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.75
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let presenterViewController = transitionContext.viewController(forKey: .to) else {
            return
        }

        let presenterView = presenterDelegate.viewForFullscreenGalleryTransition()
        let presenterFrame = presenterView.convert(presenterView.bounds, to: transitionContext.containerView)

        let presentedView = destinationDelegate.viewForFullscreenGalleryTransition()
        let presentedFrame = presentedView.convert(presentedView.bounds, to: transitionContext.containerView)

        let transitionView = presentedView.snapshotView(afterScreenUpdates: true)!
        transitionView.frame = presentedFrame
        transitionContext.containerView.addSubview(transitionView)

        presenterView.isHidden = true
        presentedView.isHidden = true

        destinationDelegate.prepareForTransition(presenting: false)
        let duration = transitionDuration(using: transitionContext)

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
            transitionView.frame = presenterFrame
            self.destinationDelegate.performTransitionAnimation(presenting: false)
        }, completion: { _ in
            transitionView.removeFromSuperview()
            presenterView.isHidden = false
            presentedView.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
