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

        axis = .vertical
        distribution = .fill
        alignment = .fill
    }

    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    public func presentMessages(_ messages: Set<BroadcastMessage>, in view: UIView? = nil, animated: Bool = true) {
        guard superview == nil else {
            add(messages, animated: animated)
            return
        }

        guard let view = view else { return }

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
    func remove(_ item: BroadcastItem) {
        item.heightConstraint.constant = 0
        item.heightConstraint.isActive = true

        UIView.animate(withDuration: animationDuration, animations: {
            item.alpha = 0

            self.superview?.layoutIfNeeded()
            self.scrollView?.contentInset.top = self.frame.height
            self.scrollView?.contentOffset.y = -self.frame.height

        }) { completed in
            item.removeFromSuperview()
            if self.subviews.count == 0 {
                self.removeFromSuperview()
                self.topConstraint = nil

                guard let scrollView = self.scrollView else { return }
                scrollView.addGestureRecognizer(scrollView.panGestureRecognizer)
                self.scrollView = nil
            }
        }
    }

    func add(_ messages: Set<BroadcastMessage>, animated: Bool) {
        guard let superview = superview else { return }

        for message in messages {
            let item = BroadcastItem(message: message)
            item.delegate = self
            item.isHidden = animated // Need to hide for animation to work properly
            insertArrangedSubview(item, at: 0)
        }

        if animated {
            arrangedSubviews.forEach { view in view.isHidden = false }
            updateConstraintsIfNeeded()

            let deltaHeight = systemLayoutSizeFitting(UILayoutFittingCompressedSize).height - frame.height
            topConstraint?.constant = -deltaHeight
            superview.layoutIfNeeded()
            topConstraint?.constant = 0

            // Animate down from the top
            UIView.animate(withDuration: animationDuration) {
                self.appearAnimation()
            }
        } else {
            self.appearAnimation()
        }
    }

    func appearAnimation() {
        superview?.layoutIfNeeded()
        scrollView?.contentInset.top = frame.height
        scrollView?.contentOffset.y = -frame.height
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
