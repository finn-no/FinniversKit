import UIKit

public class AddressComponentFieldView: UIView {

    // MARK: - Private properties

    private lazy var stackView = UIStackView(axis: .vertical, spacing: 0, withAutoLayout: true)

    private lazy var hairlineView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .placeholderText
        return view
    }()

    private lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .arrowRight).withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .placeholderText
        return imageView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .backgroundSubtle

        addSubview(stackView)
        addSubview(chevronImageView)
        addSubview(hairlineView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingS),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingS),

            chevronImageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: .spacingS),
            chevronImageView.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: .spacingM),
            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            chevronImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -.spacingM),
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImageView.heightAnchor.constraint(equalToConstant: 14),
            chevronImageView.widthAnchor.constraint(equalToConstant: 8),

            hairlineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            hairlineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hairlineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            hairlineView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])

        setupAccessibility()
    }

    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .button
    }

    // MARK: - Internal methods

    public func configure(with model: AddressComponentKind.Model) {
        stackView.removeArrangedSubviews()

        if let title = model.value {
            let floatingLabel = Label.create(style: .detail, textColor: .textSecondary)
            floatingLabel.text = model.placeholder

            let titleLabel = Label.create(style: .caption)
            titleLabel.text = title

            stackView.addArrangedSubviews([floatingLabel, titleLabel])
            stackView.alignment = .top
        } else {
            let placeholderLabel = Label.create(style: .caption, textColor: .textSecondary)
            placeholderLabel.text = model.placeholder

            stackView.addArrangedSubview(placeholderLabel)
            stackView.alignment = .leading
        }

        accessibilityLabel = [model.placeholder, model.value ?? model.noValueAccessibilityLabel].compactMap { $0 }.joined(separator: ": ")
    }
}

// MARK: - Private extensions

private extension Label {
    static func create(style: Label.Style, textColor: UIColor = .text) -> Label {
        let label = Label(style: style, withAutoLayout: true)
        label.textColor = textColor
        return label
    }
}
