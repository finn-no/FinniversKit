//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol BroadcastDelegate: AnyObject {
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
    private var messages: Set<BroadcastMessage> = []

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
            self.messages.formUnion(messages)
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

        self.messages.formUnion(messages)
        add(messages, animated: animated)
    }

    public func removeMessages(_ messages: Set<BroadcastMessage>) -> Set<BroadcastMessage> {
        guard !messages.isEmpty else { return [] }
        guard let items = arrangedSubviews as? [BroadcastItem] else { return [] }

        let messagesToRemove = self.messages.intersection(messages)

        let itemsToRemove = items.filter { (item) -> Bool in
            return messagesToRemove.contains(item.message)
        }

        for item in itemsToRemove {
            remove(item, animated: false)
        }

        self.messages.subtract(messagesToRemove)
        return messagesToRemove
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
    func remove(_ item: BroadcastItem, animated: Bool = true) {
        item.heightConstraint.constant = 0
        item.heightConstraint.isActive = true

        UIView.animate(withDuration: animated ? animationDuration : 0, animations: {
            item.alpha = 0
            self.animate(to: nil) // keep current content offset

        }, completion: { _ in
            item.removeFromSuperview()
            if self.subviews.count == 0 {
                self.removeFromSuperview()
                self.topConstraint = nil

                guard let scrollView = self.scrollView else { return }
                scrollView.addGestureRecognizer(scrollView.panGestureRecognizer)
                self.scrollView = nil
            }
        })
    }

    func add(_ messages: Set<BroadcastMessage>, animated: Bool) {
        guard let superview = superview else { return }

        var contentOffset: CGFloat = 0
        if let scrollView = scrollView {
            contentOffset = scrollView.contentInset.top + scrollView.contentOffset.y
        }

        insert(messages)

        arrangedSubviews.forEach { view in view.isHidden = false }
        updateConstraintsIfNeeded()

        let nextSize = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let deltaHeight = nextSize.height - frame.height

        if nextSize.height - contentOffset < 0 {
            // Broadcast is not visuable inside scrollview
            isHidden = true
            animate(to: nil)
            return
        }

        // Visuable
        topConstraint?.constant = -contentOffset - deltaHeight
        superview.layoutIfNeeded()

        if animated {
            topConstraint?.constant = -contentOffset

            // Animate down from the top
            UIView.animate(withDuration: animationDuration) {
                self.animate(to: contentOffset - self.frame.height)
            }
        } else {
            topConstraint?.constant = -contentOffset
            animate(to: contentOffset - frame.height)
        }
    }

    func insert(_ messages: Set<BroadcastMessage>) {
        for message in messages {
            let item = BroadcastItem(message: message)
            item.delegate = self
            item.isHidden = true
            insertArrangedSubview(item, at: 0)
        }
    }

    func animate(to offset: CGFloat?) {
        scrollView?.contentInset.top = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        if let offset = offset { scrollView?.contentOffset.y = offset }
        superview?.layoutIfNeeded()
    }
}

// MARK: - BroadcastDelegate

extension Broadcast: BroadcastItemDelegate {
    func broadcastItemDismissButtonTapped(_ broadcastItem: BroadcastItem) {
        remove(broadcastItem)
        messages.remove(broadcastItem.message)
        delegate?.broadcast(self, didDismiss: broadcastItem.message)
    }

    func broadcastItem(_ broadcastItem: BroadcastItem, didTapURL url: URL) {
        let broadcastIndex = arrangedSubviews.firstIndex(of: broadcastItem) ?? 0
        delegate?.broadcast(self, didTapURL: url, inItemAtIndex: broadcastIndex)
    }
}
