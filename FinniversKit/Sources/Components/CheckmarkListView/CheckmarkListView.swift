import UIKit

public protocol CheckmarkListViewDelegate: AnyObject {
    func checkmarkListView(_ view: CheckmarkListView, didToggleItemAtIndex index: Int)
}

public class CheckmarkListView: UIView {

    // MARK: - Public properties

    public weak var delegate: CheckmarkListViewDelegate?

    public override var intrinsicContentSize: CGSize {
        stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }

    // MARK: - Private properties

    private let itemSpacing: CGFloat = 2
    private let cornerRadius: CGFloat = .spacingS
    private lazy var stackView = UIStackView(axis: .vertical, spacing: -itemSpacing, withAutoLayout: true)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        layer.cornerRadius = cornerRadius
        backgroundColor = .bgTertiary
        addSubview(stackView)
        stackView.fillInSuperview()
    }

    // MARK: - Public methods

    public func toggleSelection(forItemAtIndex index: Int) {
        guard let itemView = stackView.arrangedSubviews[safe: index] as? CheckmarkItemView else { return }
        itemView.isSelected.toggle()
    }

    public func selectionState(forItemAtIndex index: Int) -> Bool {
        guard let itemView = stackView.arrangedSubviews[safe: index] as? CheckmarkItemView else { return false }
        return itemView.isSelected
    }

    public func configure(with models: [CheckmarkItemModel]) {
        let views = models.enumerated().map { index, model -> CheckmarkItemView in
            let configuration = CheckmarkItemView.Configuration(
                spacing: itemSpacing,
                cornerRadius: cornerRadius,
                currentIndex: index,
                numberOfItems: models.count
            )
            let view = CheckmarkItemView(model: model, configuration: configuration, withAutoLayout: true)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelectItem))
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(tapGestureRecognizer)
            return view
        }

        stackView.removeArrangedSubviews()
        stackView.addArrangedSubviews(views)
        invalidateIntrinsicContentSize()
    }

    // MARK: - Actions

    @objc private func didSelectItem(_ gestureRecognizer: UITapGestureRecognizer) {
        guard
            let itemView = gestureRecognizer.view as? CheckmarkItemView,
            let viewIndex = stackView.arrangedSubviews.firstIndex(of: itemView)
        else { return }

        itemView.isSelected.toggle()
        delegate?.checkmarkListView(self, didToggleItemAtIndex: viewIndex)
    }
}

// MARK: - Private extensions

private extension CheckmarkItemView.Configuration {
    init(spacing: CGFloat, cornerRadius: CGFloat, currentIndex: Int, numberOfItems: Int) {
        let lastIndex = numberOfItems - 1

        let position: CheckmarkItemView.Position
        switch (currentIndex, lastIndex) {
        case (0, 0):
            position = .theOnlyOne
        case (0, _):
            position = .first
        case (let a, let b) where a == b:
            position = .last
        default:
            position = .middle
        }

        self.init(spacing: spacing, cornerRadius: cornerRadius, position: position)
    }
}
