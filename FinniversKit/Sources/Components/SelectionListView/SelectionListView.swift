import UIKit

public protocol SelectionListViewDelegate: AnyObject {
    func selectionListView(_ view: SelectionListView, didToggleItemAtIndex index: Int, withIdentifier identifier: String?, isSelected: Bool)
}

public class SelectionListView: UIView {

    public enum Presentation {
        case checkboxes
        case radioButtons
    }

    // MARK: - Public properties

    public let presentation: Presentation
    public weak var delegate: SelectionListViewDelegate?

    public var hasSelection: Bool {
        itemViews.contains(where: { $0.isSelected })
    }

    public var selectedItems: [(index: Int, identifier: String?)] {
        itemViews.enumerated().map { index, itemView in
            guard itemView.isSelected else { return nil }

            return (index: index, identifier: itemView.model.identifier)
        }.compactMap { $0 }
    }
    
    public override var intrinsicContentSize: CGSize {
        stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }

    // MARK: - Private properties

    private let itemSpacing: CGFloat = 2
    private let cornerRadius: CGFloat = .spacingS
    private var itemViews = [SelectionListItemView]()
    private lazy var stackView = UIStackView(axis: .vertical, spacing: -itemSpacing, withAutoLayout: true)

    // MARK: - Init

    public init(presentation: Presentation, withAutoLayout: Bool) {
        self.presentation = presentation
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
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
        guard let itemView = itemViews[safe: index] else { return }
        toggle(itemView: itemView)
    }

    public func toggleSelection(forItemWithIdentifier identifier: String) {
        guard let itemView = itemViews.first(where: { $0.model.identifier == identifier }) else { return }
        toggle(itemView: itemView)
    }

    public func selectionState(forItemAtIndex index: Int) -> Bool {
        guard let itemView = itemViews[safe: index] else { return false }
        return itemView.isSelected
    }

    public func selectionState(forItemWithIdentifier identifier: String) -> Bool {
        guard let itemView = itemViews.first(where: { $0.model.identifier == identifier }) else { return false }
        return itemView.isSelected
    }

    public func configure(with models: [SelectionItemModel]) {
        // Make sure only the first item with ´isInitiallySelected´ is selected, if presentation == .radioButtons.
        var firstSelectedRadioButtonIndex: Int?
        if presentation == .radioButtons {
            firstSelectedRadioButtonIndex = models.firstIndex(where: { $0.isInitiallySelected })
        }

        let itemViews = models.enumerated().map { index, model -> SelectionListItemView in
            let configuration = SelectionListItemView.Configuration(
                spacing: itemSpacing,
                cornerRadius: cornerRadius,
                currentIndex: index,
                numberOfItems: models.count
            )

            var model = model
            if let firstSelectedRadioButtonIndex = firstSelectedRadioButtonIndex {
                model = model.override(isInitiallySelected: index == firstSelectedRadioButtonIndex)
            }

            let view = SelectionListItemView(
                model: model,
                configuration: configuration,
                presentation: presentation,
                withAutoLayout: true
            )

            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelectItem))
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(tapGestureRecognizer)

            return view
        }

        stackView.removeArrangedSubviews()

        self.itemViews = itemViews
        stackView.addArrangedSubviews(itemViews)
        invalidateIntrinsicContentSize()
    }

    // MARK: - Private methods

    private func toggle(itemView: SelectionListItemView) {
        switch presentation {
        case .checkboxes:
            itemView.isSelected.toggle()
        case .radioButtons:
            itemViews.forEach {
                $0.isSelected = $0 == itemView
            }
        }
    }

    // MARK: - Actions

    @objc private func didSelectItem(_ gestureRecognizer: UITapGestureRecognizer) {
        guard
            let itemView = gestureRecognizer.view as? SelectionListItemView,
            let viewIndex = itemViews.firstIndex(of: itemView)
        else { return }

        toggle(itemView: itemView)

        delegate?.selectionListView(self, didToggleItemAtIndex: viewIndex, withIdentifier: itemView.model.identifier, isSelected: itemView.isSelected)
    }
}

// MARK: - Private extensions

private extension SelectionListItemView.Configuration {
    init(spacing: CGFloat, cornerRadius: CGFloat, currentIndex: Int, numberOfItems: Int) {
        let lastIndex = numberOfItems - 1

        let position: SelectionListItemView.Position
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

private extension SelectionItemModel {
    func override(isInitiallySelected: Bool) -> Self {
        SelectionItemModel(
            identifier: identifier,
            title: title,
            description: description,
            icon: icon,
            isInitiallySelected: isInitiallySelected
        )
    }
}
