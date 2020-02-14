//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol TransactionStepViewDelegate: AnyObject {
    func transactionStepViewDidSelectActionButton(_ view: TransactionStepView, inTransactionStep step: Int)
}

public class TransactionStepView: UIView {
    // MARK: - Public properties

    public weak var delegate: TransactionStepViewDelegate?

    // MARK: - Private properties

    private var step: Int
    private var model: TransactionStepViewModel
    private var style: TransactionStepView.Style

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = .mediumSpacing
        return stackView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: style.titleStyle, withAutoLayout: true)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: style.subtitleStyle, withAutoLayout: true)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private lazy var actionButton: Button = {
        let button = Button(style: style.actionButtonStyle, size: style.actionButtonSize, withAutoLayout: true)
        button.isEnabled = style.actionButtonIsEnabled
        button.addTarget(self, action: #selector(handlePrimaryButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var detailLabel: Label = {
        let label = Label(style: style.detailStyle, withAutoLayout: true)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private var bottomAnchorConstraint: NSLayoutConstraint?

    // MARK: - Init

    public init(step: Int, model: TransactionStepViewModel, style: TransactionStepView.Style, withAutoLayout autoLayout: Bool = false) {
        self.step = step
        self.model = model
        self.style = style

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = !autoLayout
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension TransactionStepView {
    func configure(model: TransactionStepViewModel, style: TransactionStepView.Style) {
        self.model = model
        self.style = style
    }
}

// MARK: - Private

private extension TransactionStepView {
    private func setup() {
        backgroundColor = style.backgroundColor
        layer.cornerRadius = .mediumSpacing

        addSubview(verticalStackView)

        titleLabel.text = model.title
        verticalStackView.addArrangedSubview(titleLabel)

        switch style {
        case .notStarted, .completed:
            NSLayoutConstraint.activate([
                verticalStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                verticalStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.mediumSpacing),
                verticalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            ])
        case .inProgressAwaitingOtherParty, .inProgress:
            NSLayoutConstraint.activate([
                verticalStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .mediumLargeSpacing),
                verticalStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.mediumSpacing),
                verticalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .mediumLargeSpacing),
            ])
        }

        setupOptionalViews()
    }

    private func setupOptionalViews() {
        if let subtitleText = model.subtitle {
            subtitleLabel.text = subtitleText
            verticalStackView.addArrangedSubview(subtitleLabel)

            subtitleLabel.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor).isActive = true
            bottomAnchorConstraint = bottomAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: .mediumLargeSpacing)
        }

        if let buttonText = model.buttonText {
            actionButton.setTitle(buttonText, for: .normal)
            verticalStackView.addArrangedSubview(actionButton)

            bottomAnchorConstraint = bottomAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: .mediumLargeSpacing)
        }

        if let detailText = model.detail {
            detailLabel.text = detailText
            verticalStackView.addArrangedSubview(detailLabel)

            detailLabel.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor).isActive = true
            bottomAnchorConstraint = bottomAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: .mediumLargeSpacing)
        }

        bottomAnchorConstraint?.isActive = true
    }
}

// MARK: - Selectors

private extension TransactionStepView {
    @objc func handlePrimaryButtonTap() {
        delegate?.transactionStepViewDidSelectActionButton(self, inTransactionStep: step)
    }
}
