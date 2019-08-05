import Foundation

class MessageTemplateEditViewController: UIViewController {

    // MARK: - Private properties

    private let templateStore: MessageTemplateStoreProtocol

    // MARK: - UI properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(CustomMessageTemplateCell.self)
        return tableView
    }()

    // MARK: - Setup

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public required init(templateStore: MessageTemplateStoreProtocol) {
        self.templateStore = templateStore
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Meldingsmaler"

        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addItem

        view.backgroundColor = .milk
        view.addSubview(tableView)
        tableView.fillInSuperview()
    }

    // MARK: - Private methods

    @objc private func addButtonTapped() {
        let title = "Ny meldingsmal"
        let subtitle = "Legg til en mal for en melding du sender ofte."
        let inputPlaceholder = "Meldingsmal"
        let actionTitle = "Lagre"
        let cancelTitle = "Avbryt"

        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false

        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { [weak self] _ in
            guard
                let textField = alert.textFields?.first,
                let text = textField.text,
                text.count > 0 else {
                return
            }

            self?.templateStore.addTemplate(withText: text, completionHandler: { [weak self] success in
                // Reload regardless of success. In case of failure, we should assume we are out of sync
                // with the template store.
                self?.tableView.reloadData()
            })
        }))

        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MessageTemplateEditViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templateStore.customTemplates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let template = templateStore.customTemplates[safe: indexPath.row] else {
            return UITableViewCell()
        }

        let cell = tableView.dequeue(CustomMessageTemplateCell.self, for: indexPath)
        cell.template = template
        return cell
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let template = templateStore.customTemplates[safe: indexPath.row] else { return }

            templateStore.removeTemplate(template, completionHandler: { success in
                if success {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                } else {
                    // Assume we're out of sync with the template store
                    tableView.reloadData()
                }
            })
        }
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Dine meldingsmaler"
    }
}

extension MessageTemplateEditViewController: UITableViewDelegate {

}

// MARK: - CustomMessageTemplateCell

private class CustomMessageTemplateCell: UITableViewCell {

    var template: MessageFormTemplate? {
        didSet {
            label.text = template?.text
        }
    }

    // MARK: - UI properties

    private lazy var label: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    private func setup() {
        contentView.addSubview(label)
        label.fillInSuperview(margin: .mediumSpacing)
    }
}