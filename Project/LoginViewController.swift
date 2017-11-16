//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika
import TroikaDemoKit

class LoginViewController: UIViewController {

    fileprivate lazy var loginScreenView: LoginScreen = {
        let view = LoginScreen(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.addSubview(loginScreenView)

        view.backgroundColor = .milk

        loginScreenView.model = LoginScreenData()

        NSLayoutConstraint.activate([
            loginScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            loginScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loginScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
