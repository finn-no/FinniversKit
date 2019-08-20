import UIKit

struct TemplateEditViewModel {
    let title: String
    let saveButtonTitle: String
    let helpText: String?
    let existingTemplate: MessageFormTemplate?
}

protocol MessageTemplateEditViewControllerDelegate: AnyObject {
    func messageTemplateEditViewController(_ vc: MessageTemplateEditViewController,
                                           finishedWithText text: String,
                                           existingTemplate: MessageFormTemplate?)
}

class MessageTemplateEditViewController: UIViewController {

    // MARK: - Internal properties

    weak var delegate: MessageTemplateEditViewControllerDelegate?

    // MARK: - Private properties

    private let viewModel: TemplateEditViewModel

    // MARK: - UI properties

    private lazy var messageInputTextView: MessageInputTextView = {
        let view = MessageInputTextView(additionalInfoText: viewModel.helpText ?? "")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    private lazy var messageInputBottomConstraint = messageInputTextView.bottomAnchor.constraint(equalTo: view.compatibleBottomAnchor)

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    required init(viewModel: TemplateEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        setup()
        registerForNotifications()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputTextView.becomeFirstResponder()
    }

    private func setup() {
        view.backgroundColor = .milk
        navigationItem.title = viewModel.title

        view.addSubview(messageInputTextView)
        NSLayoutConstraint.activate([
            messageInputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageInputTextView.topAnchor.constraint(equalTo: view.topAnchor),
            messageInputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageInputBottomConstraint
        ])

        let saveButton = UIBarButtonItem(title: viewModel.saveButtonTitle, style: .done, target: self, action: #selector(saveButtonTapped))
        saveButton.isEnabled = false
        navigationItem.rightBarButtonItem = saveButton

        if let existingTemplate = viewModel.existingTemplate {
            messageInputTextView.text = existingTemplate.text
        }
    }

    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    // MARK: - Private methods

    @objc private func saveButtonTapped() {
        delegate?.messageTemplateEditViewController(
            self,
            finishedWithText: messageInputTextView.text,
            existingTemplate: viewModel.existingTemplate)

        navigationController?.popViewController(animated: true)
    }

    @objc private func handleKeyboardNotification(_ notification: Notification) {
        guard let keyboardInfo = KeyboardNotificationInfo(notification) else { return }

        let keyboardVisible = keyboardInfo.action == .willShow
        let keyboardIntersection = keyboardInfo.keyboardFrameEndIntersectHeight(inView: messageInputTextView)

        UIView.animateAlongsideKeyboard(keyboardInfo: keyboardInfo) { [weak self] in
            self?.messageInputBottomConstraint.constant = -keyboardIntersection
            self?.view.layoutIfNeeded()
        }
    }
}

extension MessageTemplateEditViewController: MessageFormCommittableViewController {
    var hasUncommittedChanges: Bool {
        guard let initialText = viewModel.existingTemplate?.text else {
            return messageInputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
        }

        return messageInputTextView.text != initialText
    }
}

extension MessageTemplateEditViewController: MessageInputTextViewDelegate {
    func messageFormView(_ view: MessageInputTextView, didEditMessageText text: String) {
        navigationItem.rightBarButtonItem?.isEnabled = text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
    }
}
