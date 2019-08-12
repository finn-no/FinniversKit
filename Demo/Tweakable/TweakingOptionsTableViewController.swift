import FinniversKit

protocol TweakingOptionsTableViewControllerDelegate: AnyObject {
    func tweakingOptionsTableViewController(_ tweakingOptionsTableViewController: TweakingOptionsTableViewController, didDismissWithIndexPath indexPath: IndexPath)
}

class TweakingOptionsTableViewController: UIViewController {
    weak var delegate: TweakingOptionsTableViewControllerDelegate?
    private let options: [TweakingOption]
    var selectedIndexPath: IndexPath?

    private lazy var tableView: UITableView = {
        let view = UITableView(withAutoLayout: true)
        view.dataSource = self
        view.delegate = self
        view.separatorColor = .clear
        return view
    }()

    init(options: [TweakingOption]) {
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
        tableView.register(TweakingOptionCell.self)
        updateColors()
    }

    @objc private func userInterfaceStyleDidChange(_ userInterfaceStyle: UserInterfaceStyle) {
        updateColors()
        tableView.reloadData()
    }

    private func updateColors() {
        let interfaceBackgroundColor: UIColor
        switch State.currentUserInterfaceStyle(for: traitCollection) {
        case .light:
            interfaceBackgroundColor = .milk
        case .dark:
            interfaceBackgroundColor = .midnightBackground
        }
        tableView.backgroundColor = interfaceBackgroundColor
    }
}

// MARK: - UITableViewDataSource

extension TweakingOptionsTableViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(TweakingOptionCell.self, for: indexPath)
        let option = options[indexPath.row]
        let isSelected = selectedIndexPath != nil ? selectedIndexPath == indexPath : false
        cell.configure(withOption: option, isSelected: isSelected, for: traitCollection)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TweakingOptionsTableViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = options[indexPath.row]
        option.action?()
        delegate?.tweakingOptionsTableViewController(self, didDismissWithIndexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
