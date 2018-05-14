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

    private lazy var mainIntroLabel: Label = {
        let label = Label(style: .body(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var usageHeaderLabel: Label = {
        let label = Label(style: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var usageIntro1Label: Label = {
        let label = Label(style: .body(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var usageIntro2Label: Label = {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var usageBulletPointsLabel: Label = {
        let label = Label(style: .body(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var improveHeaderLabel: Label = {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var improveIntroLabel: Label = {
        let label = Label(style: .body(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var improveButtonIntroLabel: Label = {
        let label = Label(style: .body(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var settingsFinnButton: Button = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(settingsFinnTapped), for: .touchUpInside)
        return button
    }()

    private lazy var privacyFinnButton: Button = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(privacyFinnTapped), for: .touchUpInside)
        return button
    }()

    private lazy var usageSchibstedHeaderLabel: Label = {
        let label = Label(style: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var usageSchibstedIntroLabel: Label = {
        let label = Label(style: .body(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var usageSchibstedBulletPointsLabel: Label = {
        let label = Label(style: .body(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var usageSchibstedButtonIntroLabel: Label = {
        let label = Label(style: .body(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var settingsSchibstedButton: Button = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(settingsSchibstedTapped), for: .touchUpInside)
        return button
    }()

    private lazy var privacySchibstedButton: Button = {
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
            mainIntroLabel.text = model.mainIntroText
            usageHeaderLabel.text = model.usageHeaderText
            usageIntro1Label.text = model.usageIntro1Text
            usageIntro2Label.text = model.usageIntro2Text
            usageBulletPointsLabel.attributedText = model.usageBulletPointsText.asBulletPoints()
            improveHeaderLabel.text = model.improveHeaderText
            improveIntroLabel.text = model.improveIntroText
            if showSettingsButtons {
                improveButtonIntroLabel.text = model.improveButtonIntroWithSettingsText
            } else {
                improveButtonIntroLabel.text = model.improveButtonIntroWithoutSettingsText
            }
            settingsFinnButton.setTitle(model.settingsFinnButtonTitle, for: .normal)
            privacyFinnButton.setTitle(model.privacyFinnButtonTitle, for: .normal)
            usageSchibstedHeaderLabel.text = model.usageSchibstedHeaderText
            usageSchibstedIntroLabel.text = model.usageSchibstedIntroText
            usageSchibstedBulletPointsLabel.attributedText = model.usageBulletPointsText.asBulletPoints()
            if showSettingsButtons {
                usageSchibstedButtonIntroLabel.text = model.usageSchibstedButtonIntroWithSettingsText
            } else {
                usageSchibstedButtonIntroLabel.text = model.usageSchibstedButtonIntroWithoutSettingsText
            }
            settingsSchibstedButton.setTitle(model.settingsSchibstedButtonTitle, for: .normal)
            privacySchibstedButton.setTitle(model.privacySchibstedButtonTitle, for: .normal)
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
        contentView.addSubview(mainIntroLabel)
        contentView.addSubview(usageHeaderLabel)
        contentView.addSubview(usageIntro1Label)
        contentView.addSubview(usageIntro2Label)
        contentView.addSubview(usageBulletPointsLabel)
        contentView.addSubview(improveHeaderLabel)
        contentView.addSubview(improveIntroLabel)
        contentView.addSubview(improveButtonIntroLabel)
        contentView.addSubview(privacyFinnButton)
        contentView.addSubview(usageSchibstedHeaderLabel)
        contentView.addSubview(usageSchibstedIntroLabel)
        contentView.addSubview(usageSchibstedBulletPointsLabel)
        contentView.addSubview(usageSchibstedButtonIntroLabel)
        contentView.addSubview(privacySchibstedButton)

        let privacyFinnButtonConstraintToSettings = privacyFinnButton.topAnchor.constraint(equalTo: settingsFinnButton.bottomAnchor, constant: .mediumLargeSpacing)
        let privacyFinnButtonConstraintToIntro = privacyFinnButton.topAnchor.constraint(equalTo: improveButtonIntroLabel.bottomAnchor, constant: .mediumLargeSpacing)

        let privacySchibstedButtonConstraintToSettings = privacySchibstedButton.topAnchor.constraint(equalTo: settingsSchibstedButton.bottomAnchor, constant: .mediumLargeSpacing)
        let privacySchibstedButtonConstraintToIntro = privacySchibstedButton.topAnchor.constraint(equalTo: usageSchibstedButtonIntroLabel.bottomAnchor, constant: .mediumLargeSpacing)

        privacyFinnButtonConstraintToSettings.isActive = false
        privacySchibstedButtonConstraintToSettings.isActive = false

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

            mainIntroLabel.topAnchor.constraint(equalTo: mainHeaderLabel.bottomAnchor, constant: .mediumLargeSpacing),
            mainIntroLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            mainIntroLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            usageHeaderLabel.topAnchor.constraint(equalTo: mainIntroLabel.bottomAnchor, constant: .mediumLargeSpacing),
            usageHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            usageHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            usageIntro1Label.topAnchor.constraint(equalTo: usageHeaderLabel.bottomAnchor, constant: .mediumLargeSpacing),
            usageIntro1Label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            usageIntro1Label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            usageIntro2Label.topAnchor.constraint(equalTo: usageIntro1Label.bottomAnchor, constant: .mediumLargeSpacing),
            usageIntro2Label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            usageIntro2Label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            usageBulletPointsLabel.topAnchor.constraint(equalTo: usageIntro2Label.bottomAnchor, constant: .mediumLargeSpacing),
            usageBulletPointsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            usageBulletPointsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            improveHeaderLabel.topAnchor.constraint(equalTo: usageBulletPointsLabel.bottomAnchor, constant: .mediumLargeSpacing),
            improveHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            improveHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            improveIntroLabel.topAnchor.constraint(equalTo: improveHeaderLabel.bottomAnchor, constant: .mediumLargeSpacing),
            improveIntroLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            improveIntroLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            improveButtonIntroLabel.topAnchor.constraint(equalTo: improveIntroLabel.bottomAnchor, constant: .mediumLargeSpacing),
            improveButtonIntroLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            improveButtonIntroLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            privacyFinnButtonConstraintToIntro,
            privacyFinnButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            privacyFinnButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            usageSchibstedHeaderLabel.topAnchor.constraint(equalTo: privacyFinnButton.bottomAnchor, constant: .mediumLargeSpacing),
            usageSchibstedHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            usageSchibstedHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            usageSchibstedIntroLabel.topAnchor.constraint(equalTo: usageSchibstedHeaderLabel.bottomAnchor, constant: .mediumLargeSpacing),
            usageSchibstedIntroLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            usageSchibstedIntroLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            usageSchibstedBulletPointsLabel.topAnchor.constraint(equalTo: usageSchibstedIntroLabel.bottomAnchor, constant: .mediumLargeSpacing),
            usageSchibstedBulletPointsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            usageSchibstedBulletPointsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            usageSchibstedButtonIntroLabel.topAnchor.constraint(equalTo: usageSchibstedBulletPointsLabel.bottomAnchor, constant: .mediumLargeSpacing),
            usageSchibstedButtonIntroLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            usageSchibstedButtonIntroLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            privacySchibstedButtonConstraintToIntro,
            privacySchibstedButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            privacySchibstedButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            privacySchibstedButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumSpacing),
        ])

        if showSettingsButtons {
            contentView.addSubview(settingsFinnButton)
            contentView.addSubview(settingsSchibstedButton)

            privacyFinnButtonConstraintToIntro.isActive = false
            privacySchibstedButtonConstraintToIntro.isActive = false

            NSLayoutConstraint.activate([
                privacyFinnButtonConstraintToSettings,
                settingsFinnButton.topAnchor.constraint(equalTo: improveButtonIntroLabel.bottomAnchor, constant: .mediumLargeSpacing),
                settingsFinnButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
                settingsFinnButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

                privacySchibstedButtonConstraintToSettings,
                settingsSchibstedButton.topAnchor.constraint(equalTo: usageSchibstedButtonIntroLabel.bottomAnchor, constant: .mediumLargeSpacing),
                settingsSchibstedButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
                settingsSchibstedButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
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
