import UIKit

class CheckboxItemView: UIView {

    // MARK: - Internal properties

    var isSelected: Bool = false {
        didSet {
            updateSelection(shouldAnimate: true)
        }
    }

    // MARK: - Private properties

    private let model: CheckboxItemModel
    private let configuration: Configuration
    private lazy var contentView = UIView(withAutoLayout: true)
    private lazy var checkboxView = AnimatedCheckboxView(frame: .zero)
    private lazy var textStackView = UIStackView(axis: .vertical, spacing: .spacingXS, withAutoLayout: true)

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.textColor = .textSecondary
        label.numberOfLines = 0
        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.tintColor = .textPrimary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Init

    init(model: CheckboxItemModel, configuration: Configuration, withAutoLayout: Bool) {
        self.model = model
        self.configuration = configuration
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

        addCornerRadius(
            maskedCorners:configuration.maskedCorners,
            cornerRadius: configuration.cornerRadius
        )

        /// Because of the margins outside contentView we need to adjust the corner radius to
        /// not make it look weird.
        contentView.addCornerRadius(
            maskedCorners: configuration.maskedCorners,
            cornerRadius: configuration.cornerRadius - configuration.spacing
        )

        titleLabel.text = model.title
        iconImageView.image = model.icon

        switch model.description {
        case .plain(let text):
            descriptionLabel.text = text
        case .attributed(let attributedText):
            descriptionLabel.attributedText = attributedText
        }

        textStackView.addArrangedSubviews([titleLabel, descriptionLabel])

        addSubview(contentView)
        contentView.addSubview(checkboxView)
        contentView.addSubview(textStackView)
        contentView.addSubview(iconImageView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: configuration.spacing),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: configuration.spacing),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -configuration.spacing),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -configuration.spacing),

            checkboxView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingL),
            checkboxView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),

            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
            textStackView.leadingAnchor.constraint(equalTo: checkboxView.trailingAnchor, constant: .spacingM),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.spacingM),

            iconImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: .spacingS),
            iconImageView.leadingAnchor.constraint(equalTo: textStackView.trailingAnchor, constant: .spacingM),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),
            iconImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -.spacingM),
            iconImageView.centerYAnchor.constraint(equalTo: checkboxView.centerYAnchor),

            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
        ])

        updateSelection(shouldAnimate: false)
    }

    // MARK: - Private methods

    private func updateSelection(shouldAnimate: Bool) {
        if isSelected != checkboxView.isHighlighted {
            if shouldAnimate {
                checkboxView.animateSelection(selected: isSelected)
            } else {
                checkboxView.isHighlighted = isSelected
            }
        }

        let duration = shouldAnimate ? 0.15 : 0
        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let self = self else { return }
            self.backgroundColor = self.isSelected ? .primaryBlue : .clear
        })
    }
}

// MARK: - Inner types

extension CheckboxItemView {
    enum Position {
        case first
        case last
        case middle
        case theOnlyOne
    }

    struct Configuration {
        let spacing: CGFloat
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
            default:
                return []
            }
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
