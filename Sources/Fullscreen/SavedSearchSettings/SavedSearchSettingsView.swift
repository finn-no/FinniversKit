//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// MARK: - SavedSearchSettingsViewDelegatew

public protocol SavedSearchSettingsViewDelegate: NSObjectProtocol {
    func savedSearchSettingsView(_ savedSearchSettingsView: SavedSearchSettingsView, didChangeName name: String)
    func savedSearchSettingsView(_ savedSearchSettingsView: SavedSearchSettingsView, didToggleAppNotifications isOn: Bool)
    func savedSearchSettingsView(_ savedSearchSettingsView: SavedSearchSettingsView, didToggleEmailNotifications isOn: Bool)
}

public class SavedSearchSettingsView: UIView {
    // MARK: - Internal properties

    private lazy var nameTextField: TextField = {
        let view = TextField(inputType: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var appSwitch: SwitchView = {
        let view = SwitchView(withAutoLayout: true)
        return view
    }()

    private lazy var emailSwitch: SwitchView = {
        let view = SwitchView(withAutoLayout: true)
        return view
    }()

    private lazy var deleteButton: Button = {
        let button = Button(style: .destructive)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteButtonSelected), for: .touchUpInside)
        return button
    }()

    fileprivate let buttonHeight: CGFloat = 44

    // MARK: - Dependency injection

    public var model: SavedSearchSettingsViewModel? {
        didSet {
            guard let model = model else {
                return
            }

            nameTextField.textField.text = model.name
            nameTextField.placeholderText = model.namePlaceholder
            deleteButton.setTitle(model.deleteButtonTitle, for: .normal)
            appSwitch.model = model.appSwitchModel
            emailSwitch.model = model.emailSwitchModel
        }
    }

    // MARK: - External properties

    public weak var delegate: SavedSearchSettingsViewDelegate?

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
        addSubview(nameTextField)
        addSubview(deleteButton)
        addSubview(appSwitch)
        addSubview(emailSwitch)

        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: topAnchor, constant: .largeSpacing),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            appSwitch.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: .mediumLargeSpacing),
            appSwitch.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            appSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            emailSwitch.topAnchor.constraint(equalTo: appSwitch.bottomAnchor, constant: .mediumLargeSpacing),
            emailSwitch.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            emailSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            deleteButton.topAnchor.constraint(equalTo: emailSwitch.bottomAnchor, constant: .mediumLargeSpacing),
            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }

    // MARK: - Actions

    @objc func deleteButtonSelected() {
        
    }
}
 
