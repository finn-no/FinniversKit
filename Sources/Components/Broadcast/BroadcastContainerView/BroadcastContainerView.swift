//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol BroadcastContainerViewDelegate: class {
    
    /// Called when the BroadcastContainerView is about to display its broadcasts
    ///
    /// - Parameters:
    ///   - broadcastContainerView: the BroadcastContainerView
    ///   - containerSize: the size that the BroadcastContainerView will have when the broadcasts are displayed
    ///   - commitToDisplaying: a closure that must be called in order for the BroadcastContainerView to display its broadcasts
    func broadcastContainer(_ broadcastContainerView: BroadcastContainerView, willDisplayBroadcastsWithContainerSize containerSize: CGSize, commitToDisplaying: @escaping (() -> Void))
    
    
    /// Called when the BroadcastContainerView is about to dismiss a broadcast
    ///
    /// - Parameters:
    ///   - broadcastContainerView: the BroadcastContainerView
    ///   - index: the index of the broadcast that is about to be dismissed
    ///   - newContainerSize: the size that the BroadcastContainerView will have when the broadcast is dismissed
    ///   - commitToDismissal: a closure that must be called in order for the BroadcastContainerView to dismiss the broadcast
    func broadcastContainer(_ broadcastContainerView: BroadcastContainerView, willDismissBroadcastAtIndex index: Int, withNewContainerSize newContainerSize: CGSize, commitToDismissal: @escaping (() -> Void))
}

public protocol BroadcastContainerViewDataSource: class {
    
    /// The number of broadcasts to display in the BroadcastContainerView
    ///
    /// - Parameter broadcastContainerView: the BroadcastContainerView
    /// - Returns: The number of broadcasts to display in the BroadcastContainerView
    func numberOfBroadcastsToDisplay(in broadcastContainerView: BroadcastContainerView) -> Int
    
    
    /// The broadcast to display at the index
    ///
    /// - Parameters:
    ///   - broadcastContainerView: the BroadcastContainerView
    ///   - index: the index for the broadcast
    /// - Returns: The broadcast to display at the index
    func broadcastContainerView(_ broadcastContainerView: BroadcastContainerView, broadcastForIndex index: Int) -> Broadcast
}


/// A view that is used to display multiple BroadcastViews
public final class BroadcastContainerView: UIView {
    private struct LayoutConstants {
        struct ContentView {
            static let insets = Insets(top: .mediumLargeSpacing, leading: .mediumLargeSpacing, bottom: 0, trailing: .mediumLargeSpacing)
        }

        struct BroadcastView {
            static let spacing: CGFloat = .mediumLargeSpacing
        }
    }

    
    /// The datasource for the BroadcastContainerView
    public weak var dataSource: BroadcastContainerViewDataSource? {
        didSet {
            reload()
        }
    }

    
    /// The delegate of the BroadcastContainerView
    public weak var delegate: BroadcastContainerViewDelegate?

    private lazy var contentView: UIStackView = {
        let view = UIStackView(frame: .zero)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = LayoutConstants.BroadcastView.spacing
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

public extension BroadcastContainerView {
    
    /// Reloads the container by removing existing broadcasts and laying out all the broadcasts that the datasource provides
    func reload() {
        guard let dataSource = dataSource else {
            return
        }

        reset()

        let rangeOfBroadcastsToDisplay = 0 ..< dataSource.numberOfBroadcastsToDisplay(in: self)
        let broadcastToDisplay = rangeOfBroadcastsToDisplay.map { dataSource.broadcastContainerView(self, broadcastForIndex: $0) }

        if broadcastToDisplay.isEmpty {
            return
        }

        layoutBroadcastViews(from: broadcastToDisplay)

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

// MARK: - Private

private extension BroadcastContainerView {
    func setup() {
        contentView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 0)

        addSubview(contentView)

        let insets = LayoutConstants.ContentView.insets

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.leading),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: insets.trailing),
        ])

        contentView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        contentView.setContentHuggingPriority(.defaultHigh, for: .vertical)

        contentView.layoutIfNeeded()
    }

    func layoutBroadcastViews(from broadcasts: [Broadcast]) {
        let broadcastViews = broadcasts.map { broadcastView(from: $0) }

        broadcastViews.forEach { add($0, to: contentView) }
    }

    func broadcastView(from broadcast: Broadcast) -> BroadcastView {
        let broadcastView = BroadcastView(frame: .zero)

        // Set the message on the broadcast view and prepare it in its expanded state
        broadcastView.present(message: broadcast.message, animated: false)

        return broadcastView
    }

    func add(_ broadcastView: BroadcastView, to stackView: UIStackView) {
        broadcastView.translatesAutoresizingMaskIntoConstraints = false
        broadcastView.isHidden = true

        stackView.addArrangedSubview(broadcastView)

        NSLayoutConstraint.activate([
            broadcastView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            broadcastView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])

        broadcastView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        broadcastView.setContentHuggingPriority(.defaultHigh, for: .vertical)

        let tapRecogninzer = UITapGestureRecognizer(target: self, action: #selector(broadcastViewTapped(_:)))
        broadcastView.addGestureRecognizer(tapRecogninzer)

        broadcastView.layoutIfNeeded()
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

        if let delegate = delegate {
            let newContainerSize: CGSize = {
                let width = frame.width
                if contentView.arrangedSubviews.count == 1 { // This is the last broadcast that soon will be removed
                    return CGSize(width: width, height: 0)
                } else {
                    let height = frame.height - broadcastView.frame.height

                    return CGSize(width: width, height: height)
                }
            }()

            let broadcastViewMessageIndex = contentView.arrangedSubviews.index(of: broadcastView) ?? 0

            delegate.broadcastContainer(self, willDismissBroadcastAtIndex: broadcastViewMessageIndex, withNewContainerSize: newContainerSize, commitToDismissal: {
                UIView.animate(withDuration: 0.2, animations: {
                    broadcastView.isHidden = true
                }, completion: { [weak self] _ in
                    self?.remove(broadcastView)
                })
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                broadcastView.isHidden = true
            }, completion: { [weak self] _ in
                self?.remove(broadcastView)
            })
        }
    }
}
