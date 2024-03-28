//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

protocol MessageFormViewControllerDelegate: AnyObject {
    func messageFormViewControllerDidCancel(_ viewController: MessageFormViewController)
    func messageFormViewController(_ viewController: MessageFormViewController,
                                   didFinishWithText text: String,
                                   telephone: String)
}

class MessageFormViewController: UIViewController {

    // MARK: - UI properties

    private lazy var wrapperView = UIView(withAutoLayout: true)
    private lazy var wrapperBottomConstraint = wrapperView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

    private lazy var messageInputTextView: MessageInputTextView = {
        let view = MessageInputTextView(disclaimerText: viewModel.disclaimerText, additionalInfoText: viewModel.transparencyText, messageLabel: viewModel.messageText, messageHint: viewModel.messageHint, telephoneLabel: viewModel.telephoneText, telephoneHint: viewModel.telephoneHint)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    private lazy var cancelButton = UIBarButtonItem(title: viewModel.cancelButtonText, style: .plain, target: self, action: #selector(cancelButtonTapped))
    private lazy var sendButton = UIBarButtonItem(title: viewModel.sendButtonText, style: .done, target: self, action: #selector(sendButtonTapped))

    // MARK: - Internal properties

    weak var delegate: MessageFormViewControllerDelegate?

    var toastPresenterView: UIView {
        return messageInputTextView
    }

    var inputEnabled: Bool {
        get { return messageInputTextView.inputEnabled }
        set { messageInputTextView.inputEnabled = newValue }
    }

    var hasUncommittedChanges: Bool {
        return messageInputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
    }

    // MARK: - Private properties

    private let viewModel: MessageFormViewModel

    private lazy var safeAreaHeight: CGFloat = {
        return UIApplication.shared.connectedScenes.keyWindow?.safeAreaInsets.bottom ?? 0
    }()

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
        sendButton.isEnabled = false

        view.addSubview(wrapperView)
        wrapperView.addSubview(messageInputTextView)

        NSLayoutConstraint.activate([
            messageInputTextView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            messageInputTextView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
            messageInputTextView.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            messageInputTextView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor),

            wrapperView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wrapperView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wrapperView.topAnchor.constraint(equalTo: view.topAnchor),
            wrapperBottomConstraint
        ])

        updateWrapperViewConstraint(withKeyboardVisible: false, keyboardOffset: 0)

    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = messageInputTextView.becomeFirstResponder()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // We need to unregister the keyboard listeners, as we would otherwise get notified
        // and we'd wrongly adjust when the keyboard appears in pushed view controllers
        unregisterKeyboardNotifications()
    }

    // MARK: - Private methods

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    private func unregisterKeyboardNotifications() {
        //swiftlint:disable:next notification_center_detachment
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func cancelButtonTapped() {
        delegate?.messageFormViewControllerDidCancel(self)
    }

    @objc private func sendButtonTapped() {
        let messageText = messageInputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let telephoneText = messageInputTextView.telephone.trimmingCharacters(in: .whitespacesAndNewlines)

        delegate?.messageFormViewController(self, didFinishWithText: messageText, telephone: telephoneText)
    }

    @objc func handleKeyboardNotification(_ notification: Notification) {
        guard let keyboardInfo = KeyboardNotificationInfo(notification) else { return }

        let keyboardVisible = keyboardInfo.action == .willShow
        let keyboardIntersection = keyboardInfo.keyboardFrameEndIntersectHeight(inView: view)

        UIView.animateAlongsideKeyboard(keyboardInfo: keyboardInfo) { [weak self] in
            self?.updateWrapperViewConstraint(withKeyboardVisible: keyboardVisible, keyboardOffset: keyboardIntersection)
            self?.view.layoutIfNeeded()
        }
    }

    private func updateWrapperViewConstraint(withKeyboardVisible keyboardVisible: Bool, keyboardOffset: CGFloat) {
        wrapperBottomConstraint.constant = -(keyboardOffset + safeAreaHeight)
    }
}

extension MessageFormViewController: MessageInputTextViewDelegate {
    func messageFormView(_ view: MessageInputTextView, didEditMessageText text: String) {
        sendButton.isEnabled = text.count > 0
    }
}
