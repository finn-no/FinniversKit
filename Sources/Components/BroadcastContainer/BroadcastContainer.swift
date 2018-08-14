//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol BroadcastContainerDelegate: class {

    /// Called when a URL in a broadcasts message is tapped
    ///
    /// - Parameters:
    ///   - broadcastContainer: the BroadcastContainer
    ///   - url: the URL that was tapped
    ///   - index: the index of the broadcast that containes the URL that was tapped
    func broadcastContainer(_ broadcastContainer: BroadcastContainer, didTapURL url: URL, inBroadcastAtIndex index: Int)
}

// MARK: - BroadcastContainerDelegate default implementations

public extension BroadcastContainerDelegate {
    func broadcastContainer(_ broadcastContainer: BroadcastContainer, didTapURL url: URL, inBroadcastAtIndex index: Int) {}
}

public protocol BroadcastContainerDataSource: class {
    /// The number of broadcasts to display in the BroadcastContainer
    ///
    /// - Parameter broadcastContainer: the BroadcastContainer
    /// - Returns: The number of broadcasts to display in the BroadcastContainer
    func numberOfBroadcasts(in broadcastContainer: BroadcastContainer) -> Int

    /// The broadcast to display at the index
    ///
    /// - Parameters:
    ///   - broadcastContainer: the BroadcastContainer
    ///   - index: the index for the broadcast
    /// - Returns: The broadcast to display at the index
    func broadcastContainer(_ broadcastContainer: BroadcastContainer, broadcastMessageForIndex index: Int) -> BroadcastMessage
}

// MARK: -

/// A view that is used to display multiple Broadcasts
public final class BroadcastContainer: UIView {

    // MARK: Public properties

    public weak var dataSource: BroadcastContainerDataSource? { didSet { needsReload = true } }
    public weak var delegate: BroadcastContainerDelegate?
    public weak var tableView: UITableView? { didSet { didSet(tableView) } }

    // MARK: - Private properties

    private var needsReload = false

    private lazy var contentView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = .mediumLargeSpacing
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        return stack
    }()

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: .mediumLargeSpacing)
        ])
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        print("Container layout")
        if needsReload {
            guard let dataSource = dataSource else { return }

            removeContent()

            let count = dataSource.numberOfBroadcasts(in: self)

            for i in 0 ..< count {
                let message = dataSource.broadcastContainer(self, broadcastMessageForIndex: i)
                let model = BroadcastModel(with: message.text)
                let broadcast = Broadcast(model: model)
                broadcast.delegate = self
                contentView.addArrangedSubview(broadcast)
            }

            needsReload = false
            layoutIfNeeded()
            tableView?.tableHeaderView = self
        }
    }
}

// MARK: - Private

private extension BroadcastContainer {

    func didSet(_ tableView: UITableView?) {
        guard let tableView = tableView else { return }
        tableView.tableHeaderView = self
        leadingAnchor.constraint(equalTo: tableView.leadingAnchor).isActive = true
        topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        trailingAnchor.constraint(equalTo: tableView.trailingAnchor).isActive = true
    }

    func remove(_ broadcast: Broadcast) {
        guard let subView = contentView.arrangedSubviews.filter({ $0 == broadcast }).first else {
            return
        }

        contentView.removeArrangedSubview(subView)
        subView.removeFromSuperview()
    }

    func removeContent() {
        contentView.arrangedSubviews.forEach { view in
            contentView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}

// MARK: - BroadcastDelegate

extension BroadcastContainer: BroadcastDelegate {
    public func broadcast(_ broadcast: Broadcast, didTapURL url: URL) {
        let broadcastIndex = contentView.arrangedSubviews.index(of: broadcast) ?? 0
        delegate?.broadcastContainer(self, didTapURL: url, inBroadcastAtIndex: broadcastIndex)
    }

    public func broadcastDismissButtonTapped(_ broadcast: Broadcast) {

    }
}
