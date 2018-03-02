//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol ToggleSwitchDelegate: NSObjectProtocol {
    func toggleSwitch(_ toggleSwitchView: ToggleSwitchView, didChangeValueFor toggleSwitch: UISwitch)
}

public class ToggleSwitchView: UIView {

    // MARK: - Internal properties

    private lazy var headerLabel: Label = {
        let label = Label(style: .title3)
        return label
    }()

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .detail(.stone))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var mySwitch: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.tintColor = .sardine
        mySwitch.onTintColor = .secondaryBlue
        mySwitch.onTintColor = .pea
        mySwitch.addTarget(self, action: #selector(switchChangedState), for: .valueChanged)
        return mySwitch
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [headerLabel, mySwitch])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = .mediumLargeSpacing
        return view
    }()

    // MARK: - Dependency injection

    public var model: ToggleSwitchViewModel? {
        didSet {
            guard let model = model else {
                return
            }

            headerLabel.text = model.headerText

            if mySwitch.isOn {
                descriptionLabel.text = model.onDescriptionText
            } else {
                descriptionLabel.text = model.offDescriptionText
            }
        }
    }

    // MARK: - External properties

    public weak var delegate: ToggleSwitchDelegate?

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
        addSubview(stackView)
        addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: .mediumSpacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Private actions

    @objc func switchChangedState(_ sender: UISwitch) {
        delegate?.toggleSwitch(self, didChangeValueFor: sender)

        guard let model = model else {
            return
        }

        if sender.isOn {
            descriptionLabel.text = model.onDescriptionText
        } else {
            descriptionLabel.text = model.offDescriptionText
        }
    }
}
