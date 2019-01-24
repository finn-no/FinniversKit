//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class AnimatedFavoriteButtonDemoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let favoriteButton  = AnimatedFavoriteButton()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
    }
}
