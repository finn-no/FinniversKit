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
    }

    private func setup() {
        view.backgroundColor = .milk
        navigationItem.title = viewModel.title

        view.addSubview(messageInputTextView)
        messageInputTextView.fillInSuperview()

        let saveButton = UIBarButtonItem(title: viewModel.saveButtonTitle, style: .done, target: self, action: #selector(saveButtonTapped))
        saveButton.isEnabled = false
        navigationItem.rightBarButtonItem = saveButton

        if let existingTemplate = viewModel.existingTemplate {
            messageInputTextView.text = existingTemplate.text
        }
    }

    // MARK: - Private methods

    @objc private func saveButtonTapped() {
        delegate?.messageTemplateEditViewController(
            self,
            finishedWithText: messageInputTextView.text,
            existingTemplate: viewModel.existingTemplate)

        navigationController?.popViewController(animated: true)
    }
}

extension MessageTemplateEditViewController: MessageInputTextViewDelegate {
    func messageFormView(_ view: MessageInputTextView, didEditMessageText text: String) {
        navigationItem.rightBarButtonItem?.isEnabled = text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
    }
}
