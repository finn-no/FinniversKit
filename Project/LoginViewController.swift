//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika
import TroikaDemoKit

class LoginViewController: UIViewController {

    fileprivate lazy var loginViewView: LoginView = {
        let view = LoginView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    fileprivate lazy var isKeyboardVisible: Bool = false
    fileprivate lazy var keyboardHeight: CGFloat = 0
    fileprivate let buttonHeight: CGFloat = 44

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.addSubview(loginViewView)

        view.backgroundColor = .milk
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: .UIKeyboardWillHide, object: nil)

        loginViewView.model = LoginViewData()

        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                loginViewView.topAnchor.constraint(equalTo: view.topAnchor),
                loginViewView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                loginViewView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .veryLargeSpacing + .largeSpacing),
                loginViewView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.veryLargeSpacing - .largeSpacing),
            ])
        } else {
            NSLayoutConstraint.activate([
                loginViewView.topAnchor.constraint(equalTo: view.topAnchor),
                loginViewView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                loginViewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                loginViewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        }
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

extension LoginViewController: LoginViewDelegate {
    func incompleteCredentials(in: LoginView) {
        let toast = ToastView(style: .error)
        toast.text = "Incomplete login credentials"
        toast.delegate = self

        guard let tabbarHeight = tabBarController?.tabBar.frame.height else {
            return
        }

        let offsetHeight = isKeyboardVisible ? keyboardHeight : tabbarHeight

        toast.presentFromBottom(view: view, animateOffset: offsetHeight, timeOut: 4)
    }

    func forgotPasswordButtonPressed(in: LoginView) {
        print("Forgot password button pressed!")
    }

    func loginButtonPressed(in: LoginView) {
        print("Login button pressed!")
    }

    func newUserButtonPressed(in: LoginView) {
        print("New user button pressed!")
    }

    func userTermsButtonPressed(in: LoginView) {
        print("User terms button pressed!")
    }
}

// MARK: - ToastViewDelegate
extension LoginViewController: ToastViewDelegate {
    func didTap(toastView: ToastView) {
        print("Toast view tapped!")
    }

    func didTapActionButton(button: UIButton, in toastView: ToastView) {
        print("Action button tapped!")
    }
}
