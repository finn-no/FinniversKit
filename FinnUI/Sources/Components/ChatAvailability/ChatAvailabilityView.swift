//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public protocol ChatAvailabilityViewDelegate: AnyObject {
    func chatAvailabilityViewDidTapChatNowButton(_ view: ChatAvailabilityView)
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

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = .spacingS
        return stackView
    }()

    private lazy var chatNowButton: Button = {
        let button = Button(style: .callToAction, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(leading: .spacingS)
        button.imageEdgeInsets = UIEdgeInsets(top: .spacingXS, leading: -.spacingS)
        let image = UIImage(named: .videoChat)
        button.setImage(image.withRenderingMode(.alwaysTemplate))
        button.imageView?.tintColor = .milk
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
        stackView.addArrangedSubview(chatNowButton)
        stackView.addArrangedSubview(statusView)
        stackView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(buttonTitle: String?) {
        chatNowButton.setTitle(buttonTitle, for: .normal)
    }

    public func configure(status: Status, statusTitle: String? = nil) {
        switch status {
        case .online, .unknown:
            chatNowButton.isEnabled = true
        case .loading, .offline:
            chatNowButton.isEnabled = false
        }

        statusView.configure(status: status, statusTitle: statusTitle)
    }

    // MARK: - Private methods

    @objc private func handleButtonTap() {
        delegate?.chatAvailabilityViewDidTapChatNowButton(self)
    }
}

// MARK: - StatusView

private class StatusView: UIView {

    // MARK: - Private properties

    private lazy var statusLabel = Label(style: .detail, withAutoLayout: true)
    private lazy var loadingIndicator = LoadingIndicatorView(withAutoLayout: true)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.spacing = .spacingS
        return stackView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        stackView.addArrangedSubview(loadingIndicator)
        stackView.addArrangedSubview(statusLabel)

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
    static var online = dynamicColorIfAvailable(defaultColor: UIColor(hex: "#32A24C"), darkModeColor: .pea)
}

private extension UIButton {
    func setImage(_ image: UIImage?) {
        let states: [UIControl.State] = [.normal, .highlighted, .disabled, .selected, .focused]
        states.forEach { setImage(image, for: $0) }
    }
}
