import UIKit

class MyAdStatisticsItemView: UIView {

    // MARK: - Private properties

    private lazy var valueLabel = Label(style: .detailStrong, withAutoLayout: true)
    private lazy var stackView = UIStackView(axis: .horizontal, spacing: .spacingXS, withAutoLayout: true)

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .textPrimary
        return imageView
    }()

    // MARK: - Init

    init(model: MyAdModel.LabelItem, iconName: ImageAsset, withAutoLayout: Bool) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup(model: model, iconName: iconName)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup(model: MyAdModel.LabelItem, iconName: ImageAsset) {
        isAccessibilityElement = true
        accessibilityTraits = .staticText
        accessibilityLabel = model.accessibilityTitle

        valueLabel.text = model.title
        iconImageView.image = UIImage(named: iconName).withRenderingMode(.alwaysTemplate)

        stackView.addArrangedSubviews([iconImageView, valueLabel])

        addSubview(stackView)
        stackView.fillInSuperview()

        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: .spacingM),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor)
        ])
    }
}
