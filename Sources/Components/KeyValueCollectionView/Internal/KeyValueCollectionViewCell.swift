import UIKit

class KeyValueCollectionViewCell: UICollectionViewCell {
    // MARK: - Private properties

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = .verySmallSpacing
        return stackView
    }()

    private lazy var headerLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 2
        label.lineBreakMode = .byCharWrapping
        return label
    }()

    private lazy var valueLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.isHidden = true
        label.numberOfLines = 2
        label.lineBreakMode = .byCharWrapping
        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Internal methods

    func configure(title: String? = nil, value: String? = nil) {
        headerLabel.text = title
        headerLabel.isHidden = title == nil

        valueLabel.text = value
        valueLabel.isHidden = value == nil
    }

    // MARK: - Private methods

    private func setup() {
        contentView.addSubview(textStackView)

        textStackView.addArrangedSubview(headerLabel)
        textStackView.addArrangedSubview(valueLabel)
        textStackView.fillInSuperview()
    }
}

extension KeyValueCollectionViewCell {
    static func height(for width: CGFloat, with viewModel: KeyValuePair) -> CGFloat {
        let targetSize = CGSize(width: width, height: 400)
        let cell = KeyValueCollectionViewCell(withAutoLayout: true)
        cell.configure(title: viewModel.title, value: viewModel.value)
        let size = cell.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )

        return size.height
    }
}
