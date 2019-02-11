//
//  Copyright © FINN.no AS. All rights reserved.
//

protocol UserAdManagementButtonAndInformationCellDelegate: class {
    func buttonAndInformationCellButtonWasTapped(_ sender: UserAdManagementButtonAndInformationCell)
}

class UserAdManagementButtonAndInformationCell: UITableViewCell {
    weak var delegate: UserAdManagementButtonAndInformationCellDelegate?
    var buttonText: String? {
        didSet { buttonLabel.text = buttonText }
    }
    var informationText: String? {
        didSet { informationLabel.text = informationText }
    }

    private lazy var informationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.title5
        label.textColor = .licorice
        label.textAlignment = .left
        return label
    }()
    private lazy var buttonLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.title5
        label.textColor = .milk
        label.textAlignment = .center
        return label
    }()
    private lazy var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.primaryBlue
        button.layer.cornerRadius = 8
        return button
    }()

    // MARK: - init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        button.addTarget(self, action: #selector(handleButtonTouchUpInside(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(handleButtonTouchDown(_:)), for: .touchDown)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - ButtonHandling

    @objc private func handleButtonTouchUpInside(_ sender: UIButton) {
        delegate?.buttonAndInformationCellButtonWasTapped(self)

        UIView.animate(withDuration: 0.3, delay: 0, options: .beginFromCurrentState, animations: {
            sender.alpha = 1
        }, completion: nil)
    }

    @objc private func handleButtonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .beginFromCurrentState, animations: {
            sender.alpha = 0.6
        }, completion: nil)
    }


    private func setup() {
        contentView.addSubview(informationLabel)
        contentView.addSubview(button)
        contentView.addSubview(buttonLabel)

        informationLabel.addConstraint(NSLayoutConstraint(item: informationLabel, attribute: NSLayoutConstraint.Attribute.width , relatedBy: .lessThanOrEqual, toItem: contentView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 0.67, constant: 1))

        NSLayoutConstraint.activate(
            [
                informationLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                informationLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
                informationLabel.rightAnchor.constraint(equalTo: button.leftAnchor, constant: 8)

            ]
        )



    }




}

