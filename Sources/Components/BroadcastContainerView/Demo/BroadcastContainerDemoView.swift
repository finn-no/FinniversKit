//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import UIKit

class BroadcastContainerDemoView: UIView {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self)
        tableView.separatorStyle = .none
        tableView.rowHeight = 100

        return tableView
    }()

    private lazy var tableHeaderView: BroadcastContainerView = {
        let view = BroadcastContainerView(frame: .zero)

        return view
    }()

    private var broadcastViewMessages = [
        Broadcast(id: 1, message: "Broadcast messages appears without any action from the user. They are used when it´s important to inform the user about something that has affected the whole system and many users. Especially if it has a consequence for how he or she uses the service."),
        Broadcast(id: 2, message: "There containers should have the color \"Banana\" and associated text. An exclamation mark icon is used if it is very important that the user gets this info. They appear under the banners and pushes the other content down. It scrolls with the content.\n\nBroadcasts can also contain <a href=\"www.finn.no\">HTML links</a>."),
    ]

    override func didMoveToSuperview() {
        setup()

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [weak self] in
            self?.displayBroadcastContainerView()
        }
    }
}

private extension BroadcastContainerDemoView {
    func setup() {
        addSubview(tableView)

        tableView.fillInSuperview()

        tableView.dataSource = self
    }

    func displayBroadcastContainerView() {
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 0)
        tableView.tableHeaderView = tableHeaderView

        tableHeaderView.delegate = self
        tableHeaderView.dataSource = self
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

extension BroadcastContainerDemoView: BroadcastContainerViewDataSource {
    func numberOfBroadcasts(in broadcastContainerView: BroadcastContainerView) -> Int {
        return broadcastViewMessages.count
    }

    func broadcastContainerView(_ broadcastContainerView: BroadcastContainerView, broadcastForIndex index: Int) -> Broadcast {
        return broadcastViewMessages[index]
    }
}

extension BroadcastContainerDemoView: BroadcastContainerViewDelegate {
    func broadcastContainer(_ broadcastContainerView: BroadcastContainerView, willDisplayBroadcastsWithContainerSize containerSize: CGSize, commitToDisplaying: @escaping (() -> Void)) {
        let tableHeaderViewFrame = CGRect(origin: .zero, size: CGSize(width: frame.width, height: containerSize.height))

        tableView.beginUpdates()
        tableHeaderView.frame = tableHeaderViewFrame
        tableView.tableHeaderView = tableHeaderView
        commitToDisplaying()
        tableView.endUpdates()
    }

    func broadcastContainer(_ broadcastContainerView: BroadcastContainerView, willDismissBroadcastAtIndex index: Int, withNewContainerSize newContainerSize: CGSize, commitToDismissal: @escaping (() -> Void)) {
        let tableHeaderViewFrame = CGRect(origin: .zero, size: CGSize(width: frame.width, height: newContainerSize.height))

        tableView.beginUpdates()
        tableHeaderView.frame = tableHeaderViewFrame
        tableView.tableHeaderView = tableHeaderView
        commitToDismissal()
        tableView.endUpdates()
    }

    func broadcastContainer(_ broadcastContainerView: BroadcastContainerView, didTapURL url: URL, inBroadcastAtIndex index: Int) {
        let alertController = UIAlertController(title: "Link tapped in broadcast at index \(index)", message: "URL: \(url)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(alertController, animated: true, completion: nil)
    }
}
