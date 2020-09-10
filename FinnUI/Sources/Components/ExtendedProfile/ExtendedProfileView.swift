//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public protocol ExtendedProfileViewDelegate: AnyObject {
    func extendedProfileView(_  extendedProfileView: ExtendedProfileView, didSelectLinkAtIndex index: Int)
    func extendedProfileViewDidSelectActionButton(_ extendedProfileView: ExtendedProfileView)
    func extendedProfileView(_ extendedProfileView: ExtendedProfileView, didChangeStateTo newState: ExtendedProfileView.State)
}

public class ExtendedProfileView: UIView {

    public enum State {
        case alwaysExpanded
        case expanded
        case collapsed
    }

    public enum Placement {
        case top
        case sidebar
        case bottom
    }

    // MARK: - Subviews

    private lazy var headerImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var sloganBoxView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(toggleExpandState)
        )
        view.addGestureRecognizer(tapGestureRecognizer)
        return view
    }()

    private lazy var sloganLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    private lazy var toggleButton: ExpandCollapseButton = {
        let button = ExpandCollapseButton(
            frame: CGRect(
                x: 0,
                y: 0,
                width: ExtendedProfileView.toggleButtonSize,
                height: ExtendedProfileView.toggleButtonSize
            )
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        button.addTarget(self, action: #selector(toggleExpandState), for: .touchUpInside)
        return button
    }()

    private lazy var bodyStackView: UIStackView = {
        let view = UIStackView(withAutoLayout: true)
        view.axis = .vertical
        view.spacing = .spacingM
        return view
    }()

    private lazy var linksStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.alignment = .fill
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var actionButton: Button = {
        let button = Button(style: .callToAction, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var footerImageContainer = UIView(withAutoLayout: true)

    private lazy var footerImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let fallbackImage = UIImage(named: .noImage)

    // MARK: - Private properties

    private static let toggleButtonSize: CGFloat = 30
    private static let bodyViewHorizontalSpacing: CGFloat = .spacingS

    private lazy var headerImageHeightConstraint = {
        headerImageView.heightAnchor.constraint(equalToConstant: 150)
    }()

    private lazy var bodyStackViewTopAnchorConstraint = {
        bodyStackView.topAnchor.constraint(equalTo: sloganBoxView.bottomAnchor)
    }()

    private lazy var bodyStackViewBottomAnchorConstraint = {
        bodyStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
    }()

    private var state: State = .collapsed

    // MARK: - Public properties

    public weak var delegate: ExtendedProfileViewDelegate?
    public let placement: Placement

    // MARK: - Init

    public init(
        placement: Placement,
        withAutoLayout: Bool,
        remoteImageViewDataSource: RemoteImageViewDataSource
    ) {
        self.placement = placement
        super.init(frame: .zero)
        setup()
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        headerImageView.dataSource = remoteImageViewDataSource
        footerImageView.dataSource = remoteImageViewDataSource
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(headerImageView)
        addSubview(sloganBoxView)
        addSubview(bodyStackView)

        sloganBoxView.addSubview(sloganLabel)
        sloganBoxView.addSubview(toggleButton)

        let toggleButtonSpacing: CGFloat = .spacingS
        let bodyStackViewSpacing: CGFloat = placement == .sidebar ? 0 : ExtendedProfileView.bodyViewHorizontalSpacing

        NSLayoutConstraint.activate([
            headerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerImageView.topAnchor.constraint(equalTo: topAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerImageHeightConstraint,

            sloganBoxView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sloganBoxView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor),
            sloganBoxView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sloganBoxView.heightAnchor.constraint(equalToConstant: 50),

            sloganLabel.leadingAnchor.constraint(equalTo: sloganBoxView.leadingAnchor,
                                                 constant: ExtendedProfileView.toggleButtonSize + toggleButtonSpacing),
            sloganLabel.trailingAnchor.constraint(equalTo: toggleButton.leadingAnchor),
            sloganLabel.centerYAnchor.constraint(equalTo: sloganBoxView.centerYAnchor),

            toggleButton.centerYAnchor.constraint(equalTo: sloganBoxView.centerYAnchor),
            toggleButton.heightAnchor.constraint(equalToConstant: ExtendedProfileView.toggleButtonSize),
            toggleButton.widthAnchor.constraint(equalToConstant: ExtendedProfileView.toggleButtonSize),
            toggleButton.trailingAnchor.constraint(equalTo: sloganBoxView.trailingAnchor, constant: -toggleButtonSpacing),

            bodyStackViewTopAnchorConstraint,
            bodyStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: bodyStackViewSpacing),
            bodyStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -bodyStackViewSpacing),
            bodyStackViewBottomAnchorConstraint,

            footerImageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }

    // MARK: - Public methods

    public func configure(
        forState state: State,
        with viewModel: ExtendedProfileViewModel,
        width: CGFloat
    ) {
        self.state = state

        let showHeaderImage = placement == .top

        if showHeaderImage,
            let headerImageUrl = viewModel.headerImageUrl {
            headerImageView.loadImage(
                for: headerImageUrl,
                imageWidth: width,
                loadingColor: viewModel.mainBackgroundColor,
                fallbackImage: fallbackImage
            )
        } else {
            headerImageView.isHidden = true
            headerImageHeightConstraint.constant = 0
        }

        backgroundColor = viewModel.mainBackgroundColor
        sloganLabel.text = viewModel.sloganText
        sloganLabel.textColor = viewModel.sloganTextColor
        sloganBoxView.backgroundColor = viewModel.sloganBackgroundColor

        switch state {
        case .collapsed, .expanded:
            toggleButton.tintColor = viewModel.sloganBackgroundColor.contrastingColor()
            updateToggleButtonState()
        case .alwaysExpanded:
            toggleButton.isHidden = true
            sloganBoxView.isUserInteractionEnabled = false
        }

        if state == .collapsed {
            bodyStackViewTopAnchorConstraint.constant = 0
            bodyStackViewBottomAnchorConstraint.constant = 0
            bodyStackView.removeArrangedSubviews()
            return
        }

        bodyStackView.removeArrangedSubviews()
        bodyStackViewTopAnchorConstraint.constant = .spacingM
        bodyStackViewBottomAnchorConstraint.constant = placement == .sidebar ? -.spacingM : -2 * .spacingL

        if !viewModel.linkTitles.isEmpty {
            setupLinks(with: viewModel.linkTitles, withTextColor: viewModel.mainTextColor)
        }

        if let actionButtonTitle = viewModel.actionButtonTitle {
            actionButton.setTitle(actionButtonTitle, for: .normal)

            let backgroundColor = viewModel.actionButtonBackgroundColor
            actionButton.style = Button.Style.callToAction.overrideStyle(
                bodyColor: backgroundColor,
                textColor: viewModel.actionButtonTextColor,
                highlightedBodyColor: backgroundColor?.withAlphaComponent(0.8)
            )
            bodyStackView.addArrangedSubview(actionButton)
            bodyStackView.setCustomSpacing(.spacingL, after: actionButton)
        }

        if placement != .sidebar,
            let footerImageUrl = viewModel.footerImageUrl {
            setupFooterImage(
                imageUrl: footerImageUrl,
                width: width,
                loadingColor: viewModel.mainBackgroundColor
            )
        }
    }

    // MARK: - Private methods

    private func setupLinks(with titles: [String], withTextColor textColor: UIColor) {
        linksStackView.removeArrangedSubviews()
        bodyStackView.addArrangedSubview(linksStackView)

        for title in titles {
            addLinkButton(with: title, withTextColor: textColor)

            if title != titles.last {
                addLinkButtonSeparatorLine(withColor: textColor)
            }
        }
    }

    private func setupFooterImage(imageUrl: String, width: CGFloat, loadingColor: UIColor) {
        let extraInsets: CGFloat = .spacingM

        footerImageView.loadImage(
            for: imageUrl,
            imageWidth: width - 2 * (extraInsets + ExtendedProfileView.bodyViewHorizontalSpacing),
            loadingColor: loadingColor,
            fallbackImage: fallbackImage
        )

        bodyStackView.addArrangedSubview(footerImageContainer)
        footerImageContainer.addSubview(footerImageView)

        NSLayoutConstraint.activate([
            footerImageView.leadingAnchor.constraint(equalTo: footerImageContainer.leadingAnchor, constant: extraInsets),
            footerImageView.topAnchor.constraint(equalTo: footerImageContainer.topAnchor),
            footerImageView.trailingAnchor.constraint(equalTo: footerImageContainer.trailingAnchor, constant: -extraInsets),
            footerImageView.bottomAnchor.constraint(equalTo: footerImageContainer.bottomAnchor),
        ])
    }

    private func addLinkButton(with title: String, withTextColor textColor: UIColor) {
        let style = Button.Style.link.overrideStyle(
            textColor: textColor,
            highlightedTextColor: textColor.withAlphaComponent(0.6)
        )
        let button = Button(style: style, withAutoLayout: true)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(linkTapped(_:)), for: .touchUpInside)

        linksStackView.addArrangedSubview(button)
    }

    private func addLinkButtonSeparatorLine(withColor color: UIColor) {
        let separator = UIView(withAutoLayout: true)
        separator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
        separator.backgroundColor = color.withAlphaComponent(0.5)
        linksStackView.addArrangedSubview(separator)
    }

    private func updateToggleButtonState() {
        guard state != .alwaysExpanded else { return }
        toggleButton.setExpanded(state == .expanded, animated: true)
    }

    // MARK: - Actions

    @objc private func toggleExpandState() {
        guard state != .alwaysExpanded else { return }
        state = state == .expanded ? .collapsed : .expanded
        delegate?.extendedProfileView(self, didChangeStateTo: state)
    }

    @objc private func linkTapped(_ sender: Button) {
        guard let index = linksStackView.arrangedSubviews.filter({ $0 is Button }).firstIndex(of: sender) else {
            return
        }
        delegate?.extendedProfileView(self, didSelectLinkAtIndex: index)
    }

    @objc private func actionButtonTapped() {
        delegate?.extendedProfileViewDidSelectActionButton(self)
    }
}

// MARK: - Private extensions

private extension UIColor {

    var luminance: CGFloat {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)

        // http://en.wikipedia.org/wiki/Luma_(video)
        // Y = 0.2126 R + 0.7152 G + 0.0722 B
        return 0.2126 * red + 0.7152 * green + 0.0722 * blue
    }

    func contrastingColor() -> UIColor {
        if luminance > 0.6 {
            return UIColor.black
        } else {
            return UIColor.white
        }
    }
}
