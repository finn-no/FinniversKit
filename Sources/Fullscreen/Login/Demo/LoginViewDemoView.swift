//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class LoginViewDemoView: UIView {
    private lazy var loginView: LoginView = {
        let loginView = LoginView()
        loginView.translatesAutoresizingMaskIntoConstraints = false
        return loginView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        loginView.model = LoginViewDefaultData()

        addSubview(loginView)

        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalTo: topAnchor),
            loginView.bottomAnchor.constraint(equalTo: bottomAnchor),
            loginView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
