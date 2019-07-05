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

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return preferredInterfaceOrientation
    }

    // Normal behaviour
    public init(usingDoubleTapToDismiss: Bool = true,
                supportedInterfaceOrientations: UIInterfaceOrientationMask = .all) {
        self.usingDoubleTapToDismiss = usingDoubleTapToDismiss
        self.preferredInterfaceOrientation = supportedInterfaceOrientations
        super.init(nibName: nil, bundle: nil)
    }

    // Instantiate the view controller with a dismiss button
    public init(withDismissButton hasDismissButton: Bool) {
        self.hasDismissButton = hasDismissButton
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(playgroundView)
        view.backgroundColor = .milk

        NSLayoutConstraint.activate([
            playgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playgroundView.topAnchor.constraint(equalTo: view.compatibleTopAnchor),
            playgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
