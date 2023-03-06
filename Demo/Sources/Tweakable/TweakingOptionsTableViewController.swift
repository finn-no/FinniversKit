import FinniversKit

protocol TweakingOptionsTableViewControllerDelegate: AnyObject {
    func tweakingOptionsTableViewControllerDidDismiss(_ tweakingOptionsTableViewController: TweakingOptionsTableViewController)
    func tweakingOptionsTableViewController(_ tweakingOptionsTableViewController: TweakingOptionsTableViewController, didSelectDevice device: Device)
}

class TweakingOptionsTableViewController: ScrollViewController {
    // MARK: - Internal properties

    weak var delegate: TweakingOptionsTableViewControllerDelegate?

    // MARK: - Private properties

    private let options: [TweakingOption]

    private lazy var tableView: BasicTableView = {
        let items = options.map { BasicTableViewItem(title: $0.title, subtitle: $0.description) }
        let view = BasicTableView(items: items)
        view.delegate = self
        return view
    }()

    private lazy var devicesTableView: BasicTableView = {
        var items = [BasicTableViewItem]()
        Device.all.forEach { device in
            var item = BasicTableViewItem(title: device.title)
            item.isEnabled = device.isEnabled
            items.append(item)
        }

        let tableView = BasicTableView(items: items)
        tableView.delegate = self
        return tableView
    }()

    private lazy var selectorTitleView: SelectorTitleView = {
        let titleView = SelectorTitleView(heading: "Device")
        titleView.delegate = self
        return titleView
    }()

    // MARK: - Init

    init(options: [TweakingOption]) {
        self.options = options
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        view.insertSubview(tableView, belowSubview: topShadowView)
        NSLayoutConstraint.activate([
            topShadowView.bottomAnchor.constraint(equalTo: view.topAnchor),

            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        let interfaceBackgroundColor: UIColor = .bgPrimary
        view.backgroundColor = interfaceBackgroundColor
        tableView.backgroundColor = interfaceBackgroundColor
        devicesTableView.backgroundColor = interfaceBackgroundColor

        navigationItem.titleView = selectorTitleView

        if let deviceIndex = DemoState.lastSelectedDevice, deviceIndex < Device.all.count {
            selectorTitleView.title = Device.all[deviceIndex].title
        } else {
            selectorTitleView.title = "Choose a device"
        }
    }

    // MARK: - Private methods

    private func showDevicesViewController() {
        selectorTitleView.arrowDirection = .up

        guard devicesTableView.superview == nil else { return }

        view.addSubview(devicesTableView)
        devicesTableView.fillInSuperview()
        devicesTableView.alpha = 0.6
        devicesTableView.frame.origin.y = -.spacingXL

        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.devicesTableView.alpha = 1
        })

        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1,
            options: [],
            animations: { [weak self] in
                self?.devicesTableView.frame.origin.y = 0
            }
        )
    }

    private func hideDevicesViewController() {
        selectorTitleView.arrowDirection = .down
        tableView.alpha = 0

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: ({ [weak self] in
            self?.devicesTableView.frame.origin.y = -.spacingXXL
            self?.devicesTableView.alpha = 0
        }), completion: ({ [weak self] _ in
            guard self?.devicesTableView.superview != nil else { return }

            self?.devicesTableView.removeFromSuperview()
        }))

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.tableView.alpha = 1
        })
    }
}

// MARK: - SelectorTitleViewDelegate

extension TweakingOptionsTableViewController: SelectorTitleViewDelegate {
    func selectorTitleViewDidSelectButton(_ view: SelectorTitleView) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        if view.arrowDirection == .up {
            hideDevicesViewController()
        } else {
            showDevicesViewController()
        }
    }
}

// MARK: - BasicTableViewDelegate

extension TweakingOptionsTableViewController: BasicTableViewDelegate {
    func basicTableView(_ basicTableView: BasicTableView, didSelectItemAtIndex index: Int) {
        if basicTableView == devicesTableView {
            let device = Device.all[index]
            selectorTitleView.title = device.title
            hideDevicesViewController()
            DemoState.lastSelectedDevice = index
            delegate?.tweakingOptionsTableViewController(self, didSelectDevice: device)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.delegate?.tweakingOptionsTableViewControllerDidDismiss(self)
            }
        } else {
            let option = options[index]
            option.action?()
            delegate?.tweakingOptionsTableViewControllerDidDismiss(self)
        }
    }
}
