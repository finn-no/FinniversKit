//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class ViewController<View: UIView>: UIViewController {
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

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(playgroundView)
        view.backgroundColor = .milk

        NSLayoutConstraint.activate([
            playgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playgroundView.topAnchor.constraint(equalTo: view.compatibleTopAnchor),
            playgroundView.bottomAnchor.constraint(equalTo: view.compatibleBottomAnchor),
        ])

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
    }

    @objc func didDoubleTap() {
        State.lastSelectedIndexPath = nil
        dismiss(animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if State.shouldShowDismissInstructions {
            miniToastView.show(in: view)
            State.shouldShowDismissInstructions = false
        }
    }
}
