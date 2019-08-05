//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

protocol MessageFormViewControllerDelegate: AnyObject {
    func messageFormViewControllerDidCancel(_ viewController: MessageFormViewController)
    func messageFormViewController(_ viewController: MessageFormViewController,
                                   didFinishWithText text: String,
                                   templateState: MessageFormTemplateState,
                                   template: MessageFormTemplate?)
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

    var toastPresenterView: UIView {
        return messageFormView
    }

    var inputEnabled: Bool {
        get { return messageFormView.inputEnabled }
        set { messageFormView.inputEnabled = newValue }
    }

    // MARK: - Private properties

    private let viewModel: MessageFormViewModel
    private var lastUsedTemplate: MessageFormTemplate?

    private lazy var safeAreaHeight: CGFloat = {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        } else {
            return 0
        }
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
        wrapperView.addSubview(messageFormView)

        let messageFormBottomConstraint: NSLayoutConstraint

        if viewModel.showTemplateToolbar {
            messageFormBottomConstraint = messageFormView.bottomAnchor.constraint(equalTo: toolbar.topAnchor)

            wrapperView.addSubview(toolbar)
            NSLayoutConstraint.activate([
                toolbar.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
                toolbar.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
                toolbar.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor)
            ])
        } else {
            messageFormBottomConstraint = messageFormView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor)
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

        updateWrapperViewConstraint(withKeyboardVisible: false, keyboardOffset: 0)

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
        let lastTemplateText = lastUsedTemplate?.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let templateState: MessageFormTemplateState
        let usedTemplate: MessageFormTemplate?

        switch lastTemplateText {
        case messageText:
            templateState = .template
            usedTemplate = lastUsedTemplate
        case .none:
            templateState = .custom
            usedTemplate = nil
        case .some(let val):
            if messageText.contains(val) {
                templateState = .modifiedTemplate
                usedTemplate = lastUsedTemplate
            } else {
                templateState = .custom
                usedTemplate = nil
            }
        }

        delegate?.messageFormViewController(self, didFinishWithText: messageText, templateState: templateState, template: usedTemplate)
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
        var offset: CGFloat = keyboardOffset

        if viewModel.showTemplateToolbar {
            offset += toolbar.offsetForToolbar(withKeyboardVisible: keyboardVisible)
        } else {
            offset += safeAreaHeight
        }

        wrapperBottomConstraint.constant = -offset
    }
}

extension MessageFormViewController: MessageFormViewDelegate {
    func messageFormView(_ view: MessageFormView, didEditMessageText text: String) {
        sendButton.isEnabled = text.count > 0
    }
}

extension MessageFormViewController: MessageFormToolbarDelegate {
    func messageFormToolbar(_ toolbar: MessageFormToolbar, didSelectMessageTemplate template: MessageFormTemplate) {
        let currentText = messageFormView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastTemplateText = (lastUsedTemplate?.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        if currentText == lastTemplateText || currentText.count == 0 {
            messageFormView.text = template.text
            lastUsedTemplate = template
        } else {
            let alertStyle: UIAlertController.Style = UIDevice.isIPad() ? .alert : .actionSheet
            let alertController = UIAlertController(title: viewModel.replaceAlertTitle,
                                                    message: viewModel.replaceAlertMessage,
                                                    preferredStyle: alertStyle)

            let cancelAction = UIAlertAction(title: viewModel.replaceAlertCancelText, style: .cancel)
            let replaceAction = UIAlertAction(title: viewModel.replaceAlertActionText, style: .default, handler: { [weak self] _ in
                self?.messageFormView.text = template.text
                self?.lastUsedTemplate = template
            })

            alertController.addAction(replaceAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
    }

    func messageFormToolbarTappedCustomizeButton(_ toolbar: MessageFormToolbar) {
        guard let templateStore = viewModel.messageTemplateStore else { return }

        let vc = MessageTemplateEditViewController(templateStore: templateStore)
        navigationController?.pushViewController(vc, animated: true)
    }
}
