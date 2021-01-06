//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public protocol ChatAvailabilityViewDelegate: AnyObject {
    func chatAvailabilityViewDidTapChatNowButton(_ view: ChatAvailabilityView)
    func chatAvailabilityViewDidTapBookingButton(_ view: ChatAvailabilityView)
}

public class ChatAvailabilityView: UIView {
    public enum Status: CaseIterable {
        case loading
        case online
        case offline
        case unknown
    }

    // MARK: - Public properties

    public weak var delegate: ChatAvailabilityViewDelegate?

    // MARK: - Private properties

    private lazy var statusView = StatusView(withAutoLayout: true)

    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
    private lazy var bookingStackView = UIStackView(axis: .vertical, spacing: .spacingXS, withAutoLayout: true)

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var textLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var chatNowButton: Button = {
        let button = Button(style: .callToAction, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleChatNowButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var bookingTitleLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var bookingButton: Button = {
        let buttonStyle = Button.Style.flat.overrideStyle(margins: UIEdgeInsets.zero)
        let button = Button(style: buttonStyle, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleBookingButtonTap), for: .touchUpInside)
        button.contentHorizontalAlignment = .leading
        return button
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(stackView)
        bookingStackView.addArrangedSubviews([bookingTitleLabel, bookingButton])
        stackView.addArrangedSubviews([titleLabel, textLabel, chatNowButton, statusView, bookingStackView])

        stackView.setCustomSpacing(.spacingM, after: textLabel)
        stackView.setCustomSpacing(.spacingM, after: statusView)
        stackView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(with viewModel: ChatAvailabilityViewModel) {
        if let title = viewModel.title {
            titleLabel.text = title
        } else {
            titleLabel.isHidden = true
        }
        if let text = viewModel.text {
            textLabel.text = text
        } else {
            textLabel.isHidden = true
        }

        chatNowButton.setTitle(viewModel.chatNowButtonTitle, for: .normal)

        bookingTitleLabel.text = viewModel.bookingTitle
        bookingButton.setTitle(viewModel.bookingButtonTitle, for: .normal)
    }

    public func configure(status: Status, statusTitle: String? = nil) {
        switch status {
        case .online, .unknown:
            chatNowButton.isEnabled = true
            bookingStackView.isHidden = false
        case .loading, .offline:
            chatNowButton.isEnabled = false
            bookingStackView.isHidden = true
        }

        statusView.configure(status: status, statusTitle: statusTitle)
    }

    // MARK: - Actions

    @objc private func handleChatNowButtonTap() {
        delegate?.chatAvailabilityViewDidTapChatNowButton(self)
    }

    @objc private func handleBookingButtonTap() {
        delegate?.chatAvailabilityViewDidTapBookingButton(self)
    }
}

// MARK: - StatusView

private class StatusView: UIView {

    // MARK: - Private properties

    private lazy var statusLabel = Label(style: .detail, withAutoLayout: true)
    private lazy var loadingIndicator = LoadingIndicatorView(withAutoLayout: true)
    private lazy var stackView = UIStackView(axis: .horizontal, spacing: .spacingS, withAutoLayout: true)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        stackView.addArrangedSubviews([loadingIndicator, statusLabel])
        addSubview(stackView)
        stackView.fillInSuperview()

        NSLayoutConstraint.activate([
            loadingIndicator.widthAnchor.constraint(equalToConstant: .spacingM),
            loadingIndicator.heightAnchor.constraint(equalToConstant: .spacingM)
        ])
    }

    // MARK: - Public methods

    public func configure(status: ChatAvailabilityView.Status, statusTitle: String? = nil) {
        statusLabel.text = statusTitle
        statusLabel.isHidden = statusTitle?.isEmpty ?? true

        switch status {
        case .loading:
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
        default:
            loadingIndicator.isHidden = true
            loadingIndicator.stopAnimating()
        }

        switch status {
        case .online:
            statusLabel.textColor = .online
        case .offline, .unknown:
            statusLabel.textColor = .textCritical
        case .loading:
            statusLabel.textColor = .textSecondary
        }
    }
}

// MARK: - Private extensions

private extension UIColor {
    static var online = dynamicColorIfAvailable(defaultColor: .lime, darkModeColor: .pea)
}
