//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

protocol MinFinnVerifyCellDelegate: AnyObject {
    func minFinnVerifiyCellDidTapVerifyButton(_ cell: MinFinnVerifyCell)
}

class MinFinnVerifyCell: UITableViewCell {

    // MARK: - Internal properties

    weak var delegate: MinFinnVerifyCellDelegate?

    // MARK: - Private properties

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3, withAutoLayout: true)
        label.textColor = .licorice
        return label
    }()

    private lazy var verifyButton: Button = {
        let button = Button(style: .callToAction, withAutoLayout: true)
        button.addTarget(self, action: #selector(verifyButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var colorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .mint
        view.layer.cornerRadius = 4
        view.layer.borderColor = UIColor.accentPea.cgColor
        view.layer.borderWidth = 2
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

    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: nil)
    }

    // MARK: - Methods

    func configure(with model: MinFinnVerifyCellModel?) {
        titleLabel.text = model?.title
        verifyButton.setTitle(model?.buttonTitle, for: .normal)
    }
}

// MARK: - Private methods
private extension MinFinnVerifyCell {
    @objc func verifyButtonTapped() {
        delegate?.minFinnVerifiyCellDidTapVerifyButton(self)
    }

    func setup() {
        selectionStyle = .none
        contentView.backgroundColor = .bgPrimary

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
