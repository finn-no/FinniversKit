import Foundation

class MessageTemplateEditViewController: UIViewController {

    // MARK: - Private properties

    private let templateStore: MessageTemplateStoreProtocol

    // MARK: - UI properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
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

        view.addSubview(tableView)
        tableView.fillInSuperview()
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