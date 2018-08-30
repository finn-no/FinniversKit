//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol ConsentTransparencyInfoViewDelegate: AnyObject {
    func consentTransparencyInfoView(_ consentTransparencyInfoView: ConsentTransparencyInfoView, didSelectFinnSettings button: Button)
    func consentTransparencyInfoView(_ consentTransparencyInfoView: ConsentTransparencyInfoView, didSelectFinnPrivacy button: Button)
    func consentTransparencyInfoView(_ consentTransparencyInfoView: ConsentTransparencyInfoView, didSelectSchibstedSettings button: Button)
    func consentTransparencyInfoView(_ consentTransparencyInfoView: ConsentTransparencyInfoView, didSelectSchibstedPrivacy button: Button)
}

public final class ConsentTransparencyInfoView: UIView {
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

    private lazy var mainHeaderLabel: Label = {
        let label = Label(style: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var finnHeaderLabel: Label = {
        let label = Label(style: .title4)
        label.textColor = .licorice
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var finnIntroLabel: Label = {
        let label = Label(style: .body)
        label.textColor = .licorice
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var finnBulletPointsLabel: Label = {
        let label = Label(style: .body)
        label.textColor = .licorice
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var finnButtonIntroLabel: Label = {
        let label = Label(style: .body)
        label.textColor = .licorice
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var finnSettingsButton: Button = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(settingsFinnTapped), for: .touchUpInside)
        return button
    }()

    private lazy var finnPrivacyButton: Button = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(privacyFinnTapped), for: .touchUpInside)
        return button
    }()

    private lazy var schibstedHeaderLabel: Label = {
        let label = Label(style: .title4)
        label.textColor = .licorice
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var schibstedIntroLabel: Label = {
        let label = Label(style: .body)
        label.textColor = .licorice
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var schibstedBulletPointsLabel: Label = {
        let label = Label(style: .body)
        label.textColor = .licorice
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var schibstedButtonIntroLabel: Label = {
        let label = Label(style: .body)
        label.textColor = .licorice
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var schibstedSettingsButton: Button = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(settingsSchibstedTapped), for: .touchUpInside)
        return button
    }()

    private lazy var schibstedPrivacyButton: Button = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(privacySchibstedTapped), for: .touchUpInside)
        return button
    }()

    private var showSettingsButtons: Bool = false

    // MARK: - External properties / Dependency injection

    public weak var delegate: ConsentTransparencyInfoViewDelegate?

    public var model: ConsentTransparencyInfoViewModel? {
        didSet {
            guard let model = model else {
                return
            }

            mainHeaderLabel.text = model.mainHeaderText
            finnHeaderLabel.text = model.finnHeaderText
            finnIntroLabel.text = model.finnIntroText
            finnBulletPointsLabel.attributedText = model.finnBulletPointsText
            if showSettingsButtons {
                finnButtonIntroLabel.text = model.finnButtonIntroWithSettingsText
            } else {
                finnButtonIntroLabel.text = model.finnButtonIntroWithoutSettingsText
            }
            finnSettingsButton.setTitle(model.finnSettingsButtonTitle, for: .normal)
            finnPrivacyButton.setTitle(model.finnPrivacyButtonTitle, for: .normal)
            schibstedHeaderLabel.text = model.schibstedHeaderText
            schibstedIntroLabel.text = model.schibstedIntroText
            schibstedBulletPointsLabel.attributedText = model.finnBulletPointsText
            if showSettingsButtons {
                schibstedButtonIntroLabel.text = model.schibstedButtonIntroWithSettingsText
            } else {
                schibstedButtonIntroLabel.text = model.schibstedButtonIntroWithoutSettingsText
            }
            schibstedSettingsButton.setTitle(model.schibstedSettingsButtonTitle, for: .normal)
            schibstedPrivacyButton.setTitle(model.schibstedPrivacyButtonTitle, for: .normal)
        }
    }

    // MARK: - Setup

    private override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Superclass Overrides

    public convenience init(showSettingsButtons: Bool = false) {
        self.init(frame: .zero)

        self.showSettingsButtons = showSettingsButtons

        setup()
    }
}

// MARK: - Public

public extension ConsentTransparencyInfoView {
}

// MARK: - Private

private extension ConsentTransparencyInfoView {
    func setup() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(mainHeaderLabel)
        contentView.addSubview(finnHeaderLabel)
        contentView.addSubview(finnIntroLabel)
        contentView.addSubview(finnBulletPointsLabel)
        contentView.addSubview(finnButtonIntroLabel)
        contentView.addSubview(finnPrivacyButton)
        contentView.addSubview(schibstedHeaderLabel)
        contentView.addSubview(schibstedIntroLabel)
        contentView.addSubview(schibstedBulletPointsLabel)
        contentView.addSubview(schibstedButtonIntroLabel)
        contentView.addSubview(schibstedPrivacyButton)

        let finnPrivacyButtonConstraintToSettings = finnPrivacyButton.topAnchor.constraint(equalTo: finnSettingsButton.bottomAnchor, constant: .mediumLargeSpacing)
        let finnPrivacyButtonConstraintToIntro = finnPrivacyButton.topAnchor.constraint(equalTo: finnButtonIntroLabel.bottomAnchor, constant: .mediumLargeSpacing)

        let schibstedPrivacyButtonConstraintToSettings = schibstedPrivacyButton.topAnchor.constraint(equalTo: schibstedSettingsButton.bottomAnchor, constant: .mediumLargeSpacing)
        let schibstedPrivacyButtonConstraintToIntro = schibstedPrivacyButton.topAnchor.constraint(equalTo: schibstedButtonIntroLabel.bottomAnchor, constant: .mediumLargeSpacing)

        finnPrivacyButtonConstraintToSettings.isActive = false
        schibstedPrivacyButtonConstraintToSettings.isActive = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            mainHeaderLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
            mainHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            mainHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            finnHeaderLabel.topAnchor.constraint(equalTo: mainHeaderLabel.bottomAnchor, constant: .mediumLargeSpacing),
            finnHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            finnHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            finnIntroLabel.topAnchor.constraint(equalTo: finnHeaderLabel.bottomAnchor, constant: .mediumLargeSpacing),
            finnIntroLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            finnIntroLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            finnBulletPointsLabel.topAnchor.constraint(equalTo: finnIntroLabel.bottomAnchor, constant: .mediumLargeSpacing),
            finnBulletPointsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            finnBulletPointsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            finnButtonIntroLabel.topAnchor.constraint(equalTo: finnBulletPointsLabel.bottomAnchor, constant: .mediumLargeSpacing),
            finnButtonIntroLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            finnButtonIntroLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            finnPrivacyButtonConstraintToIntro,
            finnPrivacyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            finnPrivacyButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            schibstedHeaderLabel.topAnchor.constraint(equalTo: finnPrivacyButton.bottomAnchor, constant: .mediumLargeSpacing),
            schibstedHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            schibstedHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            schibstedIntroLabel.topAnchor.constraint(equalTo: schibstedHeaderLabel.bottomAnchor, constant: .mediumLargeSpacing),
            schibstedIntroLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            schibstedIntroLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            schibstedBulletPointsLabel.topAnchor.constraint(equalTo: schibstedIntroLabel.bottomAnchor, constant: .mediumLargeSpacing),
            schibstedBulletPointsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            schibstedBulletPointsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            schibstedButtonIntroLabel.topAnchor.constraint(equalTo: schibstedBulletPointsLabel.bottomAnchor, constant: .mediumLargeSpacing),
            schibstedButtonIntroLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            schibstedButtonIntroLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            schibstedPrivacyButtonConstraintToIntro,
            schibstedPrivacyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            schibstedPrivacyButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            schibstedPrivacyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumSpacing),
        ])

        if showSettingsButtons {
            contentView.addSubview(schibstedSettingsButton)
            contentView.addSubview(finnSettingsButton)

            finnPrivacyButtonConstraintToIntro.isActive = false
            schibstedPrivacyButtonConstraintToIntro.isActive = false

            NSLayoutConstraint.activate([
                finnPrivacyButtonConstraintToSettings,
                schibstedPrivacyButtonConstraintToSettings,

                schibstedSettingsButton.topAnchor.constraint(equalTo: schibstedButtonIntroLabel.bottomAnchor, constant: .mediumLargeSpacing),
                schibstedSettingsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
                schibstedSettingsButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

                finnSettingsButton.topAnchor.constraint(equalTo: finnButtonIntroLabel.bottomAnchor, constant: .mediumLargeSpacing),
                finnSettingsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
                finnSettingsButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            ])
        }
    }

    @objc func settingsFinnTapped(_ sender: Button) {
        delegate?.consentTransparencyInfoView(self, didSelectFinnSettings: sender)
    }

    @objc func privacyFinnTapped(_ sender: Button) {
        delegate?.consentTransparencyInfoView(self, didSelectFinnPrivacy: sender)
    }

    @objc func settingsSchibstedTapped(_ sender: Button) {
        delegate?.consentTransparencyInfoView(self, didSelectSchibstedSettings: sender)
    }

    @objc func privacySchibstedTapped(_ sender: Button) {
        delegate?.consentTransparencyInfoView(self, didSelectSchibstedPrivacy: sender)
    }
}
