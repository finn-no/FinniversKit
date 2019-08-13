//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit

public class DemoViewController<View: UIView>: UIViewController {
    lazy var playgroundView: View = {
        let playgroundView = View(frame: view.frame)
        playgroundView.translatesAutoresizingMaskIntoConstraints = false
        playgroundView.backgroundColor = .milk
        return playgroundView
    }()

    lazy var miniToastView: MiniToastView = {
        let view = MiniToastView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel.text = "Double tap to dismiss"
        return view
    }()

    public override var prefersStatusBarHidden: Bool {
        return true
    }

    var hasDismissButton: Bool = false
    var usingDoubleTapToDismiss: Bool = false
    private var preferredInterfaceOrientation: UIInterfaceOrientationMask = .all
    private let constrainToBottomSafeArea: Bool
    private var bottomSheet: BottomSheet?

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return preferredInterfaceOrientation
    }

    // Normal behaviour
    public init(usingDoubleTapToDismiss: Bool = true,
                supportedInterfaceOrientations: UIInterfaceOrientationMask = .all,
                constrainToBottomSafeArea: Bool = true) {
        self.usingDoubleTapToDismiss = usingDoubleTapToDismiss
        self.preferredInterfaceOrientation = supportedInterfaceOrientations
        self.constrainToBottomSafeArea = constrainToBottomSafeArea
        super.init(nibName: nil, bundle: nil)
    }

    // Instantiate the view controller with a dismiss button
    public init(withDismissButton hasDismissButton: Bool, constrainToBottomSafeArea: Bool = true) {
        self.hasDismissButton = hasDismissButton
        self.constrainToBottomSafeArea = constrainToBottomSafeArea
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(playgroundView)
        view.backgroundColor = .milk

        let bottomAnchor = constrainToBottomSafeArea ? view.compatibleBottomAnchor : view.bottomAnchor

        NSLayoutConstraint.activate([
            playgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playgroundView.topAnchor.constraint(equalTo: view.compatibleTopAnchor),
            playgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        userInterfaceStyleDidChange()

        if hasDismissButton {
            let button = Button(style: .callToAction)
            button.setTitle("Dismiss", for: .normal)
            button.addTarget(self, action: #selector(didDoubleTap), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                button.bottomAnchor.constraint(equalTo: view.compatibleBottomAnchor, constant: -.veryLargeSpacing)
            ])
        } else if usingDoubleTapToDismiss {
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
            doubleTap.numberOfTapsRequired = 2
            view.addGestureRecognizer(doubleTap)
        }

        if !TestCheck.isTesting && playgroundView is Tweakable {
            let overlayView = CornerAnchoringView(withAutoLayout: true)
            overlayView.delegate = self
            view.addSubview(overlayView)
            overlayView.fillInSuperview()
        }
    }

    @objc func didDoubleTap() {
        State.lastSelectedIndexPath = nil
        dismiss(animated: true, completion: nil)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if State.shouldShowDismissInstructions {
            miniToastView.show(in: view)
            State.shouldShowDismissInstructions = false
        }
    }

    @objc private func userInterfaceStyleDidChange() {
        if let view = playgroundView as? UserInterfaceUpdatable {
            view.updateColors()
        }
    }
}

extension DemoViewController: CornerAnchoringViewDelegate {
    func cornerAnchoringViewDidSelectTweakButton(_ cornerAnchoringView: CornerAnchoringView) {
        if let tweakablePlaygroundView = playgroundView as? Tweakable {
            let tweakingController = TweakingOptionsTableViewController(options: tweakablePlaygroundView.tweakingOptions)
            tweakingController.delegate = self
            bottomSheet = BottomSheet(rootViewController: tweakingController, draggableArea: .everything)
            if let controller = bottomSheet {
                present(controller, animated: true)
            }
        }
    }
}

extension DemoViewController: TweakingOptionsTableViewControllerDelegate {
    func tweakingOptionsTableViewController(_ tweakingOptionsTableViewController: TweakingOptionsTableViewController, didDismissWithIndexPath indexPath: IndexPath) {
        bottomSheet?.state = .dismissed
    }
}
