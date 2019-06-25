//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

class MessageFormViewController: UIViewController {

    // MARK: - UI properties

    private lazy var messageFormView: MessageFormView = {
        let view = MessageFormView(viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var toolbarBottomConstraint = toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    private lazy var toolbar: MessageFormToolbar = {
        let toolbar = MessageFormToolbar(viewModel: viewModel)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.delegate = self
        return toolbar
    }()

    private lazy var cancelButton = UIBarButtonItem(title: viewModel.cancelButtonText, style: .plain, target: self, action: #selector(cancelButtonTapped))
    private lazy var sendButton = UIBarButtonItem(title: viewModel.sendButtonText, style: .done, target: self, action: #selector(sendButtonTapped))

    // MARK: - Private properties

    private let viewModel: MessageFormViewModel

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public required init(viewModel: MessageFormViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.titleText

        navigationItem.setLeftBarButton(cancelButton, animated: false)
        navigationItem.setRightBarButton(sendButton, animated: false)

        view.addSubview(messageFormView)
        view.addSubview(toolbar)

        NSLayoutConstraint.activate([
            messageFormView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageFormView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageFormView.topAnchor.constraint(equalTo: view.topAnchor),

            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.topAnchor.constraint(equalTo: messageFormView.bottomAnchor, constant: .mediumSpacing),
            toolbarBottomConstraint
        ])

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = messageFormView.becomeFirstResponder()
    }

    // MARK: - Private methods

    @objc private func cancelButtonTapped() {

    }

    @objc private func sendButtonTapped() {

    }

    @objc func handleKeyboardNotification(_ notification: Notification) {
        guard let keyboardInfo = KeyboardNotificationInfo(notification) else { return }

        let keyboardIntersection = keyboardInfo.keyboardFrameEndIntersectHeight(inView: view)

        UIView.animateAlongsideKeyboard(keyboardInfo: keyboardInfo) { [weak self] in
            self?.toolbarBottomConstraint.constant = -keyboardIntersection
            self?.view.layoutIfNeeded()
        }
    }
}

extension MessageFormViewController: MessageFormToolbarDelegate {
    func messageFormToolbar(_ toolbar: MessageFormToolbar, didSelectMessageTemplate template: String) {
        messageFormView.text = template
    }
}
