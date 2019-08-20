import UIKit

@objc public protocol HorizontalSlideTransitionDelegate: AnyObject {
    @objc func horizontalSlideTransitionDidDismiss(_ horizontalSlideTransition: HorizontalSlideTransition)
}

public class HorizontalSlideTransition: NSObject, UIViewControllerTransitioningDelegate {

    @objc public weak var delegate: HorizontalSlideTransitionDelegate?

    private let containerPercentage: () -> CGFloat

    // MARK: - Init

    public init(containerPercentage: CGFloat) {
        self.containerPercentage = { return containerPercentage }
        super.init()
    }

    public init(containerPercentage: @escaping () -> CGFloat) {
        self.containerPercentage = containerPercentage
        super.init()
    }

    public override init() {
        self.containerPercentage = { return UIDevice.current.userInterfaceIdiom == .pad ? 0.60 : 0.85 }
        super.init()
    }

    // MARK: - UIViewControllerTransitioningDelegate

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = HorizontalSlideController(presentedViewController: presented, presenting: presenting, containerPercentageSupplier: containerPercentage)
        presentationController.dismissalDelegate = self
        return presentationController
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HorizontalSlideTransitionAnimator()
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HorizontalSlideTransitionAnimator()
    }
}

// MARK: - HorizontalSlideControllerDelegate

extension HorizontalSlideTransition: HorizontalSlideControllerDelegate {
    func horizontalSlideControllerDidDismiss(_ horizontalSlideController: HorizontalSlideController) {
        delegate?.horizontalSlideTransitionDidDismiss(self)
    }
}
