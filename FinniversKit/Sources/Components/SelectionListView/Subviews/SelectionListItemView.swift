import UIKit

class SelectionListItemView: UIView {

    // MARK: - Internal properties

    let model: SelectionItemModel

    var isSelected: Bool = false {
        didSet {
            updateSelection(shouldAnimate: true)
        }
    }

    // MARK: - Private properties

    private let configuration: Configuration
    private let presentation: SelectionListView.Presentation
    private lazy var contentView = UIView(withAutoLayout: true)
    private lazy var selectionView = presentation.selectionView
    private lazy var textStackView = UIStackView(axis: .vertical, spacing: .spacingXS, withAutoLayout: true)
    private lazy var detailViewsStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
    private lazy var detailViewsStackViewBottomConstraint = detailViewsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

    private lazy var titleLabel: Label = {
        let label = Label(style: .captionStrong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: HTMLLabel = {
        let label = HTMLLabel(style: .caption, withAutoLayout: true)
        label.textColor = .textSecondary
        label.numberOfLines = 0
        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.tintColor = .textPrimary
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()

    // MARK: - Init

    init(model: SelectionItemModel, configuration: Configuration, presentation: SelectionListView.Presentation, withAutoLayout: Bool) {
        self.model = model
        self.configuration = configuration
        self.presentation = presentation
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout

        isSelected = model.isInitiallySelected
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .bgPrimary
        if configuration.isIndependent {
            contentView.layer.borderWidth = 1
            contentView.layer.cornerRadius = configuration.cornerRadius
            contentView.layer.borderColor = .borderDefault
        }

        addCornerRadius(
            maskedCorners: configuration.maskedCorners,
            cornerRadius: configuration.cornerRadius
        )

        // Because of the margins outside contentView we need to
        // adjust the corner radius to not make it look weird.
        contentView.addCornerRadius(
            maskedCorners: configuration.maskedCorners,
            cornerRadius: configuration.cornerRadius - configuration.horizontalSpacing
        )

        titleLabel.text = model.title
        iconImageView.image = model.icon.image

        switch model.description {
        case .plain(let text):
            descriptionLabel.text = text
        case .html(let htmlString, let style, _):
            descriptionLabel.setHTMLText(htmlString, with: style)
        case .none:
            descriptionLabel.text = nil
        }

        if let detailItems = model.detailItems, !detailItems.isEmpty {
            let itemViews = detailItems.map { CheckmarkItemDetailView(item: $0, withAutoLayout: true) }
            detailViewsStackView.addArrangedSubviews(itemViews)

            detailViewsStackViewBottomConstraint.constant = -.spacingM
        }

        textStackView.addArrangedSubviews([titleLabel])
        if case .none = model.description {} else {
            textStackView.addArrangedSubviews([descriptionLabel])
        }

        addSubview(contentView)
        contentView.addSubview(selectionView)
        contentView.addSubview(textStackView)
        contentView.addSubview(detailViewsStackView)

        var constraints: [NSLayoutConstraint] = [
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: configuration.verticalSpacing),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: configuration.horizontalSpacing),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -configuration.horizontalSpacing),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -configuration.verticalSpacing),

            selectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            selectionView.centerYAnchor.constraint(equalTo: textStackView.centerYAnchor),

            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
            textStackView.leadingAnchor.constraint(equalTo: selectionView.trailingAnchor, constant: .spacingM),
            textStackView.bottomAnchor.constraint(equalTo: detailViewsStackView.topAnchor, constant: -.spacingM),

            detailViewsStackView.leadingAnchor.constraint(equalTo: selectionView.trailingAnchor, constant: .spacingM),
            detailViewsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),
            detailViewsStackViewBottomConstraint
        ]

        if case .none = model.icon {} else {
            contentView.addSubview(iconImageView)
            constraints.append(contentsOf: [
                iconImageView.leadingAnchor.constraint(equalTo: textStackView.trailingAnchor, constant: .spacingM),
                iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),
                iconImageView.centerYAnchor.constraint(equalTo: textStackView.centerYAnchor)
            ])
        }

        if case .fixedSize = model.icon {
            constraints.append(contentsOf: [
                iconImageView.widthAnchor.constraint(equalToConstant: 24),
                iconImageView.heightAnchor.constraint(equalToConstant: 24)
            ])
        }

        NSLayoutConstraint.activate(constraints)

        setupAccessibility()
        updateSelection(shouldAnimate: false)
    }

    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .button

        let description = { () -> String? in
            switch model.description {
            case .plain(let text):
                return text
            case .html(let htmlString, _, let accessibilityString):
                return accessibilityString ?? htmlString
            case .none:
                return nil
            }
        }()

        var detailItemsString: String?
        if let detailItems = model.detailItems, !detailItems.isEmpty {
            detailItemsString = detailItems.joined(separator: ", ")
        }

        accessibilityLabel = [model.title, description, detailItemsString].compactMap { $0 }.joined(separator: ", ")
    }

    // MARK: - Private methods

    private func updateSelection(shouldAnimate: Bool) {
        if isSelected != selectionView.isHighlighted {
            if shouldAnimate {
                selectionView.animateSelection(selected: isSelected)
            } else {
                selectionView.isHighlighted = isSelected
            }
        }

        if isSelected {
            accessibilityTraits.insert(.selected)
        } else {
            accessibilityTraits.remove(.selected)
        }

        let duration = shouldAnimate ? 0.15 : 0
        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let self = self else { return }
            if self.configuration.isIndependent {
                self.contentView.layer.borderColor = self.isSelected ? .btnAction : .borderDefault
            } else {
                self.backgroundColor = self.isSelected ? .primaryBlue : .clear
            }
            self.iconImageView.tintColor = self.isSelected ? .textPrimary : .textSecondary
        })
    }
}

// MARK: - Inner types

extension SelectionListItemView {
    enum Position {
        case first
        case independent /// Used for lists where the elements are spaced out
        case last
        case middle
        case theOnlyOne
    }

    struct Configuration {
        let horizontalSpacing: CGFloat
        let verticalSpacing: CGFloat
        let cornerRadius: CGFloat
        let position: Position

        fileprivate var maskedCorners: CACornerMask {
            switch position {
            case .first:
                return [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            case .last:
                return [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            case .theOnlyOne:
                return [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            case .independent, .middle:
                return []
            }
        }

        fileprivate var isIndependent: Bool {
            position == .independent
        }
    }
}

// MARK: - Private extensions

private extension UIView {
    func addCornerRadius(maskedCorners: CACornerMask, cornerRadius: CGFloat) {
        guard !maskedCorners.isEmpty else { return }
        layer.maskedCorners = maskedCorners
        layer.cornerRadius = cornerRadius
    }
}

private extension SelectionListView.Presentation {
    var selectionView: AnimatedSelectionView {
        switch self {
        case .checkboxes:
            return AnimatedCheckboxView(frame: .zero)
        case .radioButtons:
            return AnimatedRadioButtonView(frame: .zero)
        }
    }
}
