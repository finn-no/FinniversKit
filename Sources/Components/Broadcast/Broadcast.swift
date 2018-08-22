//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol BroadcastDelegate: class {
    func broadcast(_ broadcast: Broadcast, didDismiss message: BroadcastMessage)
    func broadcast(_ broadcast: Broadcast, didTapURL url: URL, inItemAtIndex index: Int)
}

// MARK: - Public

public final class Broadcast: UIStackView {

    // MARK: Public properties

    public weak var delegate: BroadcastDelegate?

    // MARK: - Private properties

    private weak var scrollView: UIScrollView?
    private var topConstraint: NSLayoutConstraint?
    private var animationDuration = 0.3

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        spacing = .mediumLargeSpacing

        axis = .vertical
        distribution = .fill
        alignment = .fill
        layoutMargins = UIEdgeInsets(top: .mediumLargeSpacing, leading: .mediumLargeSpacing, bottom: 0, trailing: .mediumLargeSpacing)
        isLayoutMarginsRelativeArrangement = true
    }

    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    public func presentMessages(_ messages: Set<BroadcastMessage>, in view: UIView, animated: Bool = true) {
        guard superview == nil else {
            add(messages, animated: animated)
            return
        }

        // This might have been set to zero, reset it
        layoutMargins.top = .mediumLargeSpacing

        if let scrollView = view as? UIScrollView {
            self.scrollView = scrollView
            // Add container on top of scroll view
            scrollView.superview?.addSubview(self)
            // Moving gesture to superview enables scrolling inside the broadcast container as well
            superview?.addGestureRecognizer(scrollView.panGestureRecognizer)
        } else {
            view.addSubview(self)
        }

        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topConstraint = topAnchor.constraint(equalTo: view.topAnchor)
        topConstraint?.isActive = true

        add(messages, animated: animated)
    }

    // Can't override scrollView delegate so have to called this method from the outside
    public func handleScrolling() {
        guard let scrollView = scrollView else { return }

        let offset = scrollView.contentInset.top + scrollView.contentOffset.y

        if offset > 2 * frame.height {
            isHidden = true
            return
        }

        isHidden = false
        topConstraint?.constant = -offset
    }
}

// MARK: - Private

private extension Broadcast {
    func remove(_ broadcast: BroadcastItem) {
        UIView.animate(withDuration: animationDuration, animations: {
            if self.subviews.count == 1 {
                self.layoutMargins.top = 0
            }

            broadcast.isHidden = true
            broadcast.alpha = 0

            self.layoutIfNeeded()
            self.scrollView?.contentInset.top = self.frame.height
            self.scrollView?.contentOffset.y = -self.frame.height

        }) { completed in
            broadcast.removeFromSuperview()
            if self.subviews.count == 0 {
                self.removeFromSuperview()

                guard let scrollView = self.scrollView else { return }
                scrollView.addGestureRecognizer(scrollView.panGestureRecognizer)
                self.scrollView = nil
            }
        }
    }

    func add(_ messages: Set<BroadcastMessage>, animated: Bool = true) {
        guard let superview = superview else { return }

        for message in messages {
            let item = BroadcastItem(message: message)
            item.delegate = self
            item.isHidden = animated // Need to hide for animation to work properly
            insertArrangedSubview(item, at: 0)
        }

        if animated {
            arrangedSubviews.forEach { view in view.isHidden = false }
            let deltaHeight = systemLayoutSizeFitting(UILayoutFittingCompressedSize).height - frame.height
            topConstraint?.constant = -deltaHeight
            superview.layoutIfNeeded()
            topConstraint?.constant = 0

            // Animate down from the top
            UIView.animate(withDuration: animationDuration) {
                superview.layoutIfNeeded()
                self.scrollView?.contentInset.top = self.frame.height
                self.scrollView?.contentOffset.y = -self.frame.height
            }
        } else {
            superview.layoutIfNeeded()
            scrollView?.contentInset.top = self.frame.height
            scrollView?.contentOffset.y = -self.frame.height
        }
    }
}

// MARK: - BroadcastDelegate

extension Broadcast: BroadcastItemDelegate {
    func broadcastItemDismissButtonTapped(_ broadcastItem: BroadcastItem) {
        remove(broadcastItem)
        delegate?.broadcast(self, didDismiss: broadcastItem.message)
    }

    func broadcastItem(_ broadcastItem: BroadcastItem, didTapURL url: URL) {
        let broadcastIndex = arrangedSubviews.index(of: broadcastItem) ?? 0
        delegate?.broadcast(self, didTapURL: url, inItemAtIndex: broadcastIndex)
    }
}
