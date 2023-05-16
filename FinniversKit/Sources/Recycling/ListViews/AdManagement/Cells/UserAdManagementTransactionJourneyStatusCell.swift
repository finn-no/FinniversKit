//
//  Copyright © FINN.no AS. All rights reserved.
//

public protocol UserAdManagementTransactionJourneyStatusCellDelegate: AnyObject {
    func transactionJourneyStatusCellWasTapped(_ view: UserAdManagementTransactionJourneyStatusCell)
}

public class UserAdManagementTransactionJourneyStatusCell: UITableViewCell {

    public weak var delegate: UserAdManagementTransactionJourneyStatusCellDelegate?

    public var labelText: String? {
        didSet {
            transactionStatusLabel.attributedText = NSAttributedString(string: labelText ?? "")
        }
    }

    public var transactionJourneyStatusURL: String?

    private lazy var contentStackViewTrailingConstraint = contentStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)

    private lazy var contentViewTapRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(didTapContentView)
    )

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: .spacingM, withAutoLayout: true)
        stackView.addArrangedSubviews([iconImageView, transactionStatusLabel])
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.tintColor = .iconPrimary
        imageView.contentMode = .scaleAspectFit

        if let image = UIImage(named: "torgetShipping") {
            imageView.image = image.withRenderingMode(.alwaysTemplate)
        }

        return imageView
    }()

    private lazy var transactionStatusLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.numberOfLines = 0
        label.font = .bodyStrong
        label.textColor = .textPrimary
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    // MARK: - init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgPrimary

        contentStackView.addArrangedSubviews([iconImageView, transactionStatusLabel])

        contentView.addSubview(contentStackView)
        contentView.addGestureRecognizer(contentViewTapRecognizer)

        let iconImageWidthAndHeight: CGFloat = 24

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            contentStackViewTrailingConstraint,
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.spacingM),

            iconImageView.widthAnchor.constraint(equalToConstant: iconImageWidthAndHeight),
            iconImageView.heightAnchor.constraint(equalToConstant: iconImageWidthAndHeight),
        ])
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        contentStackViewTrailingConstraint.constant = 0
        transactionJourneyStatusURL = nil

    }

    @objc private func didTapContentView() {
        delegate?.transactionJourneyStatusCellWasTapped(self)
    }
}
