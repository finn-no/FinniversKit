//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol SwitchDelegate: NSObjectProtocol {
    func switchView(_ switchView: SwitchView, didChangeValueFor switch: UISwitch)
}

public class SwitchView: UIView {
    // MARK: - Internal properties

    private let animationDuration: Double = 0.4

    private lazy var titleLabel: Label = {
        let label = Label(style: .title4)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var aSwitch: UISwitch = {
        let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .sardine
        view.onTintColor = .pea
        view.addTarget(self, action: #selector(switchChangedState), for: .valueChanged)
        return view
    }()

    // MARK: - Dependency injection

    public var model: SwitchViewModel? {
        didSet {
            titleLabel.text = model?.title
            aSwitch.isOn = model?.isOn ?? false
        }
    }

    // MARK: - External properties

    public weak var delegate: SwitchDelegate?

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        addSubview(titleLabel)
        addSubview(aSwitch)

        let margin: CGFloat = .mediumSpacing
        NSLayoutConstraint.activate([
            aSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin),
            aSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),
            titleLabel.trailingAnchor.constraint(equalTo: aSwitch.leadingAnchor, constant: -margin),
            ])
    }

    // MARK: - Private actions

    @objc func switchChangedState(_ sender: UISwitch) {
        delegate?.switchView(self, didChangeValueFor: sender)
        model?.isOn = sender.isOn
    }
}
