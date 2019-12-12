//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol MinFinnVerifyCellDelegate: AnyObject {
    func minFinnVerifiyCell(_ cell: MinFinnVerifyCell, didSelect action: MinFinnVerifyCell.Action)
}

public class MinFinnVerifyCell: UITableViewCell {

    public enum Action {
        case primary
        case secondary
    }

    // MARK: - Internal properties

    weak var delegate: MinFinnVerifyCellDelegate?

    // MARK: - Private properties

    private lazy var iconView: UIImageView = {
        let icon = UIImage(named: .verified)
        let imageView = UIImageView(image: icon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        return label
    }()

    private lazy var bodyLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var primaryButton: Button = {
        let button = Button(style: .default, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var secondaryButton: Button = {
        let button = Button(style: .flat, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(secondaryButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var colorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgSecondary
        view.layer.cornerRadius = 8
        return view
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override

    public override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: nil)
    }

    // MARK: - Methods

    func configure(with model: MinFinnVerifyCellModel?) {
        titleLabel.text = model?.title
        bodyLabel.text = model?.text
        primaryButton.setTitle(model?.primaryButtonTitle, for: .normal)
        secondaryButton.setTitle(model?.secondaryButtonTitle, for: .normal)
        delegate = model?.delegate
    }
}

// MARK: - Private methods
private extension MinFinnVerifyCell {
    @objc func primaryButtonTapped() {
        delegate?.minFinnVerifiyCell(self, didSelect: .primary)
    }

    @objc func secondaryButtonTapped() {
        delegate?.minFinnVerifiyCell(self, didSelect: .secondary)
    }

    func setup() {
        selectionStyle = .none
        contentView.backgroundColor = .bgPrimary

        contentView.addSubview(colorView)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(primaryButton)
        contentView.addSubview(secondaryButton)

        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .smallSpacing),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            iconView.topAnchor.constraint(equalTo: colorView.topAnchor, constant: .mediumLargeSpacing),
            iconView.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: .mediumSpacing),
            titleLabel.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),

            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .smallSpacing),
            bodyLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: .mediumLargeSpacing),
            bodyLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -.mediumLargeSpacing),

            primaryButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: .mediumLargeSpacing),
            primaryButton.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),

            secondaryButton.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),
            secondaryButton.topAnchor.constraint(equalTo: primaryButton.bottomAnchor, constant: .mediumSpacing),
            secondaryButton.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -.mediumSpacing),
        ])
    }
}
