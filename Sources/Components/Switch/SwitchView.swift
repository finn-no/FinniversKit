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

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .detail)
        label.textColor = .stone
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = .smallSpacing
        view.distribution = .fillEqually
        return view
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
            subtitleLabel.text = model?.subtitle
            if subtitleLabel.text == nil {
                self.stackView.removeArrangedSubview(subtitleLabel)
            } else {
                self.stackView.addArrangedSubview(subtitleLabel)
            }

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
        addSubview(stackView)
        addSubview(aSwitch)

        let margin: CGFloat = .mediumSpacing
        NSLayoutConstraint.activate([
            aSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin),
            aSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),

            stackView.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),
            stackView.trailingAnchor.constraint(equalTo: aSwitch.leadingAnchor, constant: -margin),
            ])
    }

    // MARK: - Private actions

    @objc func switchChangedState(_ sender: UISwitch) {
        delegate?.switchView(self, didChangeValueFor: sender)
        model?.isOn = sender.isOn
    }
}
