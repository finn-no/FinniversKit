//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

struct Event: BasicTableViewCellViewModel {
    let title: String
    let subtitle: String? = nil
    let detailText: String? = nil
    let hasChevron: Bool = false
}

protocol KlimabroletEventsDemoViewControllerDelegate: AnyObject {
    func eventList(_ eventListViewController: KlimabroletEventsDemoViewController, didSelect event: Event)
    func eventListDidSelectClose(_ eventListViewController: KlimabroletEventsDemoViewController)
}

class KlimabroletEventsDemoViewController: UITableViewController {
    let events: [Event] = [
        Event(title: "Klimabrølet Oslo"),
        Event(title: "Klimabrølet Tønsberg"),
        Event(title: "Klimabrølet Stavanger"),
        Event(title: "Klimabrølet Bergen"),
        Event(title: "Klimabrølet Røros"),
        Event(title: "Klimabrølet Trondheim"),
        Event(title: "Klimabrølet Henningsvær"),
        Event(title: "Klimabrølet Svalbard"),
    ]

    weak var delegate: KlimabroletEventsDemoViewControllerDelegate?

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: .cross).withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .stone
        button.addTarget(self, action: #selector(handleCloseButtonTap), for: .touchUpInside)
        return button
    }()

    override init(style: UITableView.Style) {
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        title = "Velg arrangement"
        setupNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 12),
            closeButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 12),
        ])
        tableView.register(BasicTableViewCell.self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(BasicTableViewCell.self, for: indexPath)
        let model = events[indexPath.row]
        cell.configure(with: model)
        cell.selectionStyle = .default
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .milk
        return view
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        delegate?.eventList(self, didSelect: event)
    }

    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }

        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }

    @objc private func handleCloseButtonTap() {
        delegate?.eventListDidSelectClose(self)
    }
}
