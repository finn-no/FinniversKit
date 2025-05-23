//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit
import Warp

public protocol LoginEntryViewModel {
    var title: String { get }
    var detail: String { get }
    var includeSettings: Bool { get }
    var loginButtonTitle: String { get }
    var registerButtonTitle: String { get }
    var icon: UIImage { get }
    var vendLogo: UIImage { get }
}

public protocol LoginEntryViewDelegate: AnyObject {
    func loginEntryViewDidSelectLoginButton()
    func loginEntryViewDidSelectRegisterButton()
    func loginEntryViewDidSelectSettingsButton()
}

public class LoginEntryView: UIView {
    // MARK: - Public properties

    public weak var delegate: LoginEntryViewDelegate? {
        didSet {
            loginDialogue.delegate = delegate
        }
    }

    // MARK: - Private properties

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .background
        return view
    }()

    private lazy var settingsButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.setImage(UIImage(named: .settings).withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .textSubtle
        button.isHidden = true
        button.addTarget(self, action: #selector(handleTapOnSettingsButton), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(all: Warp.Spacing.spacing200)

        return button
    }()

    private lazy var loginDialogue: LoginEntryDialogueView = {
        let view = LoginEntryDialogueView(withAutoLayout: true)
        view.backgroundColor = Warp.UIToken.surfaceElevated100
        view.dropShadow(color: .backgroundDisabled, opacity: 0.3, offset: CGSize(width: 10, height: 0), radius: 24)

        return view
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

    public func configure(with model: LoginEntryViewModel) {
        loginDialogue.configure(with: model)
        settingsButton.isHidden = !model.includeSettings
    }

    // MARK: - Private methods

    private func setup() {
        addSubview(scrollView)
        addSubview(settingsButton)

        scrollView.fillInSuperview()

        scrollView.addSubview(contentView)
        contentView.addSubview(loginDialogue)

        NSLayoutConstraint.activate([
            settingsButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(
                equalTo: loginDialogue.widthAnchor, constant: Warp.Spacing.spacing400, priority: .defaultLow
            ),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
        ])

        let dialogueConstraints: [NSLayoutConstraint]
        if isHorizontalSizeClassRegular {
            dialogueConstraints = [
                loginDialogue.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                loginDialogue.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                loginDialogue.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.45),
            ]
        } else {
            dialogueConstraints = [
                loginDialogue.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Warp.Spacing.spacing200),
                loginDialogue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Warp.Spacing.spacing200),
                loginDialogue.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ]
        }

        NSLayoutConstraint.activate(dialogueConstraints)
    }

    @objc private func handleTapOnSettingsButton() {
        delegate?.loginEntryViewDidSelectSettingsButton()
    }
}
