//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika

public class LoginViewPlayground: UIView {

    private lazy var loginView: LoginView = {
        return LoginView(withAutoLayout: true)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        loginView.model = LoginViewDefaultData()

        addSubview(loginView)
        loginView.fillInSuperview()
    }
}
