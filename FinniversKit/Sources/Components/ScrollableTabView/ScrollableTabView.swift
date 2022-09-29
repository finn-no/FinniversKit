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
            height: contentInset.top + labelHeight + 4 + contentInset.bottom
        )
    }

    // MARK: - Private properties

    private let itemSpacing: CGFloat = 32
    private let horizontalInset: CGFloat = 16
    private let contentInset: UIEdgeInsets = .init(top: 8, leading: 16, bottom: 12, trailing: 16)
    private lazy var contentView = UIStackView(axis: .horizontal, spacing: itemSpacing, withAutoLayout: true)
    private lazy var indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
    private lazy var indicatorViewWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: 0)

    private var labelHeight: CGFloat {
        UIFont.captionStrong.capHeight
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = .init(top: 0, leading: horizontalInset, bottom: 4, trailing: horizontalInset)
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
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            indicatorView.heightAnchor.constraint(equalToConstant: .spacingXS),
            indicatorViewLeadingConstraint,
            indicatorView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            indicatorViewWidthConstraint
        ])
    }

    // MARK: - Public methods

    public func configure(with viewModel: ScrollableTabViewModel) {
        contentView.removeArrangedSubviews()

        // The current implementation always makes the first item as selected
        viewModel.items.forEach { item in
            let itemView = ItemView(item: item, withAutoLayout: true)
            contentView.addArrangedSubview(itemView)
            itemView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleItemTap)))
        }

        contentView.layoutIfNeeded()

        if let firstItemView = contentView.arrangedSubviews.first as? ItemView {
            toggleSelection(newSelection: firstItemView)
        }
    }

    // MARK: - Private methods

    private func toggleSelection(newSelection: ItemView) {
        contentView.arrangedSubviews
            .compactMap { $0 as? ItemView }
            .forEach { $0.isSelected = $0 == newSelection }

        scrollView.scrollRectToVisible(newSelection.frame, animated: true)

        indicatorViewWidthConstraint.constant = newSelection.frame.width
        indicatorViewLeadingConstraint.constant = newSelection.frame.minX

        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: { [weak self] in
                self?.layoutIfNeeded()
            }
        )

        delegate?.scrollableTabViewDidTapItem(self, item: newSelection.item)
    }

    // MARK: - Actions

    @objc private func handleItemTap(sender: UITapGestureRecognizer) {
        guard let itemView = sender.view as? ItemView else { return }
        toggleSelection(newSelection: itemView)
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

    private lazy var titleLabel = Label(style: .captionStrong, withAutoLayout: true)

    // MARK: - Init

    init(item: ScrollableTabViewModel.Item, withAutoLayout: Bool) {
        self.item = item
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
