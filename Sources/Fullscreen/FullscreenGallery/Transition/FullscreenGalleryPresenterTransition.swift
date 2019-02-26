//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

class FullscreenGalleryPresenterTransition: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Private properties

    private let presenterDelegate: FullscreenGalleryTransitionPresenterDelegate
    private let destinationDelegate: FullscreenGalleryTransitionDestinationDelegate

    // MARK: - Init

    required init(withPresenter presenter: FullscreenGalleryTransitionPresenterDelegate, destination: FullscreenGalleryTransitionDestinationDelegate) {
        presenterDelegate = presenter
        destinationDelegate = destination
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

        guard let sourceView = presenterDelegate.imageViewForFullscreenGalleryTransition() else {
            return
        }

        guard let destinationView = destinationDelegate.imageViewForFullscreenGalleryTransition() else {
            return
        }

        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.setNeedsLayout()
        toViewController.view.layoutIfNeeded()

        let sourceFrame = sourceView.convert(sourceView.bounds, to: transitionContext.containerView)
        let destinationFrame = destinationView.convert(destinationView.bounds, to: transitionContext.containerView)

        let transitionView = createImageView(from: sourceView)
        transitionView.frame = sourceFrame

        sourceView.isHidden = true
        destinationView.isHidden = true

        transitionContext.containerView.addSubview(transitionView)

        destinationDelegate.prepareForTransition(presenting: true)
        let duration = transitionDuration(using: transitionContext)

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, animations: {
            transitionView.frame = destinationFrame
            self.destinationDelegate.performTransitionAnimation(presenting: true)
        }, completion: { _ in
            transitionView.removeFromSuperview()
            sourceView.isHidden = false
            destinationView.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    // MARK: - Private methods

    private func createImageView(from: UIImageView) -> UIImageView {
        let imageView = UIImageView(image: from.image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}
