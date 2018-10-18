//
//  Copyright © 2018 FINN AS. All rights reserved.
//
import UIKit

public class SettingsViewCell: UITableViewCell {
    // MARK: - Private properties

    private lazy var titleLabel: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var stateLabel: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .stone
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
        line.backgroundColor = .sardine
        return line
    }()

    // MARK: - Public properties

    public var model: SettingsViewCellModel? {
        didSet { set(model: model) }
    }

    public var labelInset: CGFloat = 14

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
    func set(model: SettingsViewCellModel?) {
        titleLabel.text = model?.title
        stateLabel.text = model?.status
        hairline.isHidden = !(model?.hairline ?? true) // isHidden is false by default
    }

    func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(stateLabel)
        contentView.addSubview(arrowView)
        contentView.addSubview(hairline)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: labelInset),
            titleLabel.trailingAnchor.constraint(equalTo: stateLabel.leadingAnchor, constant: -.smallSpacing),

            stateLabel.trailingAnchor.constraint(equalTo: arrowView.leadingAnchor, constant: -.mediumLargeSpacing),
            stateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            arrowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            arrowView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            hairline.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            hairline.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hairline.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            hairline.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),

            contentView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: labelInset)
        ])
    }
}
