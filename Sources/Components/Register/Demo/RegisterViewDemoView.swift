//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Munch
import UIKit

public class RegisterViewDemoView: UIView {
    private lazy var registerView: RegisterView = {
        let registerView = RegisterView()
        registerView.translatesAutoresizingMaskIntoConstraints = false
        return registerView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        registerView.model = RegisterViewDefaultData()

        addSubview(registerView)

        NSLayoutConstraint.activate([
            registerView.topAnchor.constraint(equalTo: topAnchor),
            registerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            registerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            registerView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
