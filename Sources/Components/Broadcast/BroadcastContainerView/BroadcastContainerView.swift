//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol BroadcastContainerViewDelegate: class {
    func broadcastContainer(_ broadcastContainerView: BroadcastContainerView, willDisplayBroadcastViews broadcastViews: [BroadcastView], withContainerSize containerSize: CGSize, commitToDisplaying: @escaping (() -> Void))
    func broadcastContainer(_ broadcastContainerView: BroadcastContainerView, willDismissBroadcastView broadcastView: BroadcastView, withNewContainerSize newContainerSize: CGSize, commitToDismissal: @escaping (() -> Void))
}

public protocol BroadcastContainerViewDataSource: class {
    func numberOfBroadcastMessagesToDisplay(in broadcastContainerView: BroadcastContainerView) -> Int
    func broadcastContainerView(_ broadcastContainerView: BroadcastContainerView, broadcastMessageForIndex index: Int) -> BroadcastViewMessage
}

public final class BroadcastContainerView: UIView {
    public weak var dataSource: BroadcastContainerViewDataSource?
    public weak var delegate: BroadcastContainerViewDelegate?

    private struct LayoutConstants {
        struct ContentView {
            static let insets = Insets(top: .mediumLargeSpacing, leading: .mediumLargeSpacing, bottom: 0, trailing: .mediumLargeSpacing)
        }

        struct BroadcastView {
            static let spacing: CGFloat = .mediumLargeSpacing
        }
    }

    private lazy var contentView: UIStackView = {
        let view = UIStackView(frame: .zero)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = LayoutConstants.BroadcastView.spacing
        view.distribution = .fillProportionally

        return view
    }()

    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension BroadcastContainerView {
    func setup() {
        addSubview(contentView)

        let insets = LayoutConstants.ContentView.insets

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.leading),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: insets.trailing),
        ])
    }

    func layoutBroadcastViews(from broadcastViewMessages: [BroadcastViewMessage]) -> [BroadcastView] {
        let broadcastViews = broadcastViewMessages.map { broadastView(from: $0) }

        broadcastViews.forEach { add($0, to: contentView) }

        return broadcastViews
    }

    func broadastView(from broadcastViewMessage: BroadcastViewMessage) -> BroadcastView {
        let broadcastView = BroadcastView(frame: .zero)

        // Set the message on the broadcast view and prepare it in its expanded state
        broadcastView.present(message: broadcastViewMessage.message, animated: false)

        return broadcastView
    }

    func add(_ broadcastView: BroadcastView, to stackView: UIStackView) {
        broadcastView.translatesAutoresizingMaskIntoConstraints = false
        broadcastView.isHidden = true

        let tapRecogninzer = UITapGestureRecognizer(target: self, action: #selector(broadcastViewTapped(_:)))
        broadcastView.addGestureRecognizer(tapRecogninzer)

        stackView.addArrangedSubview(broadcastView)

        NSLayoutConstraint.activate([
            broadcastView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            broadcastView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
    }

    func remove(_ broadcastView: BroadcastView) {
        guard let subView = contentView.arrangedSubviews.filter({ $0 == broadcastView }).first else {
            return
        }

        contentView.removeArrangedSubview(subView)
        subView.removeFromSuperview()
    }

    func reset() {
        contentView.arrangedSubviews.forEach { view in
            contentView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }

    @objc private func broadcastViewTapped(_ sender: UIGestureRecognizer) {
        guard let broadcastView = sender.view as? BroadcastView else {
            return
        }

        let newContainerSize: CGSize = {
            let width = frame.width
            if contentView.arrangedSubviews.count == 1 { // This is the last broadcast that soon will be removed
                return CGSize(width: width, height: 0)
            } else {
                let height = frame.height - broadcastView.frame.height

                return CGSize(width: width, height: height)
            }
        }()

        delegate?.broadcastContainer(self, willDismissBroadcastView: broadcastView, withNewContainerSize: newContainerSize, commitToDismissal: {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                broadcastView.isHidden = true
                self?.remove(broadcastView)
            })
        })
    }
}

// MARK: - Public

extension BroadcastContainerView {
    func reload() {
        guard let dataSource = dataSource else {
            return
        }

        reset()

        let rangeOfBroadcastMessagesToDisplay = 0 ..< dataSource.numberOfBroadcastMessagesToDisplay(in: self)
        let broadcastMessagesToDisplay = rangeOfBroadcastMessagesToDisplay.map { dataSource.broadcastContainerView(self, broadcastMessageForIndex: $0) }

        if broadcastMessagesToDisplay.isEmpty {
            return
        }

        let laidOutBroadcastViews = layoutBroadcastViews(from: broadcastMessagesToDisplay)

        delegate?.broadcastContainer(self, willDisplayBroadcastViews: laidOutBroadcastViews, withContainerSize: intrinsicContentSize, commitToDisplaying: {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.contentView.arrangedSubviews.forEach { $0.isHidden = false }
            })
        })
    }

    public override var intrinsicContentSize: CGSize {
        guard contentView.arrangedSubviews.count != 0 else {
            return CGSize(width: frame.size.width, height: 0)
        }

        let broadcastViewsHorizontalSpacings = LayoutConstants.ContentView.insets.leading + abs(LayoutConstants.ContentView.insets.trailing)
        let constrainedWidth = frame.size.width - broadcastViewsHorizontalSpacings

        let broadcastViewsTotalHeight = contentView.arrangedSubviews.reduce(CGFloat(0), { acc, view in
            guard let broadcastView = view as? BroadcastView else {
                return acc
            }

            let broadcastViewHeight = broadcastView.calculatedSize(withConstrainedWidth: constrainedWidth).height

            return acc + broadcastViewHeight
        })

        guard broadcastViewsTotalHeight != 0 else {
            return CGSize(width: frame.size.width, height: 0)
        }

        let broadcastViewTotalSpacing = ((CGFloat(contentView.arrangedSubviews.count) * LayoutConstants.BroadcastView.spacing) - .mediumLargeSpacing)
        let verticalSpacing = LayoutConstants.ContentView.insets.top + broadcastViewTotalSpacing
        let containerHeight = broadcastViewsTotalHeight + verticalSpacing

        return CGSize(width: frame.size.width, height: containerHeight)
    }
}
