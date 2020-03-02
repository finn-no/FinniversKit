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
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var seperator: UIView = {
        let seperator = UIView(withAutoLayout: true)
        seperator.backgroundColor = .sardine
        return seperator
    }()

    private lazy var priceLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private lazy var totalLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
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
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingS),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])

        for line in model.orderLines {
            let checkmarkView = CheckmarkTitleView(title: line, withAutoLayout: true)
            summaryView.setCustomSpacing(.spacingS, after: checkmarkView)

            summaryView.addArrangedSubview(checkmarkView)
            summaryView.addConstraint(checkmarkView.heightAnchor.constraint(equalToConstant: 32))
        }

        addSubview(summaryView)
        NSLayoutConstraint.activate([
            summaryView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingS),
            summaryView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingS),
            summaryView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingS)
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
            priceLabel.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: .spacingM),
            priceLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),
            priceLabel.trailingAnchor.constraint(equalTo: centerXAnchor),

            totalLabel.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: .spacingM),
            totalLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            totalLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingM),
        ])
    }
}
