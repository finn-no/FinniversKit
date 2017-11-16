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

    override func loadView() {
        let view = View()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view = view
    }
}
