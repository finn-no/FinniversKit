//
//  Copyright © FINN.no AS. All rights reserved.
//

public protocol UserAdManagementButtonAndInformationCellDelegate: class {
    func buttonAndInformationCellButtonWasTapped(_ sender: UserAdManagementButtonAndInformationCell)
}

public class UserAdManagementButtonAndInformationCell: UITableViewCell {
    weak public var delegate: UserAdManagementButtonAndInformationCellDelegate?
    public var buttonText: String? {
        didSet {
            buttonLabel.text = buttonText
            button.accessibilityLabel = buttonText
        }
    }
    public var informationText: String? {
        didSet { informationLabel.text = informationText }
    }

    private lazy var informationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .title5
        label.textColor = .licorice
        label.textAlignment = .left
        return label
    }()
    private lazy var buttonLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .title5
        label.textColor = .milk
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
        return label
    }()
    private lazy var button: HIGFriendlyButton = {
        let button = HIGFriendlyButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .primaryBlue
        button.layer.cornerRadius = 8
        button.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
        button.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal)
        return button
    }()

    // MARK: - init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
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

        UIView.animate(withDuration: 0.1, delay: 0, options: .beginFromCurrentState, animations: {
            sender.backgroundColor = .primaryBlue
        }, completion: nil)
    }

    @objc private func handleButtonTouchDown(_ sender: UIButton) {
        sender.backgroundColor = .callToActionButtonHighlightedBodyColor
    }

    private func setup() {
        contentView.addSubview(informationLabel)
        contentView.addSubview(button)
        contentView.addSubview(buttonLabel)

        NSLayoutConstraint.activate(
            [ informationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
              informationLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
              informationLabel.rightAnchor.constraint(equalTo: button.leftAnchor, constant: -12),
              informationLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.67),
              buttonLabel.centerYAnchor.constraint(equalTo: informationLabel.centerYAnchor),
              buttonLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -21),
              button.centerYAnchor.constraint(equalTo: buttonLabel.centerYAnchor),
              button.heightAnchor.constraint(equalToConstant: 32),
              button.centerXAnchor.constraint(equalTo: buttonLabel.centerXAnchor),
              button.widthAnchor.constraint(equalTo: buttonLabel.widthAnchor, constant: 20),
              contentView.heightAnchor.constraint(greaterThanOrEqualTo: informationLabel.heightAnchor, constant: 24),
              contentView.heightAnchor.constraint(greaterThanOrEqualTo: button.heightAnchor, constant: 24) ]
        )
    }
}
