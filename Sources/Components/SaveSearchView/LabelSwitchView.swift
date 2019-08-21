//
//  Copyright © 2019 FINN AS. All rights reserved.
//

protocol LabelSwitchViewDelegate: AnyObject {
    func labelSwitchViewValueChanged(_ labelSwitchView: LabelSwitchView)
}

class LabelSwitchView: UIView {
    weak var delegate: LabelSwitchViewDelegate?

    var isOn: Bool {
        get {
            return uiSwitch.isOn
        }
        set {
            uiSwitch.isOn = newValue
        }
    }

    // MARK: - Private properties
    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .stone
        return label
    }()

    private lazy var detailLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .stone
        return label
    }()

    private lazy var uiSwitch: UISwitch = {
        let uiSwitch = UISwitch(withAutoLayout: true)
        uiSwitch.onTintColor = .primaryBlue
        uiSwitch.addTarget(self, action: #selector(swichValueChanged), for: .valueChanged)
        return uiSwitch
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Internal methods

    func configureWith(title: String?, detail: String?, isOn: Bool) {
        titleLabel.text = title
        detailLabel.text = detail
        uiSwitch.isOn = isOn
    }

    // MARK: - Private methods
    private func setup() {
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(uiSwitch)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: detailLabel.topAnchor),

            detailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            detailLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing),

            uiSwitch.leadingAnchor.constraint(equalTo: detailLabel.trailingAnchor, constant: .mediumSpacing),
            uiSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            uiSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),
            uiSwitch.widthAnchor.constraint(equalToConstant: 49.0)
        ])
    }

    @objc private func swichValueChanged() {
        delegate?.labelSwitchViewValueChanged(self)
    }
}
