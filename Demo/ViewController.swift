//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class ViewController<View: UIView>: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let playgroundView = View()
        playgroundView.translatesAutoresizingMaskIntoConstraints = false
        playgroundView.backgroundColor = .white
        view.addSubview(playgroundView)

        NSLayoutConstraint.activate([
            playgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            playgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
    }

    @objc func didDoubleTap() {
        dismiss(animated: true, completion: nil)
    }
}
