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

        if playgroundView is Tweakable {
            guard let window = UIApplication.shared.keyWindow else { return }
            let button = EasterEggButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            window.addSubview(button)
            NSLayoutConstraint.activate([
                button.bottomAnchor.constraint(equalTo: window.compatibleBottomAnchor, constant: -.largeSpacing),
                button.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -.largeSpacing),
                button.widthAnchor.constraint(equalToConstant: .veryLargeSpacing),
                button.heightAnchor.constraint(equalToConstant: .veryLargeSpacing)
                ])
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
}
