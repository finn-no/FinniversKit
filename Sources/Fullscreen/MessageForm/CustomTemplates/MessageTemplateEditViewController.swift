import UIKit

struct TemplateEditViewModel {
    let title: String
    let saveButtonTitle: String
    let existingTemplate: MessageFormTemplate?
}

class MessageTemplateEditViewController: UIViewController {

    // MARK: - Private properties

    private let viewModel: TemplateEditViewModel

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    required init(viewModel: TemplateEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        view.backgroundColor = .milk
        navigationItem.title = viewModel.title

        let saveButton = UIBarButtonItem(title: viewModel.saveButtonTitle, style: .done, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
    }

    // MARK: - Private methods

    @objc private func saveButtonTapped() {
        dismiss(animated: true)
    }
}

