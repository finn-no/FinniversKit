//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

class RegisterViewDemoView: UIView, Demoable {
    private lazy var registerView: RegisterView = {
        let registerView = RegisterView()
        registerView.translatesAutoresizingMaskIntoConstraints = false
        return registerView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        registerView.model = RegisterViewDefaultData()

        addSubview(registerView)

        NSLayoutConstraint.activate([
            registerView.topAnchor.constraint(equalTo: topAnchor),
            registerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            registerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            registerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
