//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public protocol CoronaHelpViewDelegate: AnyObject {
    func coronaHelpViewDidTapReadMore(_ view: CoronaHelpView)
    func coronaHelpViewDidTapCallToAction(_ view: CoronaHelpView)
    func coronaHelpViewDidTapClose(_ view: CoronaHelpView)
}

public class CoronaHelpView: UIView {
    // MARK: - Public properties

    public weak var delegate: CoronaHelpViewDelegate?

    // MARK: - Private subviews

    private lazy var headerImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var readMoreButton: Button = {
        let button = Button(style: .link, withAutoLayout: true)
        button.addTarget(self, action: #selector(readMoreTapped), for: .touchUpInside)
        return button
    }()

    private lazy var actionsView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.layoutMargins = UIEdgeInsets(vertical: .spacingM, horizontal: .spacingL)
        return view
    }()

    private lazy var callToActionButton: Button = {
        let button = Button(style: .callToAction, withAutoLayout: true)
        button.addTarget(self, action: #selector(callToActionTapped), for: .touchUpInside)
        return button
    }()

    private lazy var contentView: UIView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(vertical: 0, horizontal: .spacingL)
        stackView.spacing = .spacingM
        stackView.isLayoutMarginsRelativeArrangement = true

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(readMoreButton)

        return stackView
    }()

    private lazy var missionPopupView: MissionPopupView = {
        let view = MissionPopupView(
            withAutoLayout: true,
            headerView: headerImageView,
            contentView: contentView,
            actionView: actionsView
        )
        view.delegate = self
        view.layer.borderColor = .popUpBorder
        view.layer.borderWidth = 1

        return view
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIView overrides

    public override func layoutSubviews() {
        super.layoutSubviews()

        missionPopupView.layer.borderColor = .popUpBorder
    }

    // MARK: - Public methods

    public func configure(with viewModel: CoronaHelpViewModel) {
        headerImageView.image = viewModel.header
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        readMoreButton.setTitle(viewModel.readMore.title, for: .normal)
        callToActionButton.setTitle(viewModel.callToAction.title, for: .normal)
    }

    // MARK: - Private methods

    private func setup() {
        addSubview(missionPopupView)
        missionPopupView.fillInSuperview()

        actionsView.addSubview(callToActionButton)
        NSLayoutConstraint.activate([
            callToActionButton.leadingAnchor.constraint(
                equalTo: actionsView.layoutMarginsGuide.leadingAnchor
            ),
            callToActionButton.trailingAnchor.constraint(
                equalTo: actionsView.layoutMarginsGuide.trailingAnchor
            ),
            callToActionButton.bottomAnchor.constraint(
                equalTo: actionsView.layoutMarginsGuide.bottomAnchor
            ),
        ])
    }

    @objc private func callToActionTapped() {
        delegate?.coronaHelpViewDidTapCallToAction(self)
    }

    @objc private func readMoreTapped() {
        delegate?.coronaHelpViewDidTapReadMore(self)
    }
}

// MARK: - MissionPopupViewDelegate

extension CoronaHelpView: MissionPopupViewDelegate {
    public func missionPopupViewDidSelectClose(_ view: MissionPopupView) {
        delegate?.coronaHelpViewDidTapClose(self)
    }
}

private extension CGColor {
    class var popUpBorder: CGColor {
        UIColor.dynamicColorIfAvailable(
            defaultColor: .sardine,
            darkModeColor: .darkSardine
        ).cgColor
    }
}
