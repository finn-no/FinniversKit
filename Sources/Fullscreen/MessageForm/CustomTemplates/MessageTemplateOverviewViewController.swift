import Foundation

class MessageTemplateOverviewViewController: UIViewController {

    // MARK: - Private properties

    private let templateStore: MessageTemplateStoreProtocol

    // MARK: - UI properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
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
        title = "Dine meldingsmaler"

        view.backgroundColor = .milk
        view.addSubview(tableView)
        tableView.fillInSuperview()

        let editItem = UIBarButtonItem(title: "Rediger", style: .plain, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem = editItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    // MARK: - Private methods

    @objc private func editButtonTapped() {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            navigationItem.rightBarButtonItem?.title = "Rediger"
        } else {
            tableView.setEditing(true, animated: true)
            navigationItem.rightBarButtonItem?.title = "Ferdig"
        }
    }

    private func deleteTemplate(at indexPath: IndexPath) {
        guard let template = templateStore.customTemplates[safe: indexPath.row] else { return }

        templateStore.removeTemplate(template, completionHandler: { [weak self] success in
            if success {
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                // Assume we're out of sync with the template store
                self?.tableView.reloadData()
            }
        })
    }

    private func editTemplate(at indexPath: IndexPath) {
        guard let template = templateStore.customTemplates[safe: indexPath.row] else { return }

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Avbryt", style: .plain, target: nil, action: nil)

        let viewModel = TemplateEditViewModel(title: "Endre mal", saveButtonTitle: "Lagre", existingTemplate: template)
        let vc = MessageTemplateEditViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MessageTemplateOverviewViewController: UITableViewDataSource {
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

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard templateStore.customTemplates.count == 0 else {
            return nil
        }

        return "Du har ingen meldingsmaler."
    }
}

extension MessageTemplateOverviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Slett", handler: { [weak self] _, selectedIndex in
            self?.deleteTemplate(at: selectedIndex)
        })

        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editTemplate(at: indexPath)
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        editTemplate(at: indexPath)
    }
}

// MARK: - CustomMessageTemplateCell

private class CustomMessageTemplateCell: UITableViewCell {

    // MARK: - Internal properties

    var template: MessageFormTemplate? {
        didSet {
            label.text = template?.text
        }
    }

    // MARK: - UI properties

    private lazy var wrapperView: UIView = UIView(withAutoLayout: true)

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
        accessoryType = .disclosureIndicator

        contentView.addSubview(wrapperView)
        wrapperView.fillInSuperview()

        wrapperView.addSubview(label)
        label.fillInSuperview(margin: .mediumSpacing)

        NSLayoutConstraint.activate([
            wrapperView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
    }
}
