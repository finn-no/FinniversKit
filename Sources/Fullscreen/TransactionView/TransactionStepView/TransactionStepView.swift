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
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = style.titleFont
        label.textColor = style.titleTextColor
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private lazy var subtitleLabel: UITextView = {
        let view = UITextView(frame: .zero, textContainer: nil)
        view.font = style.subtitleFont
        view.textColor = style.subtitleTextColor
        view.backgroundColor = style.backgroundColor
        view.isScrollEnabled = false
        view.isEditable = false
        view.contentInset = .leadingInset(-.smallSpacing)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontForContentSizeCategory = true
        return view
    }()

    private lazy var actionButton: Button = {
        let button = Button(style: style.actionButtonStyle, size: style.actionButtonSize, withAutoLayout: true)
        button.isEnabled = style.actionButtonIsEnabled
        button.addTarget(self, action: #selector(handlePrimaryButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var detailLabel: UITextView = {
        let view = UITextView(frame: .zero, textContainer: nil)
        view.font = style.detailFont
        view.textColor = style.detailTextColor
        view.backgroundColor = style.backgroundColor
        view.isScrollEnabled = false
        view.isEditable = false
        view.contentInset = .leadingInset(-.smallSpacing)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontForContentSizeCategory = true
        return view
    }()

    private var bottomAnchorConstraint: NSLayoutConstraint?

    // MARK: - Init

    public init(step: Int, model: TransactionStepViewModel, withAutoLayout autoLayout: Bool = false) {
        self.step = step
        self.model = model
        self.style = model.state.style

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = !autoLayout
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension TransactionStepView {
    private func setup() {
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius

        addSubview(verticalStackView)

        titleLabel.text = model.title
        verticalStackView.addArrangedSubview(titleLabel)

        switch style {
        case .notStarted, .completed:
            NSLayoutConstraint.activate([
                verticalStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .smallSpacing),
                verticalStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.mediumSpacing),
                verticalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            ])

        case .inProgress, .inProgressAwaitingOtherParty:
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

            if model.state == .completed {
                actionButton.contentHorizontalAlignment = .leading
                actionButton.contentEdgeInsets = .leadingInset(-1)
            }

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
