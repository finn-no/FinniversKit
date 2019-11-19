//
//  Copyright © 2019 FINN AS. All rights reserved.
//

public class AdConfirmationSummaryView: UIView {
    private lazy var summaryView: UIStackView = {
        let summaryView = UIStackView(withAutoLayout: true)
        summaryView.axis = .vertical
        return summaryView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var seperator: UIView = {
        let seperator = UIView(withAutoLayout: true)
        seperator.backgroundColor = .sardine
        return seperator
    }()

    private lazy var priceLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private lazy var totalLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()

    private let model: AdConfirmationSummaryViewModel

    public let titleLabelHeight: CGFloat = 32
    public let checkmarkViewHeight: CGFloat = 32

    init(model: AdConfirmationSummaryViewModel, withAutoLayout: Bool = false) {
        self.model = model

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        backgroundColor = .bgTertiary
        layer.cornerRadius = 16
        clipsToBounds = true

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AdConfirmationSummaryView {
    func setup() {
        titleLabel.text = model.title
        priceLabel.text = model.priceLabel
        totalLabel.text = model.priceValue

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 32),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        for line in model.orderLines {
            let checkmarkView = CheckmarkTitleView(title: line, withAutoLayout: true)
            summaryView.setCustomSpacing(.mediumSpacing, after: checkmarkView)

            summaryView.addArrangedSubview(checkmarkView)
            summaryView.addConstraint(checkmarkView.heightAnchor.constraint(equalToConstant: 32))
        }

        addSubview(summaryView)
        NSLayoutConstraint.activate([
            summaryView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumSpacing),
            summaryView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .mediumSpacing),
            summaryView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.mediumSpacing)
        ])

        addSubview(seperator)
        NSLayoutConstraint.activate([
            seperator.topAnchor.constraint(equalTo: summaryView.bottomAnchor),
            seperator.heightAnchor.constraint(equalToConstant: 1),
            seperator.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            seperator.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])

        addSubview(priceLabel)
        addSubview(totalLabel)
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: .mediumLargeSpacing),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            priceLabel.trailingAnchor.constraint(equalTo: centerXAnchor),

            totalLabel.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: .mediumLargeSpacing),
            totalLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            totalLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }
}
