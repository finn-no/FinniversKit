//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

class MinFinnVerifyCell: UITableViewCell {

    private lazy var titleLabel = Label(
        style: .title3,
        withAutoLayout: true
    )

    private lazy var verifyButton = Button(
        style: .callToAction,
        size: .normal,
        withAutoLayout: true
    )

    private lazy var colorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .mint
        view.layer.cornerRadius = 4
        view.layer.borderColor = UIColor.accentPea.cgColor
        view.layer.borderWidth = 2
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: nil)
    }

    func configure(with model: MinFinnVerifyCellModel?) {
        titleLabel.text = model?.title
        verifyButton.setTitle(model?.buttonTitle, for: .normal)
    }
}

private extension MinFinnVerifyCell {
    func setup() {
        selectionStyle = .none
        titleLabel.textColor = .licorice

        contentView.addSubview(colorView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(verifyButton)

        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .smallSpacing),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: .mediumLargeSpacing + .mediumSpacing),
            titleLabel.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),
            verifyButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumSpacing),
            verifyButton.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),
            verifyButton.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -.mediumLargeSpacing - .smallSpacing)
        ])
    }
}
