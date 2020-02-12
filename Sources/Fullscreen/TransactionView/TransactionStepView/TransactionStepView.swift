//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol TransactionStepViewDelegate: AnyObject {
    func transactionStepViewDidSelectActionButton(_ view: TransactionStepView, inTransactionStep step: Int)
}

public final class TransactionStepView: UIView {
    public weak var delegate: TransactionStepViewDelegate?
    public private(set) var style: TransactionStepView.Style

    private var model: TransactionStepViewModel

    // MARK: - Subviews

    private lazy var containerView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = style.backgroundColor
        view.layer.cornerRadius = 8
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = Label(style: style.titleStyle)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textPrimary
        return label
    }()

    private lazy var detailLabel: UILabel = {
        let label = Label(style: style.detailStyle)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()

    private lazy var actionButton: UIButton = {
        let button = Button(style: style.actionButtonStyle, size: style.actionButtonSize)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = style.actionButtonIsEnabled
        button.addTarget(self, action: #selector(handlePrimaryButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var infoLabel: UILabel = {
        let label = Label(style: style.detailStyle)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textPrimary
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()

    private var bottomAnchorConstraint: NSLayoutConstraint?

    // MARK: - Init

    public init(model: TransactionStepViewModel, style: TransactionStepView.Style, withAutoLayout autoLayout: Bool = false) {
        self.model = model
        self.style = style

        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        translatesAutoresizingMaskIntoConstraints = !autoLayout
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(containerView)
        titleLabel.text = model.title
        containerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.mediumLargeSpacing),
            containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .mediumSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: .mediumSpacing),
            titleLabel.heightAnchor.constraint(equalToConstant: .mediumLargeSpacing)
        ])

        setupOptionalViews()
    }

    private func setupOptionalViews() {
        var constraints: [NSLayoutConstraint] = []

        if let detailText = model.detail {
            detailLabel.text = detailText
            containerView.addSubview(detailLabel)

            constraints.append(contentsOf: [
                detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                detailLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            ])

            bottomAnchorConstraint = bottomAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: .mediumSpacing)
        }

        if let buttonText = model.buttonText {
            actionButton.setTitle(buttonText, for: .normal)
            containerView.addSubview(actionButton)

            constraints.append(contentsOf: [
                actionButton.leadingAnchor.constraint(equalTo: detailLabel.leadingAnchor),
                actionButton.topAnchor.constraint(equalTo: detailLabel.bottomAnchor),
            ])

            bottomAnchorConstraint = bottomAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: .mediumSpacing)
        }

        if let infoText = model.infoText {
            infoLabel.text = infoText
            containerView.addSubview(infoLabel)

            constraints.append(contentsOf: [
                infoLabel.leadingAnchor.constraint(equalTo: actionButton.leadingAnchor),
                infoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                infoLabel.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: .mediumSpacing),
            ])

            bottomAnchorConstraint = bottomAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: .mediumSpacing)
        }

        constraints.append(bottomAnchorConstraint!)
        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Actions

    @objc private func handlePrimaryButtonTap() {
        delegate?.transactionStepViewDidSelectActionButton(self, inTransactionStep: model.transactionStep)
    }
}
