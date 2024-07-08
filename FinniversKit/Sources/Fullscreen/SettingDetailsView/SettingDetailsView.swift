//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit
import Warp

// MARK: - Model
public protocol SettingDetailsViewModel {
    var icon: UIImage { get }
    var title: String { get }
    var primaryButtonStyle: Button.Style { get }
    var primaryButtonTitle: String { get }
    func attributedText(for state: SettingDetailsView.State) -> NSAttributedString
    func textAlignment(for state: SettingDetailsView.State) -> NSTextAlignment
    func secondaryButtonTitle(for state: SettingDetailsView.State) -> String?
}

// MARK: - Delegate
public protocol SettingDetailsViewDelegate: AnyObject {
    func settingDetailsView(_ detailsView: SettingDetailsView, didChangeTo state: SettingDetailsView.State, with model: SettingDetailsViewModel)
    func settingDetailsView(_ detailsView: SettingDetailsView, didTapPrimaryButtonWith model: SettingDetailsViewModel)
}

// MARK: - View
public class SettingDetailsView: UIView {

    public enum State {
        case lessDetails
        case moreDetails
    }

    // MARK: - Public properties

    public weak var delegate: SettingDetailsViewDelegate?

    // MARK: - Private properties

    private var state: State = .lessDetails
    private var model: SettingDetailsViewModel?

    // MARK: - Subviews

    private lazy var iconView = UIImageView(
        withAutoLayout: true
    )

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.textColor = .text
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var textLabel: Label = {
        let label = Label(style: .bodyRegular, withAutoLayout: true)
        label.textColor = .text
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

    private lazy var shadowView = TopShadowView(
        withAutoLayout: true
    )

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.delegate = self
        scrollView.contentInset = UIEdgeInsets(bottom: scrollViewBottomInset)
        return scrollView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
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

    public override var intrinsicContentSize: CGSize {
        CGSize(
            width: scrollView.contentSize.width,
            height: scrollView.contentSize.height + scrollViewBottomInset
        )
    }
}

// MARK: - Public methods
public extension SettingDetailsView {
    func configure(with model: SettingDetailsViewModel, animated: Bool = false) {
        self.model = model
        iconView.image = model.icon
        titleLabel.text = model.title
        primaryButton.setTitle(model.primaryButtonTitle, for: .normal)
        primaryButton.style = model.primaryButtonStyle
        secondaryButton.isHidden = model.secondaryButtonTitle(for: state) == nil
        secondaryButton.setTitle(model.secondaryButtonTitle(for: state), for: .normal)

        UIView.transition(
            with: textLabel,
            duration: animated ? 0.2 : 0,
            options: .transitionCrossDissolve,
            animations: {
                self.textLabel.attributedText = model.attributedText(for: self.state).replacingFont(with: .bodyRegular)
                self.textLabel.textAlignment = model.textAlignment(for: self.state)
            }
        )
    }
}

extension SettingDetailsView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        shadowView.updateShadow(using: scrollView)
    }
}

// MARK: - Private methods
private extension SettingDetailsView {
    var scrollViewBottomInset: CGFloat {
        bottomInset + 44 + .spacingXL
    }

    var bottomInset: CGFloat {
        UIView.windowSafeAreaInsets.bottom + Warp.Spacing.spacing200
    }

    @objc func secondaryButtonTapped() {
        guard let model = model else { return }

        switch state {
        case .lessDetails: state = .moreDetails
        case .moreDetails: state = .lessDetails
        }

        configure(with: model, animated: true)
        delegate?.settingDetailsView(self, didChangeTo: state, with: model)

        layoutIfNeeded()
        shadowView.updateShadow(using: scrollView)
    }

    @objc func primaryButtonTapped() {
        guard let model = model else { return }
        delegate?.settingDetailsView(self, didTapPrimaryButtonWith: model)
    }

    func setup() {
        scrollView.addSubview(iconView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(textLabel)
        scrollView.addSubview(secondaryButton)
        addSubview(scrollView)
        addSubview(shadowView)
        addSubview(primaryButton)

        scrollView.fillInSuperview()

        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: .spacingS + Warp.Spacing.spacing200),
            iconView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: Warp.Spacing.spacing200),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Warp.Spacing.spacing200),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Warp.Spacing.spacing200),
            titleLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -.spacingXL),

            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingS),
            textLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Warp.Spacing.spacing200),
            textLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Warp.Spacing.spacing200),
            textLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -.spacingXL),
            textLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -44),

            secondaryButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            secondaryButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor),

            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shadowView.topAnchor.constraint(equalTo: primaryButton.topAnchor, constant: -Warp.Spacing.spacing200),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor),

            primaryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            primaryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200),
            primaryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomInset),
        ])
    }
}

// MARK: - Private extensions

private extension NSAttributedString {
    func replacingFont(with font: UIFont) -> NSAttributedString {
        let range = NSRange(location: 0, length: length)
        let newText = NSMutableAttributedString(attributedString: self)
        newText.addAttribute(.font, value: UIFont.bodyRegular, range: range)
        return newText
    }
}
