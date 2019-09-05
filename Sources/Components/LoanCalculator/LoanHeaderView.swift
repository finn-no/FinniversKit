//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol LoanHeaderViewModel {
    var title: String { get }
    var rentText: String { get }
    var pricePerMonth: String { get }
    var loanAmountText: String { get }
    var logoUrl: String? { get }
    var errorText: String { get }
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

    private lazy var titleLabel = Label(style: .body, withAutoLayout: true)
    private lazy var valueLabel = Label(style: .title2, withAutoLayout: true)
    private lazy var rentLabel = Label(style: .detailStrong, withAutoLayout: true)
    private lazy var loanTotalLabel = Label(style: .detail, withAutoLayout: true)

    private lazy var errorLabel: UILabel = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 4
        label.isHidden = true
        return label
    }()

    private lazy var logoImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
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
        errorLabel.text = model.errorText

        if let logoUrl = model.logoUrl {
            logoImageView.loadImage(for: logoUrl, imageWidth: logoSize.width, fallbackImage: fallbackImage)
        } else {
            logoImageView.setImage(fallbackImage, animated: false)
        }
    }

    func showErrorText(_ show: Bool) {
        errorLabel.isHidden = !show
        titleLabel.isHidden = show
        valueLabel.isHidden = show
        rentLabel.isHidden = show
        loanTotalLabel.isHidden = show
    }

    // MARK: - Private functions
    private func setup() {
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(valueLabel)
        textStackView.addArrangedSubview(rentLabel)
        textStackView.addArrangedSubview(loanTotalLabel)
        textStackView.addArrangedSubview(errorLabel)

        outerStackView.addArrangedSubview(textStackView)
        outerStackView.addArrangedSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: logoSize.width),
            logoImageView.heightAnchor.constraint(equalToConstant: logoSize.height)
        ])

        addSubview(outerStackView)
        outerStackView.fillInSuperview()
    }
}
