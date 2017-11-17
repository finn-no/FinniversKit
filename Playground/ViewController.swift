//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol Viewable {
    associatedtype View
}

class ViewController<View: UIView>: UIViewController {
    init() { super.init(nibName: nil, bundle: nil) }
    required init?(coder aDecoder: NSCoder) { fatalError() }

    private var customView: View { return self.view as! View }

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
    }
}
