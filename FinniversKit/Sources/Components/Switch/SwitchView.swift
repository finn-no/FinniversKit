//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import Warp

public protocol SwitchViewDelegate: AnyObject {
    func switchView(_ switchView: SwitchView, didChangeValueFor switch: UISwitch)
}

public class SwitchView: UIView {

    // MARK: - Public properties

    public weak var delegate: SwitchViewDelegate?

    public var isOn: Bool {
        get { uiSwitch.isOn }
        set { uiSwitch.isOn = newValue }
    }

    // MARK: - Private properties

    private let style: SwitchViewStyle

    private lazy var titleLabel: Label = {
        let label = Label(style: style.titleLabelStyle)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = style.titleLabelTextColor
        return label
    }()

    private lazy var detailLabel: Label = {
        let label = Label(style: style.detailLabelStyle)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = style.detailLabelTextColor
        // Tell Auto layout that its ok to compress this label to fit available space
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var uiSwitch: UISwitch = {
        let uiSwitch = UISwitch(withAutoLayout: true)
        uiSwitch.onTintColor = .backgroundPrimary //DARK
        uiSwitch.addTarget(self, action: #selector(swichValueChanged), for: .valueChanged)
        return uiSwitch
    }()

    // MARK: - Initializers

    public init(style: SwitchViewStyle = .default, withAutoLayout: Bool = false) {
        self.style = style
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    public override init(frame: CGRect) {
        self.style = .default
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        self.style = .default
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Public methods

    public func setOn(_ isOn: Bool, animated: Bool) {
        uiSwitch.setOn(isOn, animated: animated)
    }

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
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing200),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Warp.Spacing.spacing25),
            detailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            detailLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Warp.Spacing.spacing200),

            uiSwitch.leadingAnchor.constraint(equalTo: detailLabel.trailingAnchor, constant: Warp.Spacing.spacing100),
            uiSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200),
            uiSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    @objc private func swichValueChanged() {
        delegate?.switchView(self, didChangeValueFor: uiSwitch)
    }
}
