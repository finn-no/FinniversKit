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

    private lazy var priceLabel: Label = {
        let label = Label(style: .body)
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

    private lazy var dashedSeperator: UIView = UIView(withAutoLayout: true)

    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceLabel, totalLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let model: AdConfirmationSummaryViewModel

    public let titleLabelHeight: CGFloat = 32
    public let checkmarkViewHeight: CGFloat = 32

    init(model: AdConfirmationSummaryViewModel, withAutoLayout: Bool = false) {
        self.model = model

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        backgroundColor = .bgSecondary
        layer.cornerRadius = 8
        clipsToBounds = true

        setup()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let line = CAShapeLayer()
        line.path = UIBezierPath(roundedRect: dashedSeperator.bounds, cornerRadius: 0).cgPath
        line.frame = dashedSeperator.bounds
        line.strokeColor = UIColor.stone.cgColor
        line.fillColor = UIColor.clear.cgColor
        line.lineWidth = 0.25
        line.lineDashPattern = [5, 5]

        dashedSeperator.layer.addSublayer(line)
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

        summaryView.addArrangedSubview(titleLabel)
        summaryView.addConstraint(titleLabel.heightAnchor.constraint(equalToConstant: 32))

        for line in model.orderLines {
            let checkmarkView = CheckmarkTitleView(title: line, withAutoLayout: true)

            summaryView.addArrangedSubview(checkmarkView)
            summaryView.addConstraint(checkmarkView.heightAnchor.constraint(equalToConstant: 32))
        }

        addSubview(summaryView)
        NSLayoutConstraint.activate([
            summaryView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .mediumSpacing),
            summaryView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .mediumSpacing),
            summaryView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.mediumSpacing)
        ])

        addSubview(dashedSeperator)
        NSLayoutConstraint.activate([
            dashedSeperator.topAnchor.constraint(equalTo: summaryView.bottomAnchor, constant: .mediumSpacing),
            dashedSeperator.heightAnchor.constraint(equalToConstant: 1),
            dashedSeperator.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            dashedSeperator.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])

        addSubview(priceStackView)
        NSLayoutConstraint.activate([
            priceStackView.topAnchor.constraint(equalTo: dashedSeperator.bottomAnchor, constant: .mediumLargeSpacing),
            priceStackView.leadingAnchor.constraint(equalTo: summaryView.leadingAnchor),
            priceStackView.trailingAnchor.constraint(equalTo: summaryView.trailingAnchor),
        ])
    }
}
