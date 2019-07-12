//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public class LoginEntryDialogueView: UIView {
    // MARK: - Public properties

    public var model: LoginEntryViewModel? {
        didSet {
            title.text = model?.title
            detail.text = model?.detail
            loginButton.setTitle(model?.loginButtonTitle, for: .normal)
            registerButton.setTitle(model?.registerButtonTitle, for: .normal)
        }
    }
    public weak var delegate: LoginEntryViewDelegate?

    // MARK: - Private properties

    private lazy var logo: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .finnLogo)
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private lazy var title: UILabel = {
        // overriding the font to get the title2 strong without affecting
        // the design system itself for now
        let title2StrongFont = UIFont(name: FontType.medium.rawValue, size: 28.0)!
            .scaledFont(forTextStyle: .title2)

        let label = Label(style: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = title2StrongFont
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    private lazy var detail: UILabel = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    private lazy var loginButton: UIButton = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLoginButtonTap), for: .touchUpInside)

        return button
    }()

    private lazy var registerButton: UIButton = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRegisterButtonTap), for: .touchUpInside)

        return button
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

    // MARK: - Private methods

    private func setup() {
        layer.cornerRadius = 33
        layoutMargins = UIEdgeInsets(all: .largeSpacing)

        addSubview(logo)
        addSubview(title)
        addSubview(detail)
        addSubview(loginButton)
        addSubview(registerButton)

        let margin = layoutMarginsGuide

        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: margin.topAnchor, constant: .largeSpacing),
            logo.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            logo.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            logo.heightAnchor.constraint(equalToConstant: 56),

            title.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: .largeSpacing),
            title.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: margin.trailingAnchor),

            detail.topAnchor.constraint(equalTo: title.bottomAnchor, constant: .mediumSpacing),
            detail.leadingAnchor.constraint(equalTo: margin.leadingAnchor, constant: .mediumSpacing),
            detail.trailingAnchor.constraint(equalTo: margin.trailingAnchor, constant: -.mediumSpacing),

            loginButton.topAnchor.constraint(equalTo: detail.bottomAnchor, constant: .largeSpacing),
            loginButton.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: margin.trailingAnchor),

            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: .mediumLargeSpacing),
            registerButton.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            registerButton.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            registerButton.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
        ])
    }

    @objc private func handleLoginButtonTap() {
        delegate?.loginEntryViewDidSelectLoginButton()
    }

    @objc private func handleRegisterButtonTap() {
        delegate?.loginEntryViewDidSelectRegisterButton()
    }
}
