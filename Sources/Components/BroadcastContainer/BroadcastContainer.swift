//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol BroadcastContainerDelegate: class {
    /// Called when the BroadcastContainer is about to display its broadcasts
    ///
    /// - Parameters:
    ///   - broadcastContainer: the BroadcastContainer
    ///   - containerSize: the size that the BroadcastContainer will have when the broadcasts are displayed
    ///   - commitToDisplaying: a closure that must be called in order for the BroadcastContainer to display its broadcasts
    func broadcastContainer(_ broadcastContainer: BroadcastContainer, willDisplayBroadcastsWithContainerSize containerSize: CGSize, commitToDisplaying: @escaping (() -> Void))

    /// Called when the BroadcastContainer is about to dismiss a broadcast
    ///
    /// - Parameters:
    ///   - broadcastContainer: the BroadcastContainer
    ///   - index: the index of the broadcast that is about to be dismissed
    ///   - newContainerSize: the size that the BroadcastContainer will have when the broadcast is dismissed
    ///   - commitToDismissal: a closure that must be called in order for the BroadcastContainer to dismiss the broadcast
    func broadcastContainer(_ broadcastContainer: BroadcastContainer, willDismissBroadcastAtIndex index: Int, withNewContainerSize newContainerSize: CGSize, commitToDismissal: @escaping (() -> Void))

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

/// A view that is used to display multiple Broadcasts
public final class BroadcastContainer: UIView {
    private let contentViewInsets = UIEdgeInsets(top: .mediumLargeSpacing, leading: .mediumLargeSpacing, bottom: 0, trailing: -.mediumLargeSpacing)
    private let broadcastSpacing: CGFloat = .mediumLargeSpacing

    /// The datasource for the BroadcastContainer
    public weak var dataSource: BroadcastContainerDataSource? {
        didSet {
            reload()
        }
    }

    /// The delegate of the BroadcastContainer
    public weak var delegate: BroadcastContainerDelegate?

    private lazy var contentView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = broadcastSpacing
        view.distribution = .fillProportionally
        return view
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override func didMoveToSuperview() {
        contentView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 0)
    }
}

// MARK: - Public

public extension BroadcastContainer {
    /// Reloads the container by removing existing broadcasts and laying out all the broadcasts that the datasource provides
    public func reload() {
        guard let dataSource = dataSource else {
            return
        }

        removeContentViewSubviews()

        let rangeOfBroadcastsToDisplay = 0 ..< dataSource.numberOfBroadcasts(in: self)
        let broadcastMessagesToDisplay = rangeOfBroadcastsToDisplay.map { dataSource.broadcastContainer(self, broadcastMessageForIndex: $0) }

        layoutBroadcasts(from: broadcastMessagesToDisplay)

        if let delegate = delegate {
            delegate.broadcastContainer(self, willDisplayBroadcastsWithContainerSize: intrinsicContentSize, commitToDisplaying: {
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.contentView.arrangedSubviews.forEach { $0.isHidden = false }
                })
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.contentView.arrangedSubviews.forEach { $0.isHidden = false }
            })
        }
    }

    public override var intrinsicContentSize: CGSize {
        guard contentView.arrangedSubviews.count != 0 else {
            return CGSize(width: frame.size.width, height: 0)
        }

        let broadcastsHorizontalSpacings = contentViewInsets.leading + abs(contentViewInsets.trailing)
        let constrainedWidth = frame.size.width - broadcastsHorizontalSpacings

        let broadcastsTotalHeight = contentView.arrangedSubviews.reduce(CGFloat(0), { accumulatedHeight, arrangedSubview in
            guard let broadcast = arrangedSubview as? Broadcast else {
                return accumulatedHeight
            }

            let broadcastHeight = broadcast.calculatedSize(withConstrainedWidth: constrainedWidth).height

            return accumulatedHeight + broadcastHeight
        })

        guard broadcastsTotalHeight != 0 else {
            return CGSize(width: frame.size.width, height: 0)
        }

        let broadcastTotalSpacing = ((CGFloat(contentView.arrangedSubviews.count) * broadcastSpacing) - .mediumLargeSpacing)
        let verticalSpacing = contentViewInsets.top + broadcastTotalSpacing
        let containerHeight = broadcastsTotalHeight + verticalSpacing

        return CGSize(width: frame.size.width, height: containerHeight)
    }
}

// MARK: - Private

private extension BroadcastContainer {
    func setup() {
        contentView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 0)

        addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: contentViewInsets.top),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentViewInsets.leading),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: contentViewInsets.trailing),
        ])

        contentView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        contentView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }

    func layoutBroadcasts(from broadcastMessages: [BroadcastMessage]) {
        let broadcasts = broadcastMessages.map { broadcast(from: $0) }
        broadcasts.forEach { add($0, to: contentView) }
    }

    func broadcast(from broadcastMessage: BroadcastMessage) -> Broadcast {
        let broadcast = Broadcast(frame: .zero)
        let viewModel = BroadcastModel(with: broadcastMessage.message)
        broadcast.presentMessage(using: viewModel, animated: false)

        return broadcast
    }

    func add(_ broadcast: Broadcast, to stackView: UIStackView) {
        broadcast.delegate = self
        broadcast.translatesAutoresizingMaskIntoConstraints = false
        broadcast.isHidden = true

        stackView.addArrangedSubview(broadcast)

        NSLayoutConstraint.activate([
            broadcast.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            broadcast.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])

        broadcast.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        broadcast.setContentHuggingPriority(.defaultHigh, for: .vertical)

        broadcast.layoutIfNeeded()
    }

    func remove(_ broadcast: Broadcast) {
        guard let subView = contentView.arrangedSubviews.filter({ $0 == broadcast }).first else {
            return
        }

        contentView.removeArrangedSubview(subView)
        subView.removeFromSuperview()
    }

    func removeContentViewSubviews() {
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
        if let delegate = delegate {
            let newContainerSize: CGSize = {
                let width = frame.width
                let isLastBroadcastToBeRemoved = contentView.arrangedSubviews.count == 1
                if isLastBroadcastToBeRemoved {
                    return CGSize(width: width, height: 0)
                } else {
                    let height = frame.height - (broadcast.frame.height + .mediumLargeSpacing)
                    return CGSize(width: width, height: height)
                }
            }()

            let broadcastIndex = contentView.arrangedSubviews.index(of: broadcast) ?? 0
            delegate.broadcastContainer(self, willDismissBroadcastAtIndex: broadcastIndex, withNewContainerSize: newContainerSize, commitToDismissal: {
                UIView.animate(withDuration: 0.2, animations: {
                    broadcast.isHidden = true
                }, completion: { [weak self] _ in
                    self?.remove(broadcast)
                })
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                broadcast.isHidden = true
            }, completion: { [weak self] _ in
                self?.remove(broadcast)
            })
        }
    }
}
