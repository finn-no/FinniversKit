//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Bootstrap

public protocol EarthHourViewDelegate: AnyObject {
    func earthHourViewDidSelectReadMore(_ view: EarthHourView)
    func earthHourViewDidSelectAccept(_ view: EarthHourView)
    func earthHourViewDidSelectDismiss(_ view: EarthHourView)
}

public final class EarthHourView: UIView {
    public weak var delegate: EarthHourViewDelegate?

    public var model: EarthHourViewModel? {
        didSet {
            signUpView.titleLabel.text = model?.title
            signUpView.subtitleTagView.titleLabel.text = model?.subtitle
            signUpView.bodyTextLabel.attributedText = attributedBodyString(with: model?.bodyText ?? "")
            signUpView.primaryButton.setTitle(model?.acceptButtonTitle, for: .normal)
            signUpView.secondaryButton.setTitle(model?.denyButtonTitle, for: .normal)
            signUpView.accessoryButton.setTitle(model?.readMoreButtonTitle, for: .normal)

            thankYouView.titleLabel.text = model?.thankYouTitle
            thankYouView.bodyTextLabel.attributedText = attributedBodyString(with: model?.thankYouBodyText ?? "")
            thankYouView.accessoryButton.setTitle(model?.readMoreButtonTitle, for: .normal)
        }
    }

    // MARK: - Private properties

    private let collapsedHeaderHeight: CGFloat = 159

    private lazy var headerView: EarthHourHeaderView = {
        let view = EarthHourHeaderView(withAutoLayout: true)
        view.bottomCurveHeight = collapsedHeaderHeight
        view.closeButton.addTarget(self, action: #selector(handleCloseButtonTap), for: .touchUpInside)
        return view
    }()

    private lazy var signUpView: EarthHourSignUpView = {
        let view = EarthHourSignUpView(withAutoLayout: true)
        view.primaryButton.addTarget(self, action: #selector(handlePrimaryButtonTap), for: .touchUpInside)
        view.secondaryButton.addTarget(self, action: #selector(handleSecondaryButtonTap), for: .touchUpInside)
        view.accessoryButton.addTarget(self, action: #selector(handleAccessoryButtonTap), for: .touchUpInside)
        return view
    }()

    private lazy var thankYouView: EarthHourContentView = {
        let view = EarthHourContentView(withAutoLayout: true)
        view.alpha = 0
        view.accessoryButton.addTarget(self, action: #selector(handleAccessoryButtonTap), for: .touchUpInside)
        return view
    }()

    private lazy var headerViewHeight = headerView.heightAnchor.constraint(equalToConstant: collapsedHeaderHeight)
    private lazy var singUpViewBottom = signUpView.bottomAnchor.constraint(equalTo: bottomAnchor)
    private lazy var thankYouViewBottom = thankYouView.bottomAnchor.constraint(
        equalTo: bottomAnchor,
        constant: .veryLargeSpacing
    )

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Animation

    public func animateBackground() {
        headerView.animateEarth()
    }

    public func expand() {
        headerViewHeight.constant = bounds.height * 0.7
        singUpViewBottom.constant = bounds.height
        thankYouViewBottom.constant = 0

        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.thankYouView.alpha = 1
            self?.signUpView.alpha = 0
            self?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.headerView.animateHeart()
        })
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgPrimary
        layer.masksToBounds = true
        layer.cornerRadius = 24

        addSubview(headerView)
        addSubview(signUpView)
        addSubview(thankYouView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerViewHeight,

            signUpView.leadingAnchor.constraint(equalTo: leadingAnchor),
            signUpView.trailingAnchor.constraint(equalTo: trailingAnchor),
            signUpView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            singUpViewBottom,

            thankYouView.leadingAnchor.constraint(equalTo: leadingAnchor),
            thankYouView.trailingAnchor.constraint(equalTo: trailingAnchor),
            thankYouView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            thankYouViewBottom
        ])
    }

    private func attributedBodyString(with text: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = .smallSpacing
        paragraphStyle.alignment = .center

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.bodyRegular
        ]

        return NSAttributedString(string: text, attributes: attributes)
    }

    // MARK: - Actions

    @objc private func handlePrimaryButtonTap() {
        delegate?.earthHourViewDidSelectAccept(self)
    }

    @objc private func handleSecondaryButtonTap() {
        delegate?.earthHourViewDidSelectDismiss(self)
    }

    @objc private func handleAccessoryButtonTap() {
        delegate?.earthHourViewDidSelectReadMore(self)
    }

    @objc private func handleCloseButtonTap() {
        delegate?.earthHourViewDidSelectDismiss(self)
    }
}
