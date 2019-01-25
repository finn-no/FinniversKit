//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class AnimatedFavoriteButtonDemoViewController: UIViewController {
    lazy var label: Label = {
        let tapMeLabel = Label(style: .title2)
        tapMeLabel.translatesAutoresizingMaskIntoConstraints = false
        tapMeLabel.text = "Tap me ⤴️"
        tapMeLabel.textAlignment = .center
        return tapMeLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])

        view.backgroundColor = .white

        let favoriteButton  = AnimatedFavoriteButton()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
    }
}
