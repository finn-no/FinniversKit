//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class HorizontalSlideDemoViewController: UIViewController {
    lazy var transitionDelegate: HorizontalSlideTransitionDelegate = {
        return HorizontalSlideTransitionDelegate()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .milk
    }
}
