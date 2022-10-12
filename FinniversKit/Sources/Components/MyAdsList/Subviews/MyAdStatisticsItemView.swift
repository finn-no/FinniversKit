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

    init(value: String, iconName: ImageAsset, withAutoLayout: Bool) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup(value: value, iconName: iconName)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup(value: String, iconName: ImageAsset) {
        valueLabel.text = value
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
