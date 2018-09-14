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

    private lazy var deleteButton: Button = {
        let button = Button(style: .callToAction)
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

        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            deleteButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: .mediumLargeSpacing),
            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }

    // MARK: - Actions

    @objc func deleteButtonSelected() {
        
    }
}
