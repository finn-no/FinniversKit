//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class LoginEntryDemoPageViewController: UIViewController {
    let page: LoginEntryDemoData.Page

    init(page: LoginEntryDemoData.Page) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private lazy var loginEntryView: LoginEntryView = {
        let loginEntryView = LoginEntryView(withAutoLayout: true)
        loginEntryView.configure(with: page.data)

        return loginEntryView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(loginEntryView)
        loginEntryView.fillInSuperview()
    }

    func setup() {
        tabBarItem = UITabBarItem(title: nil, image: UIImage(named: page.asset), selectedImage: nil)
    }
}
