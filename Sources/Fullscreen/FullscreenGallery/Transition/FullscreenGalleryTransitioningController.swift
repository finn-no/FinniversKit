//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

public class FullscreenGalleryTransitioningController: NSObject, UIViewControllerTransitioningDelegate {

    // MARK: - Public properties

    public weak var presenterDelegate: FullscreenGalleryTransitionPresenterDelegate?

    /// - Note:
    ///   The destination delegate defaults to the UIViewController being presented, if it conforms to
    ///   FullscreenGalleryTransitionDestinationDelegate. This behaviour can be overridden by setting
    ///   this property.
    public weak var destinationDelegate: FullscreenGalleryTransitionDestinationDelegate?

    // MARK: - Init

    public init(withPresenterDelegate presenterDelegate : FullscreenGalleryTransitionPresenterDelegate) {
        super.init()
        self.presenterDelegate = presenterDelegate
    }

    // MARK: - UIViewControllerTransitioningDelegate

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let presenterDelegate = self.presenterDelegate else {
            print("Cannot perform fullscreen gallery transition. The source delegate has not been set.")
            return nil
        }

        let fallbackDelegate = presented as? FullscreenGalleryTransitionDestinationDelegate
        guard let destinationDelegate = self.destinationDelegate ?? fallbackDelegate else {
            print("Cannot perform fullscreen gallery transition. No destination delegate has been set, and the " +
                  "presented UIViewController cannot be used as fallback.")
            return nil
        }

        let transition = FullscreenGalleryPresenterTransition(withPresenter: presenterDelegate, destination: destinationDelegate)
        return transition
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
