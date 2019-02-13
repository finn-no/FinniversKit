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
            let attributedText = NSMutableAttributedString(string: buttonText ?? "")
            button.setAttributedTitle(attributedText, for: .normal)
            button.accessibilityLabel = buttonText
            updateButtonConstraints()
        }
    }
    public var informationText: String? {
        didSet {
            informationLabel.attributedText = NSAttributedString(string: informationText ?? "")
            updateInformationLabelConstraints()
        }
    }

    private let buttonHeight: CGFloat = 32 // This is too small for comfort (Re. Apple's HIG), won't handle this now as the whole design is still subject to change
    private let labelToButtonSpacing: CGFloat = .mediumSpacing
    private let labelLeftInset: CGFloat = .mediumLargeSpacing
    private let labelWidthProportion: CGFloat = 0.67

    private lazy var informationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .title5
        label.textColor = .licorice
        label.textAlignment = .left
        return label
    }()

    private lazy var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.font = .title5
        button.titleLabel?.textColor = .milk
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .primaryBlue
        button.layer.cornerRadius = 8
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
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

    // MARK: - ButtonActions

    @objc private func handleButtonTouchUpInside(_ sender: UIButton) {
        delegate?.buttonAndInformationCellButtonWasTapped(self)

        UIView.animate(withDuration: 0.1, delay: 0, options: .beginFromCurrentState, animations: {
            sender.backgroundColor = .primaryBlue
        }, completion: nil)
    }

    @objc private func handleButtonTouchDown(_ sender: UIButton) {
        sender.backgroundColor = .callToActionButtonHighlightedBodyColor
    }

    // MARK: - Constraint updates

    private func updateButtonConstraints() {
        guard let buttonText = buttonText else { return }

        let buttonWidth = 20 + buttonText.width(withConstrainedHeight: buttonHeight, font: .title5)
        if let widthConstraint = (button.constraints.filter { $0.firstAttribute == .width }).first {
            widthConstraint.constant = buttonWidth
        }
    }

    private func updateInformationLabelConstraints() {
        guard let informationText = informationText else { return }

        let labelWidth = bounds.size.width*labelWidthProportion-labelToButtonSpacing-labelLeftInset
        let labelHeight = informationText.height(withConstrainedWidth: labelWidth, font: .title5)
        if let heightConstraint = (informationLabel.constraints.filter { $0.firstAttribute == .height }).first {
            heightConstraint.constant = labelHeight
        }
    }

    // MARK: - Setup

    private func setup() {
        contentView.addSubview(informationLabel)
        contentView.addSubview(button)

        NSLayoutConstraint.activate(
            [ informationLabel.heightAnchor.constraint(equalToConstant: 0),
              informationLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: labelLeftInset),
              informationLabel.rightAnchor.constraint(equalTo: button.leftAnchor, constant: -labelToButtonSpacing),
              informationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
              button.widthAnchor.constraint(equalToConstant: 0),
              button.heightAnchor.constraint(equalToConstant: buttonHeight),
              button.centerYAnchor.constraint(equalTo: informationLabel.centerYAnchor),
              button.rightAnchor.constraint(equalTo: rightAnchor, constant: -.mediumLargeSpacing),
              contentView.heightAnchor.constraint(greaterThanOrEqualTo: informationLabel.heightAnchor, constant: 24),
              contentView.heightAnchor.constraint(greaterThanOrEqualTo: button.heightAnchor, constant: 24),
              contentView.bottomAnchor.constraint(greaterThanOrEqualTo: informationLabel.bottomAnchor)
            ]
        )
    }
}
