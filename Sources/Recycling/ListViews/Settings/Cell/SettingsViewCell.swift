//
//  Copyright © 2018 FINN AS. All rights reserved.
//
import UIKit

public class SettingsViewCell: UITableViewCell {
    // MARK: - Private properties

    private lazy var titleLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var stateLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.textColor = .textSecondary
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private lazy var arrowView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: .arrowRight).withRenderingMode(.alwaysTemplate))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .sardine
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()

    private lazy var hairline: UIView = {
        let line = UIView(frame: .zero)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .textDisabled
        return line
    }()

    static let estimatedRowHeight: CGFloat = 48

    // MARK: - Public Methods

    func configure(with viewModel: SettingsViewCellModel?, isLastItem: Bool) {
        titleLabel.text = viewModel?.title
        stateLabel.text = viewModel?.status
        arrowView.isHidden = !(viewModel?.hasChevron ?? true)
        hairline.isHidden = isLastItem
    }

    // MARK: - Setup

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension SettingsViewCell {
    func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(stateLabel)
        contentView.addSubview(arrowView)
        contentView.addSubview(hairline)

        contentView.directionalLayoutMargins = NSDirectionalEdgeInsets(vertical: 0, horizontal: .mediumLargeSpacing)
        let contentMargin = contentView.layoutMarginsGuide

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentMargin.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentMargin.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: stateLabel.leadingAnchor, constant: -.smallSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: contentMargin.bottomAnchor),

            stateLabel.trailingAnchor.constraint(equalTo: arrowView.leadingAnchor, constant: -.mediumSpacing),
            stateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            arrowView.trailingAnchor.constraint(equalTo: contentMargin.trailingAnchor),
            arrowView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowView.heightAnchor.constraint(equalToConstant: 13),
            arrowView.widthAnchor.constraint(equalToConstant: 8),

            hairline.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            hairline.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hairline.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            hairline.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),

            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: SettingsViewCell.estimatedRowHeight)
        ])
    }
}
