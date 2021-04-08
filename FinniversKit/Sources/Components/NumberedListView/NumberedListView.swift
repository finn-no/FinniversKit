import UIKit

public class NumberedListView: UIView {
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        stackView.alignment = .top
        return stackView
    }()

    private lazy var numberStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        return stackView
    }()

    private lazy var itemsStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        return stackView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(contentStackView)
        contentStackView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(with items: [NumberedListItem]) {
        contentStackView.removeArrangedSubviews()
        numberStackView.removeArrangedSubviews()
        itemsStackView.removeArrangedSubviews()

        for (index, item) in items.enumerated() {
            let numberView = createNumberLabel(number: index + 1)
            let itemView = ListItemView(item: item)

            let lineStackView = UIStackView(axis: .horizontal, spacing: .spacingXS, withAutoLayout: true)
            lineStackView.alignment = .top
            lineStackView.addArrangedSubviews([numberView, itemView])

            numberView.widthAnchor.constraint(equalToConstant: .spacingXL).isActive = true

            contentStackView.addArrangedSubview(lineStackView)
        }
    }

    // MARK: - Private methods

    private func createNumberLabel(number: Int) -> Label {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textColor = .primaryBlue
        label.text = "\(number)"
        return label
    }
}

// MARK: - Private class

private class ListItemView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: 0, withAutoLayout: true)
        stackView.addArrangedSubviews([titleLabel, bodyLabel])
        return stackView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private lazy var bodyLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    init(item: NumberedListItem) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.fillInSuperview()

        if let title = item.title {
            titleLabel.text = title
            titleLabel.isHidden = false
        }

        bodyLabel.text = item.body
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }
}
