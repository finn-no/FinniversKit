//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class BroadcastContainerDemoView: UIView {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self)
        tableView.separatorStyle = .none
        tableView.rowHeight = 100
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var broadcastMessages = [
        BroadcastMessage(id: 1, message: "Broadcast messages appears without any action from the user. They are used when it´s important to inform the user about something that has affected the whole system and many users. Especially if it has a consequence for how he or she uses the service."),
        BroadcastMessage(id: 2, message: "Their containers should have the colour \"Banana\" and associated text. An exclamation mark icon is used if it is very important that the user gets this info. They appear under the banners and pushes the other content down. It scrolls with the content.\\n\nBroadcasts can also contain <a href=\"http://www.finn.no\">HTML links</a>."),
    ]

    private lazy var broadcastContainer: BroadcastContainer = {
        let container = BroadcastContainer(frame: .zero)
        container.delegate = self
        container.dataSource = self
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        broadcastContainer.present(in: tableView)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BroadcastContainerDemoView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UITableViewCell.self, for: indexPath)

        cell.textLabel?.text = "👋 Scrollable content"
        cell.textLabel?.textAlignment = .center
        cell.selectionStyle = .none

        return cell
    }
}

extension BroadcastContainerDemoView: BroadcastContainerDataSource {
    public func numberOfBroadcasts(in broadcastContainer: BroadcastContainer) -> Int {
        return broadcastMessages.count
    }

    public func broadcastContainer(_ broadcastContainer: BroadcastContainer, broadcastMessageForIndex index: Int) -> BroadcastMessage {
        return broadcastMessages[index]
    }
}

extension BroadcastContainerDemoView: BroadcastContainerDelegate {

    public func broadcastContainer(_ broadcastContainer: BroadcastContainer, didTapURL url: URL, inBroadcastAtIndex index: Int) {
        print("Did tap url:", url)
    }
}
