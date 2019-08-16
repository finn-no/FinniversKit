import UIKit

protocol HorizontalSlideControllerDelegate: AnyObject {
    func horizontalSlideControllerDidDismiss(_ horizontalSlideController: HorizontalSlideController)
}

/// Used by the HorizontalSlideTransition when using `modalPresentationStyle = .custom`.
class HorizontalSlideController: UIPresentationController {
    weak var dismissalDelegate: HorizontalSlideControllerDelegate?

    // MARK: - Properties

    private let containerPercentage: CGFloat

    private lazy var dimmingView: UIView = {
        let dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleDismissGesture))
        dimmingView.addGestureRecognizer(recognizer)

        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleDismissGesture))
        swipeGestureRecognizer.direction = .right
        dimmingView.addGestureRecognizer(swipeGestureRecognizer)

        return dimmingView
    }()

    // MARK: - Init

    /// Initializes and returns a presentation controller for transitioning between the specified view controllers with a width percentage for the container.
    ///
    /// - Parameters:
    ///   - presentedViewController: The view controller being presented modally.
    ///   - presentingViewController: The view controller whose content represents the starting point of the transition.
    ///   - containerPercentage: The width of the container for the view controller being presented modally
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, containerPercentage: CGFloat) {
        self.containerPercentage = containerPercentage
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        self.containerPercentage = UIDevice.current.userInterfaceIdiom == .pad ? 0.60 : 0.85
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    // MARK: - Overrides

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }

        var frame = CGRect.zero
        frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView.bounds.size)
        frame.origin.x = containerView.frame.width * (1.0 - containerPercentage)
        return frame
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        containerView.insertSubview(dimmingView, at: 0)
        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }

    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width * containerPercentage, height: parentSize.height)
    }

    // MARK: - Private

    @objc private func handleDismissGesture() {
        presentingViewController.dismiss(animated: true)
        dismissalDelegate?.horizontalSlideControllerDidDismiss(self)
    }
}
