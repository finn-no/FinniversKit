import FinniversKit

protocol TweakingOptionsTableViewControllerDelegate: AnyObject {
    func tweakingOptionsTableViewControllerDidDismiss(_ tweakingOptionsTableViewController: TweakingOptionsTableViewController)

    func tweakingOptionsTableViewController(_ tweakingOptionsTableViewController: TweakingOptionsTableViewController, didSelectDevice device: Device)
}

class TweakingOptionsTableViewController: ScrollViewController {
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

    private lazy var devicesViewController: DevicesViewController = {
        let viewController = DevicesViewController(devices: Device.all)
        viewController.delegate = self
        return viewController
    }()

    private lazy var selectorTitleView: SelectorTitleView = {
        let titleView = SelectorTitleView(heading: "Device")
        titleView.delegate = self
        return titleView
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
        view.insertSubview(tableView, belowSubview: topShadowView)
        NSLayoutConstraint.activate([
            topShadowView.bottomAnchor.constraint(equalTo: view.topAnchor),

            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        tableView.register(TweakingOptionCell.self)
        updateColors()
        navigationItem.titleView = selectorTitleView

        if let deviceIndex = State.lastSelectedDevice {
            selectorTitleView.title = Device.all[deviceIndex].title
        } else {
            selectorTitleView.title = "Choose a device"
        }
    }

    @objc private func userInterfaceStyleDidChange(_ userInterfaceStyle: UserInterfaceStyle) {
        updateColors()
        tableView.reloadData()
    }

    private func updateColors() {
        let interfaceBackgroundColor: UIColor = .bgPrimary
        view.backgroundColor = interfaceBackgroundColor
        tableView.backgroundColor = interfaceBackgroundColor
        devicesViewController.backgroundColor = interfaceBackgroundColor
    }

    private func showDevicesViewController() {
        selectorTitleView.arrowDirection = .up

        guard devicesViewController.parent == nil else { return }

        addChild(devicesViewController)
        devicesViewController.view.frame = view.bounds
        devicesViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(devicesViewController.view)
        devicesViewController.didMove(toParent: self)

        devicesViewController.view.alpha = 0.6
        devicesViewController.view.frame.origin.y = -.largeSpacing

        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.devicesViewController.view.alpha = 1
        })

        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1,
            options: [],
            animations: { [weak self] in
                self?.devicesViewController.view.frame.origin.y = 0
            }
        )
    }

    private func hideDevicesViewController() {
        selectorTitleView.arrowDirection = .down

        tableView.alpha = 0

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: ({ [weak self] in
            self?.devicesViewController.view.frame.origin.y = -.veryLargeSpacing
            self?.devicesViewController.view.alpha = 0
        }), completion: ({ [weak self] _ in
            guard self?.devicesViewController.parent != nil else { return }

            self?.devicesViewController.willMove(toParent: nil)
            self?.devicesViewController.removeFromParent()
            self?.devicesViewController.view.removeFromSuperview()
        }))

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.tableView.alpha = 1
        })
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
        delegate?.tweakingOptionsTableViewControllerDidDismiss(self)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

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

extension TweakingOptionsTableViewController: DevicesViewControllerDelegate {
    func devicesViewController(_: DevicesViewController, didSelectDeviceAtIndex index: Int) {
        let device = Device.all[index]
        selectorTitleView.title = device.title
        hideDevicesViewController()
        State.lastSelectedDevice = index
        self.delegate?.tweakingOptionsTableViewController(self, didSelectDevice: device)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.delegate?.tweakingOptionsTableViewControllerDidDismiss(self)
        }
    }
}
