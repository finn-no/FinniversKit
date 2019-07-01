//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

protocol MessageFormViewControllerDelegate: AnyObject {
    func messageFormViewControllerDidCancel(_ viewController: MessageFormViewController)
    func messageFormViewController(_ viewController: MessageFormViewController, didFinishWithText text: String, templateState: MessageFormTemplateState)
}

class MessageFormViewController: UIViewController {

    // MARK: - UI properties

    private lazy var wrapperView = UIView(withAutoLayout: true)
    private lazy var wrapperBottomConstraint = wrapperView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

    private lazy var messageFormView: MessageFormView = {
        let view = MessageFormView(viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    private lazy var toolbar: MessageFormToolbar = {
        let toolbar = MessageFormToolbar(viewModel: viewModel)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.delegate = self
        return toolbar
    }()

    private lazy var cancelButton = UIBarButtonItem(title: viewModel.cancelButtonText, style: .plain, target: self, action: #selector(cancelButtonTapped))
    private lazy var sendButton = UIBarButtonItem(title: viewModel.sendButtonText, style: .done, target: self, action: #selector(sendButtonTapped))

    // MARK: - Internal properties

    weak var delegate: MessageFormViewControllerDelegate?

    var hasUncommittedChanges: Bool {
        return messageFormView.text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
    }

    // MARK: - Private properties

    private let viewModel: MessageFormViewModel
    private var lastEnteredTemplate: String?

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
        wrapperView.addSubview(messageFormView)

        let messageFormBottomConstraint: NSLayoutConstraint

        if viewModel.showTemplateToolbar {
            messageFormBottomConstraint = messageFormView.bottomAnchor.constraint(equalTo: toolbar.topAnchor, constant: -.mediumSpacing)

            toolbar.showCustomizeButton = viewModel.showTemplateCustomizationButton
            wrapperView.addSubview(toolbar)
            NSLayoutConstraint.activate([
                toolbar.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
                toolbar.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
                toolbar.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor)
            ])
        } else {
            messageFormBottomConstraint = messageFormView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -.mediumSpacing)
        }

        NSLayoutConstraint.activate([
            messageFormView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            messageFormView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
            messageFormView.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            messageFormBottomConstraint,

            wrapperView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wrapperView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wrapperView.topAnchor.constraint(equalTo: view.topAnchor),
            wrapperBottomConstraint
        ])

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = messageFormView.becomeFirstResponder()
    }

    // MARK: - Private methods

    @objc private func cancelButtonTapped() {
        delegate?.messageFormViewControllerDidCancel(self)
    }

    @objc private func sendButtonTapped() {
        let messageText = messageFormView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastTemplate = lastEnteredTemplate?.trimmingCharacters(in: .whitespacesAndNewlines)
        let templateState: MessageFormTemplateState

        switch lastTemplate {
        case messageText:
            templateState = .template
        case .none:
            templateState = .custom
        case .some(let val):
            if messageText.contains(val) {
                templateState = .modifiedTemplate
            } else {
                templateState = .custom
            }
        }

        delegate?.messageFormViewController(self, didFinishWithText: messageText, templateState: templateState)
    }

    @objc func handleKeyboardNotification(_ notification: Notification) {
        guard let keyboardInfo = KeyboardNotificationInfo(notification) else { return }

        let keyboardVisible = keyboardInfo.action == .willShow
        let toolbarOffset = toolbar.offsetForToolbar(withKeyboardVisible: keyboardVisible)

        let keyboardIntersection = keyboardInfo.keyboardFrameEndIntersectHeight(inView: view)
        let offset = keyboardIntersection + toolbarOffset

        UIView.animateAlongsideKeyboard(keyboardInfo: keyboardInfo) { [weak self] in
            self?.wrapperBottomConstraint.constant = -offset
            self?.view.layoutIfNeeded()
        }
    }
}

extension MessageFormViewController: MessageFormViewDelegate {
    func messageFormView(_ view: MessageFormView, didEditMessageText text: String) {
        sendButton.isEnabled = text.count > 0
    }
}

extension MessageFormViewController: MessageFormToolbarDelegate {
    func messageFormToolbar(_ toolbar: MessageFormToolbar, didSelectMessageTemplate template: String) {
        let currentText = messageFormView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastTemplate = (lastEnteredTemplate ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        if currentText == lastTemplate || currentText.count == 0 {
            messageFormView.text = template
            lastEnteredTemplate = template
        } else {
            let alertController = UIAlertController(title: viewModel.replaceAlertTitle,
                                                    message: viewModel.replaceAlertMessage,
                                                    preferredStyle: .actionSheet)

            let cancelAction = UIAlertAction(title: viewModel.replaceAlertCancelText, style: .cancel)
            let replaceAction = UIAlertAction(title: viewModel.replaceAlertActionText, style: .default, handler: { [weak self] _ in
                self?.messageFormView.text = template
                self?.lastEnteredTemplate = template
            })

            alertController.addAction(replaceAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
    }
}
