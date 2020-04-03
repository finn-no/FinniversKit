//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class ChatAvailabilityView: UIView {
    public enum Status: CaseIterable {
        case loading
        case online
        case offline
        case unknown
    }

    // MARK: - Private properties

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = .spacingM
        return stackView
    }()

    private lazy var chatNowButton: Button = {
        let button = Button(style: .callToAction, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        button.setTitle("Chat med oss", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(leading: .spacingS)
        button.imageEdgeInsets = UIEdgeInsets(top: .spacingXS, leading: -.spacingS)
        button.adjustsImageWhenHighlighted = false
        let image = UIImage(named: .videoChat)
        button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
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
        stackView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(status: Status) {

    }

    // MARK: - Private methods

    @objc private func handleButtonTap() {

    }
}

// MARK: - StatusView

private class StatusView: UIView {

    // MARK: - Private properties

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.spacing = .spacingM
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
        addSubview(stackView)
        stackView.fillInSuperview()
    }
}
