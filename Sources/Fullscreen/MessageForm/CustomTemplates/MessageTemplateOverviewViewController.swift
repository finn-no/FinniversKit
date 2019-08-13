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
        tableView.register(AddNewTemplateCell.self)
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

        updateEditButtonEnabled()
    }

    // MARK: - Private methods

    private func reloadData() {
        updateEditButtonEnabled()
        tableView.reloadData()
    }

    @objc private func editButtonTapped() {
        setEditState(editing: !tableView.isEditing)
    }

    private func setEditState(editing: Bool) {
        tableView.setEditing(editing, animated: true)

        if editing {
            navigationItem.rightBarButtonItem?.title = "Ferdig"
        } else {
            navigationItem.rightBarButtonItem?.title = "Rediger"
        }
    }

    private func updateEditButtonEnabled() {
        navigationItem.rightBarButtonItem?.isEnabled = !templateStore.customTemplates.isEmpty
    }

    private func deleteTemplate(at indexPath: IndexPath) {
        guard let template = templateStore.customTemplates[safe: indexPath.row] else { return }

        templateStore.removeTemplate(template, completionHandler: { [weak self] success in
            if success {
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                self?.updateEditButtonEnabled()
                if self?.templateStore.customTemplates.isEmpty ?? false {
                    self?.setEditState(editing: false)
                }
            } else {
                // Assume we're out of sync with the template store
                self?.reloadData()
            }
        })
    }

    private func editTemplate(at indexPath: IndexPath) {
        guard let template = templateStore.customTemplates[safe: indexPath.row] else { return }

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Avbryt", style: .plain, target: nil, action: nil)

        let viewModel = TemplateEditViewModel(title: "Endre mal", saveButtonTitle: "Lagre", helpText: nil, existingTemplate: template)
        let vc = MessageTemplateEditViewController(viewModel: viewModel)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    private func addNewTemplate() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Avbryt", style: .plain, target: nil, action: nil)

        let viewModel = TemplateEditViewModel(title: "Ny mal", saveButtonTitle: "Lagre", helpText: nil, existingTemplate: nil)
        let vc = MessageTemplateEditViewController(viewModel: viewModel)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MessageTemplateOverviewViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return templateStore.customTemplates.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeue(AddNewTemplateCell.self, for: indexPath)
            cell.label.text = "Legg til ny mal"
            return cell
        case 1:
            guard let template = templateStore.customTemplates[safe: indexPath.row] else {
                return UITableViewCell()
            }

            let cell = tableView.dequeue(CustomMessageTemplateCell.self, for: indexPath)
            cell.template = template
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }

    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard section == 1 else {
            return nil
        }

        guard templateStore.customTemplates.count == 0 else {
            return nil
        }

        return "Du har ingen meldingsmaler."
    }
}

extension MessageTemplateOverviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard indexPath.section == 1 else {
            return []
        }

        let deleteAction = UITableViewRowAction(style: .destructive, title: "Slett", handler: { [weak self] _, selectedIndex in
            self?.deleteTemplate(at: selectedIndex)
        })

        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            addNewTemplate()
        case 1:
            editTemplate(at: indexPath)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        editTemplate(at: indexPath)
    }
}

extension MessageTemplateOverviewViewController: MessageTemplateEditViewControllerDelegate {
    func messageTemplateEditViewController(_ vc: MessageTemplateEditViewController, finishedWithText text: String, existingTemplate: MessageFormTemplate?) {
        if let existingTemplate = existingTemplate {
            templateStore.updateTemplate(existingTemplate, withText: text, completionHandler: { [weak self] _ in
                self?.reloadData()
            })
        } else {
            templateStore.addTemplate(withText: text, completionHandler: { [weak self] _ in
                self?.reloadData()
            })
        }
    }
}

// MARK: - AddNewTemplateCell

private class AddNewTemplateCell: UITableViewCell {

    // MARK: - Static properties

    private static let imageSize = CGSize(width: 25, height: 25)

    // MARK: - UI properties

    lazy var label: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var plusImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: .plusMini))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        contentView.addSubview(plusImageView)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumSpacing),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
            label.trailingAnchor.constraint(equalTo: plusImageView.leadingAnchor, constant: -.mediumSpacing),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumSpacing),

            plusImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
            plusImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumSpacing),
            plusImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumSpacing),

            plusImageView.widthAnchor.constraint(equalToConstant: AddNewTemplateCell.imageSize.width),
            plusImageView.heightAnchor.constraint(equalToConstant: AddNewTemplateCell.imageSize.height)
        ])
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
