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

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nameTextField: TextField = {
        let view = TextField(inputType: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    private lazy var deleteButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteButtonSelected), for: .touchUpInside)
        return button
    }()

    private lazy var inputsContainer: UIView = {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
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

    deinit {
        unRegisterKeyboardNotifications()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override func didMoveToSuperview() {
        registerForKeyboardNotifications()
    }

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboard), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }

    private func unRegisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func adjustKeyboard(notification: Notification) {
        guard let keyboardEndFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        if notification.name == Notification.Name.UIKeyboardWillShow {
            if keyboardEndFrame.intersects(inputsContainer.frame) {
                let intersectionFrame = keyboardEndFrame.intersection(inputsContainer.frame)
                let keyboardOverlap = intersectionFrame.height
                let bottomInset = keyboardOverlap + .mediumLargeSpacing
                let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)

                let animationDuration = ((notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]) as? TimeInterval) ?? 0.25
                UIView.animate(withDuration: animationDuration) { [weak self] in
                    self?.adjustKeyboardUp(contentInset: contentInset)
                }
            }
        } else {
            let animationDuration = ((notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]) as? TimeInterval) ?? 0.25
            UIView.animate(withDuration: animationDuration) { [weak self] in
                self?.adjustKeyboardDown()
            }
        }
    }

    fileprivate func adjustKeyboardUp(contentInset: UIEdgeInsets) {
        scrollView.contentInset = contentInset
        scrollView.contentOffset = CGPoint(x: 0, y: contentInset.bottom)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    fileprivate func adjustKeyboardDown() {
        scrollView.contentInset = .zero
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    private func setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)

        deleteButton.isEnabled = false

        scrollView.addSubview(contentView)

        addSubview(scrollView)
        // addSubview(customerServiceStackView)

        // contentView.addSubview(infoLabel)
        contentView.addSubview(inputsContainer)

        // inputsContainer.addSubview(emailTextField)
        inputsContainer.addSubview(nameTextField)
        inputsContainer.addSubview(deleteButton)

        // contentView.addSubview(forgotPasswordButton)
        // contentView.addSubview(newUserStackView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            // infoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .largeSpacing),
            // infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .largeSpacing),
            // infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.largeSpacing),

            inputsContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumLargeSpacing),
            inputsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .largeSpacing),
            inputsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.largeSpacing),

            nameTextField.topAnchor.constraint(equalTo: inputsContainer.topAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: inputsContainer.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: inputsContainer.trailingAnchor),

            // passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: .largeSpacing),
            // passwordTextField.leadingAnchor.constraint(equalTo: inputsContainer.leadingAnchor),
            // passwordTextField.trailingAnchor.constraint(equalTo: inputsContainer.trailingAnchor),

            deleteButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: .largeSpacing),
            deleteButton.leadingAnchor.constraint(equalTo: inputsContainer.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: inputsContainer.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            deleteButton.bottomAnchor.constraint(equalTo: inputsContainer.bottomAnchor),

            // newUserStackView.topAnchor.constraint(equalTo: inputsContainer.bottomAnchor, constant: .mediumLargeSpacing),
            // newUserStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .largeSpacing),
            // newUserStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            // spidLogoImageView.heightAnchor.constraint(equalToConstant: 17),

            // forgotPasswordButton.bottomAnchor.constraint(equalTo: newUserStackView.lastBaselineAnchor, constant: .mediumSpacing),
            // forgotPasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.largeSpacing),

            // customerServiceStackView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -.veryLargeSpacing),
            // customerServiceStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
        ])
    }

    // MARK: - Actions

    @objc func handleTap() {
        endEditing(true)
    }

    @objc func deleteButtonSelected() {
        
    }
}

// MARK: - TextFieldDelegate

extension SavedSearchSettingsView: TextFieldDelegate {
    public func textFieldShouldReturn(_ textField: TextField) -> Bool {
        // delegate?.savedSearchSettingsView(self, didOccurIncompleteCredentials: true)
        return true
    }
}
