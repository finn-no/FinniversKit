import FinniversKit

protocol TweakingOptionsTableViewControllerDelegate: AnyObject {
    func tweakingOptionsTableViewControllerDidDismiss(_ tweakingOptionsTableViewController: TweakingOptionsTableViewController)
}

class TweakingOptionsTableViewController: UIViewController {
    weak var delegate: TweakingOptionsTableViewControllerDelegate?
    private let options: [TweakingOption]
    var selectedIndexPath: IndexPath?

    private lazy var tableView: BasicTableView = {
        var items = options.map { BasicTableViewItem(title: $0.title) }
        let view = BasicTableView(items: items)
        view.delegate = self
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

// MARK: - BasicTableViewDelegate

extension TweakingOptionsTableViewController: BasicTableViewDelegate {
    func basicTableView(_ basicTableView: BasicTableView, didSelectItemAtIndex index: Int) {
        let option = options[index]
        option.action?()
        delegate?.tweakingOptionsTableViewControllerDidDismiss(self)
    }
}
