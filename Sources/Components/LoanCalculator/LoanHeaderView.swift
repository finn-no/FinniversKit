//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

protocol LoanHeaderViewModel {
    var title: String { get }
    var rentText: String { get }
    var pricePerMonth: String { get }
    var loanAmountText: String { get }
    var logo: UIImage? { get }
}

class LoanHeaderView: UIView {
    // MARK: - Private subviews
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = .mediumSpacing
        return stackView
    }()

    private lazy var outerStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = .mediumSpacing

        return stackView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        return label
    }()

    private lazy var valueLabel: Label = {
        let label = Label(style: .title2, withAutoLayout: true)
        return label
    }()

    private lazy var rentLabel: Label = {
        let label = Label(style: .detailStrong, withAutoLayout: true)
        return label
    }()

    private lazy var loanTotalLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        return label
    }()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return imageView
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func configure(with model: LoanHeaderViewModel) {
        titleLabel.text = model.title
        valueLabel.text = model.pricePerMonth
        rentLabel.text = model.rentText
        loanTotalLabel.text = model.loanAmountText
        logoImageView.image = model.logo
    }

    // MARK: - Private functions
    private func setup() {
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(valueLabel)
        textStackView.addArrangedSubview(rentLabel)
        textStackView.addArrangedSubview(loanTotalLabel)

        outerStackView.addArrangedSubview(textStackView)
        outerStackView.addArrangedSubview(logoImageView)

        addSubview(outerStackView)
        outerStackView.fillInSuperview()
    }
}
