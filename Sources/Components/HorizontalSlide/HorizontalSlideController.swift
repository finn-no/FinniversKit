import UIKit

final class HorizontalSlideController: UIPresentationController {
    
    // MARK: - Properties
    let containerPercentage: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 0.60 : 0.85

    lazy var dimmingView: UIView = {
        let dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)
        return dimmingView
    }()

    private var direction: UIRectEdge
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }

        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView.bounds.size)
        switch direction {
        case .right:
            frame.origin.x = containerView.frame.width * (1.0 - containerPercentage)
        case .bottom:
            frame.origin.y = containerView.frame.height * (1.0 - containerPercentage)
        default:
            frame.origin = .zero
        }
        return frame
    }
    
    // MARK: - Initializers
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, direction: UIRectEdge) {
        self.direction = direction
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
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
        if direction == .top || direction == .bottom {
            return CGSize(width: parentSize.width, height: parentSize.height * containerPercentage)
        } else if direction == .left || direction == .right {
            return CGSize(width: parentSize.width * containerPercentage, height: parentSize.height)
        } else {
            fatalError("targetEdge must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.")
        }
    }
}

// MARK: - Private
private extension HorizontalSlideController {
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
}
