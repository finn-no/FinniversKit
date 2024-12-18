import UIKit
import Warp

public class AddressComponentPostalFieldView: UIView {

    // MARK: - Private properties

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: Warp.Spacing.spacing100, withAutoLayout: true)
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var hairlineView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .placeholderText
        return view
    }()

    private lazy var lockImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .padlock).withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .placeholderText
        return imageView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        isAccessibilityElement = true

        backgroundColor = .backgroundSubtle

        addSubview(stackView)
        addSubview(lockImageView)
        addSubview(hairlineView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing100),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Warp.Spacing.spacing100),

            lockImageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: Warp.Spacing.spacing100),
            lockImageView.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: Warp.Spacing.spacing200),
            lockImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200),
            lockImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -Warp.Spacing.spacing200),
            lockImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            lockImageView.heightAnchor.constraint(equalToConstant: 16),
            lockImageView.widthAnchor.constraint(equalToConstant: 13),

            hairlineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            hairlineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hairlineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            hairlineView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])
    }

    // MARK: - Public methods

    public func configure(postalCodeModel: AddressComponentKind.Model, postalPlaceModel: AddressComponentKind.Model, showHairline: Bool = true) {
        stackView.removeArrangedSubviews()

        stackView.addArrangedSubviews([
            createTextStackView(model: postalCodeModel),
            createTextStackView(model: postalPlaceModel)
        ])

        hairlineView.backgroundColor = showHairline ? .placeholderText : .clear

        accessibilityLabel = [postalCodeModel, postalPlaceModel].map { model in
            [model.placeholder, model.value ?? model.noValueAccessibilityLabel].compactMap { $0 }.joined(separator: ": ")
        }.joined(separator: ", ")
    }

    // MARK: - Private methods

    private func createTextStackView(model: AddressComponentKind.Model) -> UIStackView {
        let stackView = UIStackView(axis: .vertical, spacing: 0, withAutoLayout: true)

        if let title = model.value {
            let floatingLabel = Label.create(style: .detail, textColor: .textSubtle)
            floatingLabel.text = model.placeholder

            let titleLabel = Label.create(style: .caption)
            titleLabel.text = title

            stackView.addArrangedSubviews([floatingLabel, titleLabel])
            stackView.alignment = .top
        } else {
            let placeholderLabel = Label.create(style: .caption, textColor: .textSubtle)
            placeholderLabel.text = model.placeholder

            stackView.addArrangedSubview(placeholderLabel)
            stackView.alignment = .leading
        }

        return stackView
    }
}

// MARK: - Private extensions

private extension Label {
    static func create(style: Warp.Typography, textColor: UIColor = .text) -> Label {
        let label = Label(style: style, withAutoLayout: true)
        label.textColor = textColor
        return label
    }
}
