//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

extension UITableViewCell: Identifiable {}

extension UITableViewHeaderFooterView: Identifiable {}

public extension UITableView {
    func register(_ cellClass: UITableViewCell.Type) {
        register(cellClass.self, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }

    func register(_ headerFooterClass: UITableViewHeaderFooterView.Type) {
        register(headerFooterClass.self, forHeaderFooterViewReuseIdentifier: headerFooterClass.reuseIdentifier)
    }

    func registerNib(_ cellClass: UITableViewCell.Type, bundle: Bundle? = nil) {
        register(UINib(nibName: String(describing: cellClass), bundle: bundle), forCellReuseIdentifier: cellClass.reuseIdentifier)
    }

    func dequeue<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T where T: UITableViewCell {
        // swiftlint:disable:next force_cast
        return dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier, for: indexPath) as! T
    }

    func dequeue<T>(_ headerFooterClass: T.Type) -> T where T: UITableViewHeaderFooterView {
        // swiftlint:disable:next force_cast
        return dequeueReusableHeaderFooterView(withIdentifier: headerFooterClass.reuseIdentifier) as! T
    }

    func stopScrolling() {
        setContentOffset(contentOffset, animated: false)
    }
}

extension UITableView {
    var isScrolling: Bool {
        isTracking || isDragging || isDecelerating
    }

    func firstFullyVisibleCell(where isIncluded: (IndexPath) -> Bool) -> UITableViewCell? {
        let visibleRect = bounds.inset(by: adjustedContentInset)
        for indexPath in (indexPathsForVisibleRows ?? []).sorted() where isIncluded(indexPath) {
            guard let cell = cellForRow(at: indexPath), visibleRect.contains(cell.frame) else { continue }
            let headerMaxY = headerView(forSection: indexPath.section)?.frame.maxY ?? -.greatestFiniteMagnitude
            if cell.frame.minY >= headerMaxY {
                return cell
            }
        }
        return nil
    }
}

public extension UITableView {
    @discardableResult
    func peekTrailingSwipeActions(at indexPath: IndexPath, delay: TimeInterval = 0) -> Bool {
        guard canPeekTrailingSwipeActions(at: indexPath) else { return false }

        guard delay > 0 else {
            startTrailingSwipeActionsPeek(at: indexPath)
            return true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self, canPeekTrailingSwipeActions(at: indexPath) else { return }
            startTrailingSwipeActionsPeek(at: indexPath)
        }
        return true
    }
}

private extension UITableView {
    func canPeekTrailingSwipeActions(at indexPath: IndexPath) -> Bool {
        guard
            !isEditing,
            !isScrolling,
            window != nil,
            !UIAccessibility.isReduceMotionEnabled,
            !UIAccessibility.isVoiceOverRunning,
            let cell = cellForRow(at: indexPath),
            !cell.subviews.contains(where: { $0 is SwipeActionsPeekView }),
            let actions = delegate?.tableView?(self, trailingSwipeActionsConfigurationForRowAt: indexPath)?.actions
        else { return false }
        return !actions.isEmpty
    }

    func startTrailingSwipeActionsPeek(at indexPath: IndexPath) {
        guard
            let cell = cellForRow(at: indexPath),
            let actions = delegate?.tableView?(self, trailingSwipeActionsConfigurationForRowAt: indexPath)?.actions
        else { return }

        let isRightToLeft = effectiveUserInterfaceLayoutDirection == .rightToLeft
        let contentView = cell.contentView
        let peekView = SwipeActionsPeekView(actions: actions, isRightToLeft: isRightToLeft)
        let peekWidth = min(peekView.preferredWidth, cell.bounds.width * SwipeActionsPeekView.maximumWidthRatio)
        var slidingView: UIView?

        UIView.performWithoutAnimation {
            cell.layoutIfNeeded()
            guard let snapshot = contentView.snapshotView(afterScreenUpdates: false) else { return }
            snapshot.frame = contentView.frame
            snapshot.backgroundColor = contentView.backgroundColor ?? cell.backgroundColor ?? backgroundColor ?? .background
            peekView.frame = CGRect(
                x: isRightToLeft ? 0 : cell.bounds.width - peekWidth,
                y: 0,
                width: peekWidth,
                height: cell.bounds.height
            )
            cell.addSubview(peekView)
            cell.addSubview(snapshot)
            peekView.layoutIfNeeded()
            contentView.isHidden = true
            slidingView = snapshot
        }
        guard let slidingView else {
            peekView.removeFromSuperview()
            return
        }
        cell.isUserInteractionEnabled = false

        let restore = { [weak cell, weak peekView, weak slidingView] in
            contentView.isHidden = false
            cell?.isUserInteractionEnabled = true
            slidingView?.removeFromSuperview()
            peekView?.removeFromSuperview()
        }
        let revealOffset = isRightToLeft ? peekWidth : -peekWidth
        let origin = slidingView.center

        let reveal = UIViewPropertyAnimator(duration: SwipeActionsPeekView.revealDuration, curve: .easeOut) {
            slidingView.center = CGPoint(x: origin.x + revealOffset, y: origin.y)
        }
        let hide = UIViewPropertyAnimator(duration: SwipeActionsPeekView.hideDuration, curve: .easeInOut) {
            slidingView.center = origin
        }
        hide.addCompletion { _ in restore() }
        reveal.addCompletion { _ in
            hide.startAnimation(afterDelay: SwipeActionsPeekView.holdDuration)
        }
        reveal.startAnimation()
    }
}

final class SwipeActionsPeekView: UIView {
    static let maximumWidthRatio: CGFloat = 0.7
    static let revealDuration: TimeInterval = 0.45
    static let holdDuration: TimeInterval = 0.9
    static let hideDuration: TimeInterval = 0.35

    private static let minimumActionWidth: CGFloat = 72
    private static let horizontalPadding: CGFloat = Warp.Spacing.spacing100

    private let actionViews: [UIView]
    private let actionWidths: [CGFloat]

    var preferredWidth: CGFloat {
        actionWidths.reduce(0, +)
    }

    init(actions: [UIContextualAction], isRightToLeft: Bool) {
        let views = actions.map(Self.makeActionView)
        let widths = views.map { max(Self.minimumActionWidth, $0.intrinsicContentSize.width + Self.horizontalPadding * 2) }
        let leadingFirst = isRightToLeft ? Array(zip(views, widths)) : Array(zip(views, widths).reversed())
        actionViews = leadingFirst.map(\.0)
        actionWidths = leadingFirst.map(\.1)
        super.init(frame: .zero)
        isUserInteractionEnabled = false
        clipsToBounds = true
        isAccessibilityElement = false
        accessibilityElementsHidden = true
        actionViews.forEach(addSubview)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let scale = preferredWidth > 0 ? bounds.width / preferredWidth : 0
        var originX: CGFloat = 0
        for (view, width) in zip(actionViews, actionWidths) {
            let scaledWidth = width * scale
            view.frame = CGRect(x: originX, y: 0, width: scaledWidth, height: bounds.height)
            originX += scaledWidth
        }
    }

    private static func makeActionView(for action: UIContextualAction) -> UIView {
        let fill = action.backgroundColor ?? .clear
        let hasFill = fill.cgColor.alpha > 0
        let foreground = hasFill ? Warp.UIToken.iconInverted : Warp.UIToken.text

        let imageView = UIImageView(image: hasFill ? action.image?.withRenderingMode(.alwaysTemplate) : action.image)
        imageView.tintColor = foreground
        imageView.contentMode = .center

        let titleLabel = UILabel()
        titleLabel.text = action.title
        titleLabel.font = Warp.Typography.detail.uiFont
        titleLabel.textColor = hasFill ? Warp.UIToken.textInverted : Warp.UIToken.text
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontForContentSizeCategory = true

        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel].filter { view in
            (view as? UILabel)?.text?.isEmpty == false || (view as? UIImageView)?.image != nil
        })
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Warp.Spacing.spacing50
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let container = ActionContainerView(contentView: stackView)
        container.backgroundColor = fill
        return container
    }
}

private final class ActionContainerView: UIView {
    private let contentView: UIView

    init(contentView: UIView) {
        self.contentView = contentView
        super.init(frame: .zero)
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            contentView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
