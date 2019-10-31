//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

// MARK: - Model
public protocol SettingsDetailsViewModel {
    var icon: UIImage { get }
    var title: String { get }
    var primaryButtonStyle: Button.Style { get }
    var primaryButtonTitle: String { get }
    func text(for state: SettingsDetailsView.State) -> String
    func textAlignment(for state: SettingsDetailsView.State) -> NSTextAlignment
    func secondaryButtonTitle(for state: SettingsDetailsView.State) -> String?
}

// MARK: - Delegate
public protocol SettingsDetailsViewDelegate: AnyObject {
    func settingsDetailsView(_ detailsView: SettingsDetailsView, didChangeTo state: SettingsDetailsView.State, with model: SettingsDetailsViewModel)
    func settingsDetailsView(_ detailsView: SettingsDetailsView, didTapPrimaryButtonWith model: SettingsDetailsViewModel)
}

// MARK: - View
public class SettingsDetailsView: UIView {

    public enum State {
        case normal
        case details
    }

    // MARK: - Public properties

    public weak var delegate: SettingsDetailsViewDelegate?

    // MARK: - Private properties

    private var state: State = .normal
    private var model: SettingsDetailsViewModel?

    // MARK: - Subviews

    private lazy var iconView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var textLabel: Label = {
        let label = Label(style: .bodyRegular, withAutoLayout: true)
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var secondaryButton: Button = {
        let button = Button(style: .flat, withAutoLayout: true)
        button.addTarget(self, action: #selector(secondaryButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var primaryButton: Button = {
        let button = Button(style: .callToAction, withAutoLayout: true)
        button.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var shadowView = DynamicShadowView(
        withAutoLayout: true
    )

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.delegate = self

        scrollView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: bottomInset + 44 + .largeSpacing,
            right: 0
        )

        return scrollView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .bgPrimary
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.updateShadow(using: scrollView)
    }
}

// MARK: - Public methods
public extension SettingsDetailsView {
    func configure(with model: SettingsDetailsViewModel, animated: Bool = false) {
        self.model = model

        UIView.transition(
            with: self,
            duration: animated ? 0.3 : 0,
            options: .transitionCrossDissolve,
            animations: {
                self.iconView.image = model.icon
                self.titleLabel.text = model.title
                self.primaryButton.setTitle(model.primaryButtonTitle, for: .normal)
                self.primaryButton.style = model.primaryButtonStyle
                self.secondaryButton.isHidden = model.secondaryButtonTitle(for: self.state) == nil
                self.secondaryButton.setTitle(model.secondaryButtonTitle(for: self.state), for: .normal)
                self.textLabel.text = model.text(for: self.state)
                self.textLabel.textAlignment = model.textAlignment(for: self.state)
            }
        )
    }

    var contentSize: CGSize {
        CGSize(
            width: scrollView.contentSize.width,
            height: scrollView.contentSize.height + bottomInset + 44
        )
    }
}

extension SettingsDetailsView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        shadowView.updateShadow(using: scrollView)
    }
}

// MARK: - Private methods
private extension SettingsDetailsView {
    var bottomInset: CGFloat {
        UIView.windowSafeAreaInsets.bottom + .mediumLargeSpacing
    }

    @objc func secondaryButtonTapped() {
        guard let model = model else { return }

        switch state {
        case .normal: state = .details
        case .details: state = .normal
        }

        configure(with: model, animated: true)
        delegate?.settingsDetailsView(self, didChangeTo: state, with: model)

        superview?.layoutIfNeeded()
        shadowView.updateShadow(using: scrollView)
    }

    @objc func primaryButtonTapped() {
        guard let model = model else { return }
        delegate?.settingsDetailsView(self, didTapPrimaryButtonWith: model)
    }

    func setup() {
        scrollView.addSubview(iconView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(textLabel)
        scrollView.addSubview(secondaryButton)
        addSubview(scrollView)
        addSubview(shadowView)
        addSubview(primaryButton)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            iconView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: .mediumSpacing + .mediumLargeSpacing),
            iconView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: .mediumLargeSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -.mediumLargeSpacing),
            titleLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -.largeSpacing),

            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumSpacing),
            textLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .mediumLargeSpacing),
            textLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -.mediumLargeSpacing),
            textLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -.largeSpacing),
            textLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -44),

            secondaryButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            secondaryButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor),

            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shadowView.topAnchor.constraint(equalTo: primaryButton.topAnchor, constant: -.mediumLargeSpacing),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor),

            primaryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            primaryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            primaryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomInset),
        ])
    }
}
