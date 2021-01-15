//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public protocol ChatAvailabilityViewDelegate: AnyObject {
    func chatAvailabilityViewDidTapCallToActionButton(_ view: ChatAvailabilityView)
    func chatAvailabilityViewDidTapBookTimeButton(_ view: ChatAvailabilityView)
}

public class ChatAvailabilityView: UIView {

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

    private lazy var callToActionButton: Button = {
        let button = Button(style: .callToAction, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleChatNowButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var bookTimeTitleLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var bookTimeButton: Button = {
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
        bookingStackView.addArrangedSubviews([bookTimeTitleLabel, bookTimeButton])
        stackView.addArrangedSubviews([titleLabel, textLabel, callToActionButton, statusView, bookingStackView])

        stackView.setCustomSpacing(.spacingM, after: textLabel)
        stackView.setCustomSpacing(.spacingM, after: statusView)
        stackView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(with viewModel: ChatAvailabilityViewModel) {
        titleLabel.text = viewModel.title
        textLabel.text = viewModel.text
        callToActionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        callToActionButton.isEnabled = viewModel.isActionButtonEnabled
        statusView.configure(isLoading: viewModel.isLoading, statusTitle: viewModel.statusTitle)

        if let bookTimeTitle = viewModel.bookTimeTitle, let bookTimeButtonTitle = viewModel.bookTimeButtonTitle {
            bookTimeTitleLabel.text = bookTimeTitle
            bookTimeButton.setTitle(bookTimeButtonTitle, for: .normal)
            bookingStackView.isHidden = false
        } else {
            bookingStackView.isHidden = true
        }
    }

    // MARK: - Actions

    @objc private func handleChatNowButtonTap() {
        delegate?.chatAvailabilityViewDidTapCallToActionButton(self)
    }

    @objc private func handleBookingButtonTap() {
        delegate?.chatAvailabilityViewDidTapBookTimeButton(self)
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

    public func configure(isLoading: Bool, statusTitle: String? = nil) {
        statusLabel.textColor = isLoading ? .textSecondary : .online
        statusLabel.text = statusTitle
        statusLabel.isHidden = statusTitle?.isEmpty ?? true

        if isLoading {
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.isHidden = true
            loadingIndicator.stopAnimating()
        }
    }
}

// MARK: - Private extensions

private extension UIColor {
    static var online = dynamicColorIfAvailable(defaultColor: .lime, darkModeColor: .pea)
}
