import UIKit

public protocol CheckboxSelectionViewDelegate: AnyObject {
    func checkboxSelectionView(_ view: CheckboxSelectionView, didToggleItemAtIndex index: Int)
}

public class CheckboxSelectionView: UIView {

    // MARK: - Public properties

    public weak var delegate: CheckboxSelectionViewDelegate?

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

    public func configure(with models: [CheckboxItemModel]) {
        let views = models.enumerated().map { index, model -> CheckboxItemView in
            let configuration = CheckboxItemView.Configuration(
                spacing: itemSpacing,
                cornerRadius: cornerRadius,
                currentIndex: index,
                numberOfItems: models.count
            )
            let view = CheckboxItemView(model: model, configuration: configuration, withAutoLayout: true)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelectItem))
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(tapGestureRecognizer)
            return view
        }

        stackView.removeArrangedSubviews()
        stackView.addArrangedSubviews(views)
    }

    // MARK: - Actions

    @objc private func didSelectItem(_ gestureRecognizer: UITapGestureRecognizer) {
        guard
            let itemView = gestureRecognizer.view as? CheckboxItemView,
            let viewIndex = stackView.arrangedSubviews.firstIndex(of: itemView)
        else { return }

        itemView.isSelected.toggle()
        delegate?.checkboxSelectionView(self, didToggleItemAtIndex: viewIndex)
    }
}

// MARK: - Private extensions

private extension CheckboxItemView.Configuration {
    init(spacing: CGFloat, cornerRadius: CGFloat, currentIndex: Int, numberOfItems: Int) {
        let lastIndex = numberOfItems - 1

        let position: CheckboxItemView.Position
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
