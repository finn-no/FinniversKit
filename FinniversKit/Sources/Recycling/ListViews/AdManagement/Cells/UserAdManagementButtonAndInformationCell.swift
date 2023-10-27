//
//  Copyright © FINN.no AS. All rights reserved.
//

public protocol UserAdManagementButtonAndInformationCellDelegate: AnyObject {
    func buttonAndInformationCellButtonWasTapped(_ sender: UserAdManagementButtonAndInformationCell)
}

public class UserAdManagementButtonAndInformationCell: UITableViewCell {

    weak public var delegate: UserAdManagementButtonAndInformationCellDelegate?

    public var buttonText: String? {
        didSet {
            button.setTitle(buttonText, for: .normal)
            button.accessibilityLabel = buttonText
        }
    }
    public var informationText: String? {
        didSet {
            informationLabel.attributedText = NSAttributedString(string: informationText ?? "")
        }
    }

    private lazy var containerStack: UIStackView = {
        let view = UIStackView(withAutoLayout: true)
        view.addArrangedSubviews([informationLabel, button])
        view.alignment = .center
        view.spacing = .spacingS
        return view
    }()

    private lazy var informationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .detailStrong
        label.textColor = .text
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var button: UIButton = {
        let button = Button(style: .callToAction, size: .small)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.addTarget(self, action: #selector(handleButtonTouchUpInside(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(handleButtonTouchDown(_:)), for: .touchDown)
        return button
    }()

    private lazy var separatorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .tableViewSeparator
        return view
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

    // MARK: - ButtonActions

    @objc private func handleButtonTouchUpInside(_ sender: UIButton) {
        delegate?.buttonAndInformationCellButtonWasTapped(self)

        UIView.animate(withDuration: 0.1, delay: 0, options: .beginFromCurrentState, animations: {
            sender.backgroundColor = .backgroundPrimary
        }, completion: nil)
    }

    @objc private func handleButtonTouchDown(_ sender: UIButton) {
        sender.backgroundColor = .callToActionButtonHighlightedBodyColor
    }

    // MARK: - Setup

    private func setup() {
        contentView.addSubview(separatorView)
        contentView.addSubview(containerStack)

        backgroundColor = .background

        let hairLineSize = 1.0 / UIScreen.main.scale

        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: hairLineSize),
            separatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),

            containerStack.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: .spacingM),
            containerStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            containerStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.spacingM),
        ])
    }
}
