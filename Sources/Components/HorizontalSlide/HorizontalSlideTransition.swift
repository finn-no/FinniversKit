import UIKit

@objc public protocol HorizontalSlideTransitionDelegate: AnyObject {
    @objc func horizontalSlideTransitionDidDismiss(_ horizontalSlideTransition: HorizontalSlideTransition)
}

public class HorizontalSlideTransition: NSObject, UIViewControllerTransitioningDelegate {

    public struct ContainerSize {

        let portrait: CGFloat
        let landscape: CGFloat

        var percentage: CGFloat {
            return UIDevice.current.orientation.isLandscape ? self.landscape : self.portrait
        }

        public init(portrait: CGFloat, landscape: CGFloat? = nil) {
            self.portrait = portrait
            self.landscape = landscape ?? portrait
        }

        public static var `default`: ContainerSize {
            if UIDevice.isIPad() {
                return ContainerSize(portrait: 0.60)
            } else {
                return ContainerSize(portrait: 0.85)
            }
        }
    }

    @objc public weak var delegate: HorizontalSlideTransitionDelegate?

    private let containerSize: ContainerSize

    // MARK: - Init

    public init(size containerSize: ContainerSize) {
        self.containerSize = containerSize
        super.init()
    }

    public override init() {
        self.containerSize = .default
        super.init()
    }

    // MARK: - UIViewControllerTransitioningDelegate

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = HorizontalSlideController(presentedViewController: presented, presenting: presenting, containerSize: containerSize)
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
