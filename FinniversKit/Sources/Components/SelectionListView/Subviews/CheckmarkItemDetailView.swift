import UIKit

class CheckmarkItemDetailView: UIView {

    // MARK: - Private properties

    private let item: String

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: .spacingS, withAutoLayout: true)
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.addArrangedSubviews([iconImageView, titleLabel])
        return stackView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.text = item
        label.textColor = .text
        label.numberOfLines = 0
        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: .checkmark)
        imageView.tintColor = .textSecondary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Init

    init(item: String, withAutoLayout: Bool) {
        self.item = item
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(stackView)
        stackView.fillInSuperview()

        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 12),
            iconImageView.heightAnchor.constraint(equalToConstant: 12),
            iconImageView.bottomAnchor.constraint(equalTo: titleLabel.firstBaselineAnchor, constant: .spacingXXS)
        ])
    }
}
