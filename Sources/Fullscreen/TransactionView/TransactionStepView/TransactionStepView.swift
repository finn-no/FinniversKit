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

    private lazy var containerView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = style.backgroundColor
        view.layer.cornerRadius = .mediumSpacing
        return view
    }()

    private lazy var titleLabel: Label = Label(style: style.titleStyle, withAutoLayout: true)
    private lazy var subtitleLabel: Label = {
        let label = Label(style: style.subtitleStyle, withAutoLayout: true)
        label.numberOfLines = 0
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
        return label
    }()

    private var bottomAnchorConstraint: NSLayoutConstraint?

    // MARK: - Init

    public init(step: Int, model: TransactionStepViewModel, style: TransactionStepView.Style, withAutoLayout autoLayout: Bool = false) {
        self.step = step
        self.model = model
        self.style = style

        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

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
        addSubview(containerView)

        titleLabel.text = model.title
        containerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.largeSpacing),
            containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: .mediumLargeSpacing)
        ])

        switch style {
        case .notStarted, .completed:
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: .smallSpacing)
            ])
        case .inProgressAwaitingOtherParty, .inProgress:
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .mediumLargeSpacing),
                titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            ])
        }

        setupOptionalViews()
    }

    private func setupOptionalViews() {
        var constraints: [NSLayoutConstraint] = []

        if let subtitleText = model.subtitle {
            subtitleLabel.text = subtitleText
            containerView.addSubview(subtitleLabel)

            constraints.append(contentsOf: [
                subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumSpacing),
            ])

            bottomAnchorConstraint = bottomAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: .mediumSpacing)
        }

        if let buttonText = model.buttonText {
            actionButton.setTitle(buttonText, for: .normal)
            containerView.addSubview(actionButton)

            constraints.append(contentsOf: [
                actionButton.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
                actionButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: .mediumSpacing),
            ])

            bottomAnchorConstraint = bottomAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: .mediumSpacing)
        }

        if let detailText = model.detail {
            detailLabel.text = detailText
            containerView.addSubview(detailLabel)

            constraints.append(contentsOf: [
                detailLabel.leadingAnchor.constraint(equalTo: actionButton.leadingAnchor),
                detailLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                detailLabel.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: .mediumSpacing),
            ])

            bottomAnchorConstraint = bottomAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: .mediumSpacing)
        }

        constraints.append(bottomAnchorConstraint!)
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - Selectorss

private extension TransactionStepView {
    @objc func handlePrimaryButtonTap() {
        delegate?.transactionStepViewDidSelectActionButton(self, inTransactionStep: step)
    }
}
