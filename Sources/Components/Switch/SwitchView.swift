//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public protocol SwitchViewDelegate: AnyObject {
    func switchView(_ switchView: SwitchView, didChangeValueFor switch: UISwitch)
}

public class SwitchView: UIView {
    // MARK: - Public properties

    public weak var delegate: SwitchViewDelegate?

    public var isOn: Bool {
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
        label.textColor = .textSecondary
        return label
    }()

    private lazy var detailLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .textSecondary
        return label
    }()

    private lazy var uiSwitch: UISwitch = {
        let uiSwitch = UISwitch(withAutoLayout: true)
        uiSwitch.onTintColor = .btnPrimary //DARK
        uiSwitch.addTarget(self, action: #selector(swichValueChanged), for: .valueChanged)
        return uiSwitch
    }()

    // MARK: - Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Public methods

    public func configure(with model: SwitchViewModel) {
        titleLabel.text = model.title
        detailLabel.text = model.detail
        uiSwitch.isOn = model.initialSwitchValue
    }

    // MARK: - Private methods
    private func setup() {
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(uiSwitch)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .verySmallSpacing),
            detailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            detailLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing),

            uiSwitch.leadingAnchor.constraint(equalTo: detailLabel.trailingAnchor, constant: .mediumSpacing),
            uiSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            uiSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),
            uiSwitch.widthAnchor.constraint(equalToConstant: 49.0)
        ])
    }

    @objc private func swichValueChanged() {
        delegate?.switchView(self, didChangeValueFor: uiSwitch)
    }
}
