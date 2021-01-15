//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit

public class BroadcastDemoView: UIView {
    private let items = ["Select", "any", "row", "and", "the", "broadcasts", "will", "reappear", "unless", "it", "is", "already", "visible"]

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self)
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var broadcastMessages: Set<BroadcastMessage> = [
        BroadcastMessage(id: 999, text: "Their containers should have the colour \"Banana\" and associated text. They appear under the banners, pushes the other content down and scrolls with the content. But that actually depends on implementation in the view they are used.\\n\nBroadcasts can also contain <a href=\"http://www.finn.no\">HTML links</a>.")
    ]

    private lazy var broadcast: Broadcast = {
        let container = Broadcast(frame: .zero)
        container.delegate = self
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        setup()
    }

    func setup() {
        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        broadcast.presentMessages(broadcastMessages, in: tableView, animated: false)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BroadcastDemoView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newMessage = BroadcastMessage(id: indexPath.row, text: "You tapped row \(indexPath.row).\\n\nBroadcasts can also contain <a href=\"http://www.finn.no\">HTML links</a>.")
        broadcast.presentMessages([newMessage], in: tableView)
        DispatchQueue.main.async {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        broadcast.handleScrolling()
    }
}

extension BroadcastDemoView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UITableViewCell.self, for: indexPath)

        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.selectionStyle = .default

        return cell
    }
}

extension BroadcastDemoView: BroadcastDelegate {
    public func broadcast(_ broadcast: Broadcast, didDismiss message: BroadcastMessage) {
        print("Did dismiss message id:", message.id)
    }

    public func broadcast(_ broadcast: Broadcast, didTapURL url: URL, inItemAtIndex index: Int) {
        print("Did tap url:", url)
    }
}
