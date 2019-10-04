//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

struct DeviceViewModel: BasicTableViewCellViewModel {
    var title: String
    let subtitle: String? = nil
    let detailText: String? = nil
    let hasChevron: Bool = false
}

protocol DevicesViewControllerDelegate: AnyObject {
    func devicesViewController(_: DevicesViewController, didSelectDeviceAtIndex index: Int)
}

final class DevicesViewController: ScrollViewController {
    private static let rowHeight: CGFloat = 48.0

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.removeLastCellSeparator()
        registerCells(for: tableView)
        return tableView
    }()

    weak var delegate: DevicesViewControllerDelegate?

    private let devices: [Device]

    init(devices: [Device]) {
        self.devices = devices
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    public var backgroundColor: UIColor? {
        didSet {
            view.backgroundColor = backgroundColor
            tableView.backgroundColor = backgroundColor
            tableView.backgroundView?.backgroundColor = backgroundColor
        }
    }

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
    }

    private func registerCells(for tableView: UITableView) {
        tableView.register(BasicTableViewCell.self)
    }
}

// MARK: - UITableViewDataSource

extension DevicesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(BasicTableViewCell.self, for: indexPath)

        if let device = devices[safe: indexPath.row] {
            cell.configure(with: DeviceViewModel(title: device.title))
            cell.titleLabel.isEnabled = device.isEnabled
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension DevicesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = devices[indexPath.row]
        if device.isEnabled {
            delegate?.devicesViewController(self, didSelectDeviceAtIndex: indexPath.item)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return type(of: self).rowHeight
    }
}
