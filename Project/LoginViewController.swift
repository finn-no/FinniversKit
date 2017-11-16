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
        view.delegate = self
        return view
    }()

    fileprivate lazy var isKeyboardVisible: Bool = false
    fileprivate lazy var keyboardHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.addSubview(loginScreenView)

        view.backgroundColor = .milk
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: .UIKeyboardWillHide, object: nil)

        loginScreenView.model = LoginScreenData()

        NSLayoutConstraint.activate([
            loginScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            loginScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loginScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    @objc func keyboardWillAppear(notification: NSNotification) {
        isKeyboardVisible = true
        if let userInfo = notification.userInfo {
            if let keyboardFrame: NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                keyboardHeight = keyboardRectangle.height
            }
        }
    }

    @objc func keyboardWillDisappear() {
        isKeyboardVisible = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

extension LoginViewController: LoginScreenDelegate {
    func incompleteCredentials(in: LoginScreen) {
        let toast = ToastView(delegate: self)
        toast.presentable = ToastDataModel.error

        guard let tabbarHeight = tabBarController?.tabBar.frame.height else {
            return
        }

        let offsetHeight = isKeyboardVisible ? keyboardHeight : tabbarHeight

        toast.presentFromBottom(view: view, animateOffset: offsetHeight, timeOut: 4)
    }

    func forgotPasswordButtonPressed(in: LoginScreen) {
        print("Forgot password button pressed!")
    }

    func loginButtonPressed(in: LoginScreen) {
        print("Login button pressed!")
    }

    func newUserButtonPressed(in: LoginScreen) {
        print("New user button pressed!")
    }

    func userTermsButtonPressed(in: LoginScreen) {
        print("User terms button pressed!")
    }
}
