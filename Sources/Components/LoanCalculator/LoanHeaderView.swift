//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol LoanHeaderViewModel {
    var title: String? { get }
    var rentText: String? { get }
    var pricePerMonth: String? { get }
    var loanAmountText: String? { get }
    var logoUrl: URL? { get }
    var errorText: String? { get }
}

class LoanHeaderView: UIView {
    weak var dataSource: RemoteImageViewDataSource? {
        didSet {
            logoImageView.dataSource = dataSource
        }
    }

    // MARK: - Private properties
    private let logoSize = CGSize(width: 70, height: 50)

    // MARK: - Private subviews

    private lazy var errorText: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var textContainerView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return view
    }()

    private lazy var valuesContainerView: UIView = UIView(withAutoLayout: true)

    private lazy var outerStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = .mediumLargeSpacing

        return stackView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        return label
    }()

    private lazy var valueLabel: Label = {
        let label = Label(style: .title2, withAutoLayout: true)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        return label
    }()

    private lazy var rentLabel: Label = {
        let label = Label(style: .detailStrong, withAutoLayout: true)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        return label
    }()

    private lazy var loanTotalLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        return label
    }()

    private lazy var logoImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        imageView.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        return imageView
    }()

    private lazy var fallbackImage = UIImage(named: .noImage)

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

        errorText.isHidden = model.errorText == nil
        errorText.text = model.errorText

        if let logoUrl = model.logoUrl?.absoluteString {
            logoImageView.loadImage(for: logoUrl, imageWidth: logoSize.width, fallbackImage: fallbackImage)
        } else {
            logoImageView.setImage(fallbackImage, animated: false)
        }
    }

    // MARK: - Private functions
    private func setup() {
        textContainerView.addSubview(titleLabel)
        textContainerView.addSubview(valueLabel)
        textContainerView.addSubview(rentLabel)
        textContainerView.addSubview(loanTotalLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: textContainerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor),

            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumSpacing),
            valueLabel.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor),

            rentLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: .mediumSpacing),
            rentLabel.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor),
            rentLabel.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor),

            loanTotalLabel.topAnchor.constraint(equalTo: rentLabel.bottomAnchor, constant: .mediumSpacing),
            loanTotalLabel.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor),
            loanTotalLabel.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor),
            loanTotalLabel.bottomAnchor.constraint(equalTo: textContainerView.bottomAnchor),
        ])

        valuesContainerView.addSubview(textContainerView)
        valuesContainerView.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            textContainerView.topAnchor.constraint(equalTo: valuesContainerView.topAnchor),
            textContainerView.bottomAnchor.constraint(equalTo: valuesContainerView.bottomAnchor),
            textContainerView.leadingAnchor.constraint(equalTo: valuesContainerView.leadingAnchor),

            logoImageView.topAnchor.constraint(equalTo: valuesContainerView.topAnchor),
            logoImageView.heightAnchor.constraint(lessThanOrEqualTo: textContainerView.heightAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: valuesContainerView.trailingAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: textContainerView.trailingAnchor, constant: .mediumLargeSpacing),
        ])

        outerStackView.addArrangedSubview(valuesContainerView)
        outerStackView.addArrangedSubview(errorText)

        addSubview(outerStackView)
        outerStackView.fillInSuperview()
    }
}
