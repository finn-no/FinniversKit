import FinniversKit

protocol SectionsTableViewControllerDelegate: AnyObject {
    func sectionsTableViewController(_ sectionsTableViewController: SectionsTableViewController, didSelectOptionWithIndexPath indexPath: IndexPath)
}

struct SectionsViewModel: BasicTableViewCellViewModel {
    var title: String
    var subtitle: String?
    var detailText: String?
    var hasChevron: Bool

    init(title: String) {
        self.title = title
        self.hasChevron = false
    }
}

class SectionsTableViewController: UIViewController {
    weak var delegate: SectionsTableViewControllerDelegate?
    private let options: [String]
    var selectedIndexPath: IndexPath?

    private lazy var tableView: UITableView = {
        let view = UITableView(withAutoLayout: true)
        view.dataSource = self
        view.delegate = self
        view.separatorColor = .clear
        return view
    }()

    init(options: [String]) {
        self.options = options
        super.init(nibName: nil, bundle: nil)
        setup()

        NotificationCenter.default.addObserver(self, selector: #selector(userInterfaceStyleDidChange(_:)), name: .didChangeUserInterfaceStyle, object: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        view.addSubview(tableView)
        tableView.fillInSuperview()
        tableView.register(BasicTableViewCell.self)
        updateColors()
    }

    @objc private func userInterfaceStyleDidChange(_ userInterfaceStyle: UserInterfaceStyle) {
        updateColors()
        tableView.reloadData()
    }

    private func updateColors() {
        let interfaceBackgroundColor: UIColor = .bgPrimary
        view.backgroundColor = interfaceBackgroundColor
        tableView.backgroundColor = interfaceBackgroundColor
    }
}

// MARK: - UITableViewDataSource

extension SectionsTableViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(BasicTableViewCell.self, for: indexPath)
        let option = options[indexPath.row]
        let isSelected = selectedIndexPath != nil ? selectedIndexPath == indexPath : false
        cell.configure(with: SectionsViewModel(title: option))
        cell.titleLabel.textColor = isSelected ? .textAction : .textPrimary
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SectionsTableViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.sectionsTableViewController(self, didSelectOptionWithIndexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
