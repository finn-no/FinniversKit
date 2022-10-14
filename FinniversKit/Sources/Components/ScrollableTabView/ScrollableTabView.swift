import Combine
import UIKit

public protocol ScrollableTabViewDelegate: AnyObject {
    func scrollableTabViewDidTapItem(_ sidescrollableView: ScrollableTabView, item: ScrollableTabViewModel.Item)
}

public class ScrollableTabView: UIView {

    // MARK: - Public properties

    public weak var delegate: ScrollableTabViewDelegate?

    public override var intrinsicContentSize: CGSize {
        CGSize(
            width: UIView.noIntrinsicMetric,
            height: labelHeight + indicatorHeight + (verticalPadding * 2)
        )
    }

    // MARK: - Private properties

    private let labelStyle = Label.Style.captionStrong
    private let itemSpacing: CGFloat = 32
    private let verticalPadding = CGFloat.spacingS
    private let indicatorHeight: CGFloat = 4
    private var currentViewModel: ScrollableTabViewModel?
    private var indicatorViewLeadingConstraint: NSLayoutConstraint?
    private var indicatorViewTrailingConstraint: NSLayoutConstraint?
    private lazy var contentView = UIStackView(axis: .horizontal, spacing: itemSpacing, withAutoLayout: true)

    private var labelHeight: CGFloat {
        "I".height(withConstrainedWidth: .greatestFiniteMagnitude, font: labelStyle.font)
    }

    private var itemViews: [ItemView] {
        contentView.arrangedSubviews.compactMap { $0 as? ItemView }
    }

    private var selectedItemView: ItemView? {
        itemViews.first { $0.isSelected }
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = .init(vertical: 0, horizontal: .spacingM)
        scrollView.alwaysBounceHorizontal = true
        return scrollView
    }()

    private lazy var indicatorView: UIView = {
        let indicatorView = UIView(withAutoLayout: true)
        indicatorView.backgroundColor = .primaryBlue
        return indicatorView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.addSubview(indicatorView)

        scrollView.fillInSuperview()

        NSLayoutConstraint.activate([
            // Bind the stackView to the scroll view's content layout guide to
            // set the content size.
            contentView.topAnchor.constraint(equalTo: scrollView.frameLayoutGuide.topAnchor, constant: verticalPadding),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.frameLayoutGuide.bottomAnchor, constant: -verticalPadding),

            indicatorView.heightAnchor.constraint(equalToConstant: indicatorHeight),
            indicatorView.bottomAnchor.constraint(equalTo: scrollView.frameLayoutGuide.bottomAnchor),
        ])
    }

    // MARK: - Public methods

    public func configure(with viewModel: ScrollableTabViewModel) {
        guard viewModel != currentViewModel else { return }
        currentViewModel = viewModel
        contentView.removeArrangedSubviews()

        viewModel.items.forEach { item in
            let itemView = ItemView(item: item, labelStyle: labelStyle, withAutoLayout: true)
            contentView.addArrangedSubview(itemView)
            itemView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleItemTap)))
        }

        contentView.layoutIfNeeded()

        if let selectedIdentifier = viewModel.selectedIdentifier, let selectedView = itemViews.first(where: { $0.item.identifier == selectedIdentifier }) {
            toggleSelection(newSelection: selectedView, notifyDelegate: false)
        } else if let firstItemView = itemViews.first {
            toggleSelection(newSelection: firstItemView, notifyDelegate: false)
        }

        invalidateIntrinsicContentSize()
        layoutIfNeeded()
    }

    // MARK: - Overrides

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            invalidateIntrinsicContentSize()
            redrawIndicator(animate: false)
        }
    }

    // MARK: - Private methods

    private func toggleSelection(newSelection: ItemView, notifyDelegate: Bool) {
        if selectedItemView == newSelection { return }
        itemViews.forEach { $0.isSelected = $0 == newSelection }
        scrollView.scrollRectToVisible(newSelection.frame, animated: true)
        redrawIndicator(animate: true)

        if notifyDelegate {
            delegate?.scrollableTabViewDidTapItem(self, item: newSelection.item)
        }
    }

    private func redrawIndicator(animate: Bool) {
        guard let selectedItemView = selectedItemView else { return }

        indicatorViewLeadingConstraint?.isActive = false
        indicatorViewTrailingConstraint?.isActive = false

        indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: selectedItemView.leadingAnchor)
        indicatorViewTrailingConstraint = indicatorView.trailingAnchor.constraint(equalTo: selectedItemView.trailingAnchor)

        indicatorViewLeadingConstraint?.isActive = true
        indicatorViewTrailingConstraint?.isActive = true

        if animate {
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: .curveEaseOut,
                animations: { [weak self] in
                    self?.layoutIfNeeded()
                }
            )
        } else {
            layoutIfNeeded()
        }
    }

    // MARK: - Actions

    @objc private func handleItemTap(sender: UITapGestureRecognizer) {
        guard let itemView = sender.view as? ItemView else { return }
        toggleSelection(newSelection: itemView, notifyDelegate: true)
    }
}

// MARK: - Private types / extensions

private class ItemView: UIView {

    // MARK: - Internal properties

    let item: ScrollableTabViewModel.Item

    var isSelected: Bool = false {
        didSet {
            titleLabel.textColor = isSelected ? .textPrimary : .stone
        }
    }

    // MARK: - Private properties

    private let labelStyle: Label.Style
    private lazy var titleLabel = Label(style: labelStyle, withAutoLayout: true)

    // MARK: - Init

    init(item: ScrollableTabViewModel.Item, labelStyle: Label.Style, withAutoLayout: Bool) {
        self.item = item
        self.labelStyle = labelStyle
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        titleLabel.text = item.title
        addSubview(titleLabel)
        titleLabel.fillInSuperview()
    }
}
