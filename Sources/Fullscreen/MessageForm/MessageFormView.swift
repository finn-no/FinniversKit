//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol MessageFormViewDelegate: AnyObject {
    func messageFormView(_ view: MessageFormView, didEditMessageText text: String)
    func messageFormView(_ view: MessageFormView, didSelectMessageTemplate template: MessageFormTemplate)
}

public final class MessageFormView: UIView {

    // MARK: - UI properties

    private lazy var wrapperView = UIView(withAutoLayout: true)
    private lazy var wrapperBottomConstraint = wrapperView.bottomAnchor.constraint(equalTo: bottomAnchor)

    private lazy var messageInputTextView: MessageInputTextView = {
        let view = MessageInputTextView(additionalInfoText: viewModel.transparencyText)
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

    // MARK: - Public properties

    public weak var delegate: MessageFormViewDelegate?

    public var text: String {
        get { messageInputTextView.text }
        set { messageInputTextView.text = newValue }
    }

    public var toastPresenterView: UIView {
        return messageInputTextView
    }

    public var inputEnabled: Bool {
        get { return messageInputTextView.inputEnabled }
        set { messageInputTextView.inputEnabled = newValue }
    }

    public var hasUncommittedChanges: Bool {
        return messageInputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
    }

    // MARK: - Private properties

    private let viewModel: MessageFormViewModel

    private lazy var safeAreaHeight: CGFloat = {
        UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }()

    // MARK: - Init

    public required init(viewModel: MessageFormViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    deinit {
        // We need to unregister the keyboard listeners, as we would otherwise get notified
        // and we'd wrongly adjust when the keyboard appears in pushed view controllers
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Overrides

    public override func becomeFirstResponder() -> Bool {
        return messageInputTextView.becomeFirstResponder()
    }

    // MARK: - Private methods

    private func setup() {
        addSubview(wrapperView)
        wrapperView.addSubview(messageInputTextView)

        let messageFormBottomConstraint: NSLayoutConstraint

        if viewModel.showTemplateToolbar {
            messageFormBottomConstraint = messageInputTextView.bottomAnchor.constraint(equalTo: toolbar.topAnchor)

            wrapperView.addSubview(toolbar)
            NSLayoutConstraint.activate([
                toolbar.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
                toolbar.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
                toolbar.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor)
            ])
        } else {
            messageFormBottomConstraint = messageInputTextView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor)
        }

        NSLayoutConstraint.activate([
            messageInputTextView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            messageInputTextView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
            messageInputTextView.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            messageFormBottomConstraint,

            wrapperView.leadingAnchor.constraint(equalTo: leadingAnchor),
            wrapperView.trailingAnchor.constraint(equalTo: trailingAnchor),
            wrapperView.topAnchor.constraint(equalTo: topAnchor),
            wrapperBottomConstraint
        ])

        updateWrapperViewConstraint(withKeyboardVisible: false, keyboardOffset: 0)
        toolbar.reloadData()
        registerForKeyboardNotifications()
    }

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc func handleKeyboardNotification(_ notification: Notification) {
        guard let keyboardInfo = KeyboardNotificationInfo(notification) else { return }

        let keyboardVisible = keyboardInfo.action == .willShow
        let keyboardIntersection = keyboardInfo.keyboardFrameEndIntersectHeight(inView: self)

        UIView.animateAlongsideKeyboard(keyboardInfo: keyboardInfo) { [weak self] in
            self?.updateWrapperViewConstraint(withKeyboardVisible: keyboardVisible, keyboardOffset: keyboardIntersection)
            self?.layoutIfNeeded()
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

// MARK: - MessageInputTextViewDelegate

extension MessageFormView: MessageInputTextViewDelegate {
    func messageFormView(_ view: MessageInputTextView, didEditMessageText text: String) {
        delegate?.messageFormView(self, didEditMessageText: text)
    }
}

// MARK: - MessageFormToolbarDelegate

extension MessageFormView: MessageFormToolbarDelegate {
    func messageFormToolbar(_ toolbar: MessageFormToolbar, didSelectMessageTemplate template: MessageFormTemplate) {
        delegate?.messageFormView(self, didSelectMessageTemplate: template)
    }
}
