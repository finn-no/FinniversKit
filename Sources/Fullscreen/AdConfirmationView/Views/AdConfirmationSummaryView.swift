//
//  Copyright © 2019 FINN AS. All rights reserved.
//

public class AdConfirmationSummaryView: UIView {
    private lazy var summaryWrapper: UIView = {
        let summaryWrapper = UIView(withAutoLayout: true)
        summaryWrapper.backgroundColor = .marble
        summaryWrapper.layer.cornerRadius = 4
        summaryWrapper.clipsToBounds = true
        return summaryWrapper
    }()

    private let priceLabel: Label = {
        let label = Label(style: .caption)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let totalLabel: Label = {
        let label = Label(style: .captionStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var summaryStackView: UIStackView = {
        let summaryStackView = UIStackView()
        summaryStackView.axis = .vertical
        summaryStackView.alignment = .center
        return summaryStackView
    }()

    // TODO: Create dashed seperator
    private lazy var separator: UIView = {
        let separator = UIView(withAutoLayout: true)
        separator.backgroundColor = .sardine
        return separator
    }()

    public var model: AdConfirmationSummaryViewModel? {
        didSet {
            priceLabel.text = model?.priceLabel
            totalLabel.text = model?.priceText
            // TODO: Move into iOS app
            // if model?.priceValue == 0 {
            //    totalLabel.text = model?.priceText
            //  } else {
            //    totalLabel.text = PriceFormatter.string(from: Double(model.priceValue))
            //  }
        }
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AdConfirmationSummaryView {
    func setup() {
        addSubview(summaryWrapper)
        summaryWrapper.addSubview(summaryStackView)

        if let title = model?.title {
            let titleLabel = Label(style: .bodyStrong)
            titleLabel.text = title
            titleLabel.numberOfLines = 0
            summaryStackView.addArrangedSubview(titleLabel)
        }

        if let orderLines = model?.orderLines {
            for line in orderLines {
                // TODO: Create similar component
//                guard let view = Bundle.main.loadNibNamed("AdInCardSellingPointView", owner: nil, options: nil)?.first as? AdInLabelAndCheckmarkView else { continue }
//                view.label.text = line
//                summaryStackView.addArrangedSubview(view)
            }
            let checkmarkView = CheckmarkTitleView(title: line, withAutoLayout: true)
        }
        summaryStackView.addArrangedSubview(separator)


        let priceStackView = UIStackView(arrangedSubviews: [priceLabel, totalLabel])
        priceStackView.axis = .horizontal
        priceStackView.distribution = .fill
        summaryStackView.addArrangedSubview(priceStackView)
    }
}
