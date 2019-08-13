import Foundation

class MessageTemplateOverviewViewController: UIViewController {

    // MARK: - Private properties

    private let templateStore: MessageTemplateStoreProtocol
    private let viewModel: MessageFormViewModel

    // MARK: - UI properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(CustomMessageTemplateCell.self)
        tableView.register(AddNewTemplateCell.self)
        tableView.separatorInset = UIEdgeInsets(leading: .mediumSpacing + .mediumLargeSpacing)
        return tableView
    }()

    // MARK: - Setup

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public required init(templateStore: MessageTemplateStoreProtocol, viewModel: MessageFormViewModel) {
        self.templateStore = templateStore
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.customTemplatesTitleText

        view.backgroundColor = .milk
        view.addSubview(tableView)
        tableView.fillInSuperview()

        let editItem = UIBarButtonItem(title: viewModel.editButtonText, style: .plain, target: self, action: #selector(editButtonTapped))
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
            navigationItem.rightBarButtonItem?.title = viewModel.doneButtonText
        } else {
            navigationItem.rightBarButtonItem?.title = viewModel.editButtonText
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

        navigationItem.backBarButtonItem = UIBarButtonItem(title: viewModel.cancelButtonText, style: .plain, target: nil, action: nil)

        let editModel = TemplateEditViewModel(title: viewModel.customTemplateEditText, saveButtonTitle: viewModel.saveButtonText, helpText: nil, existingTemplate: template)
        let vc = MessageTemplateEditViewController(viewModel: editModel)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    private func addNewTemplate() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: viewModel.cancelButtonText, style: .plain, target: nil, action: nil)

        let editModel = TemplateEditViewModel(title: viewModel.customTemplateNewText, saveButtonTitle: viewModel.saveButtonText, helpText: nil, existingTemplate: nil)
        let vc = MessageTemplateEditViewController(viewModel: editModel)
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
            cell.label.text = viewModel.newCustomTemplatePromptText
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
        if section == 0 && templateStore.customTemplates.count == 0 {
            return viewModel.noCustomTemplatesText
        } else {
            return nil
        }
    }
}

extension MessageTemplateOverviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard indexPath.section == 1 else {
            return []
        }

        let deleteAction = UITableViewRowAction(style: .destructive, title: viewModel.deleteActionText, handler: { [weak self] _, selectedIndex in
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

    private static let imageSize = CGSize(width: 16, height: 16)

    // MARK: - UI properties

    lazy var label: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .primaryBlue
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
            plusImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: .mediumSpacing),
            plusImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumSpacing + .mediumLargeSpacing),
            plusImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -.mediumSpacing),
            plusImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            plusImageView.widthAnchor.constraint(equalToConstant: AddNewTemplateCell.imageSize.width),
            plusImageView.heightAnchor.constraint(equalToConstant: AddNewTemplateCell.imageSize.height),

            label.leadingAnchor.constraint(equalTo: plusImageView.trailingAnchor, constant: .mediumSpacing),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumLargeSpacing),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumLargeSpacing)
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
        let label = Label(style: .bodyRegular)
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

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: .mediumSpacing + .mediumLargeSpacing),
            label.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: .mediumLargeSpacing),
            label.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -.mediumLargeSpacing),
            label.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -.mediumLargeSpacing),
        ])
    }
}
