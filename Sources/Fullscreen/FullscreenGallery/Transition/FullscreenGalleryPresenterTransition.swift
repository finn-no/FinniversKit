//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

class FullscreenGalleryPresenterTransition: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Private properties

    private let sourceDelegate: FullscreenGalleryTransitionSourceDelegate
    private let destinationDelegate: FullscreenGalleryTransitionDestinationDelegate

    // MARK: - Init

    required init(withSource source: FullscreenGalleryTransitionSourceDelegate, destination: FullscreenGalleryTransitionDestinationDelegate) {
        self.sourceDelegate = source
        self.destinationDelegate = destination
        super.init()
    }

    // MARK: - UIViewControllerAnimatedTransitioning

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.75
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }

        let sourceView = sourceDelegate.viewForFullscreenGalleryTransition()
        let sourceFrame = sourceView.convert(sourceView.bounds, to: transitionContext.containerView)

        let destinationView = destinationDelegate.viewForFullscreenGalleryTransition()
        let destinationFrame = destinationView.convert(destinationView.bounds, to: transitionContext.containerView)

        let transitionView = destinationView.snapshotView(afterScreenUpdates: true)!
        transitionView.frame = sourceFrame

        sourceView.isHidden = true
        destinationView.isHidden = true

        transitionContext.containerView.addSubview(toViewController.view)
        transitionContext.containerView.addSubview(transitionView)

        destinationDelegate.prepareForTransition()
        let duration = self.transitionDuration(using: transitionContext)

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, animations: {
            transitionView.frame = destinationFrame
            self.destinationDelegate.performTransitionAnimation()
        }, completion: { _ in
            transitionView.removeFromSuperview()
            sourceView.isHidden = false
            destinationView.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
