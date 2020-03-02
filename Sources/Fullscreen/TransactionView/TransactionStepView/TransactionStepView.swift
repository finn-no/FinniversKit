//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol TransactionStepViewDelegate: AnyObject {
    func transactionStepViewDidTapPrimaryButton(_ view: TransactionStepView, inTransactionStep step: Int,
                                                withAction action: TransactionStepView.PrimaryButton.Action, withUrl urlString: String?,
                                                withFallbackUrl fallbackUrlString: String?)
}

public enum TransactionStepViewState: String {
    case notStarted = "not_started"
    case active = "active"
    case completed = "completed"

    var style: TransactionStepView.Style {
        switch self {
        case .notStarted:
            return .notStarted
        case .active:
            return .active
        case .completed:
            return .completed
        }
    }
}

public class TransactionStepView: UIView {
    // MARK: - Public properties

    public weak var delegate: TransactionStepViewDelegate?

    // MARK: - Private properties

    private var step: Int
    private var model: TransactionStepViewModel
    private var primaryButtonModel: TransactionStepPrimaryButtonViewModel?

    private var style: TransactionStepView.Style
    private var activeStepColor: UIColor = .bgTertiary

    private var verticalStackViewLeadingAnchor: NSLayoutConstraint?
    private var verticalStackViewTrailingAnchor: NSLayoutConstraint?
    private var verticalStackViewTopAnchor: NSLayoutConstraint?

    private var bottomAnchorConstraint: NSLayoutConstraint?

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var titleView: UITextView = {
        let view = UITextView(withAutoLayout: true)
        view.font = style.titleFont
        view.textColor = style.titleTextColor
        view.backgroundColor = style.backgroundColor
        view.isScrollEnabled = false
        view.isEditable = false
        view.contentInset = .init(top: -.mediumSpacing, leading: 0, bottom: 0, trailing: 0)
        view.adjustsFontForContentSizeCategory = true
        view.textContainer.widthTracksTextView = true
        view.textContainer.heightTracksTextView = true
        return view
    }()

    private lazy var bodyView: UITextView = {
        let view = UITextView(withAutoLayout: true)
        view.font = style.bodyFont
        view.textColor = style.bodyTextColor
        view.backgroundColor = style.backgroundColor
        view.isScrollEnabled = false
        view.isEditable = false
        view.contentInset = .init(top: -.mediumSpacing, leading: 0, bottom: 0, trailing: 0)
        view.adjustsFontForContentSizeCategory = true
        view.textContainer.widthTracksTextView = true
        view.textContainer.heightTracksTextView = true
        return view
    }()

    private lazy var detailView: UITextView = {
        let view = UITextView(withAutoLayout: true)
        view.font = style.detailFont
        view.textColor = style.detailTextColor
        view.backgroundColor = style.backgroundColor
        view.isScrollEnabled = false
        view.isEditable = false
        view.contentInset = .leadingInset(0)
        view.adjustsFontForContentSizeCategory = true
        view.textContainer.widthTracksTextView = true
        view.textContainer.heightTracksTextView = true
        return view
    }()

    // MARK: - Init

    public init(withAutoLayout autoLayout: Bool = false, step: Int, model: TransactionStepViewModel) {
        self.step = step
        self.model = model
        self.primaryButtonModel = model.primaryButton ?? nil
        self.style = model.state.style

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = !autoLayout
        setup()
    }

    public func hasCompletedLastStep(_ isCompleted: Bool) {
        guard isCompleted == true else { return }

        backgroundColor = activeStepColor
        titleView.backgroundColor = activeStepColor
        bodyView.backgroundColor = activeStepColor
        detailView.backgroundColor = activeStepColor

        verticalStackViewTopAnchor?.constant = .mediumLargeSpacing
        verticalStackViewLeadingAnchor?.constant = .mediumLargeSpacing
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

        titleView.text = model.title
        verticalStackView.addArrangedSubview(titleView)

        switch style {
        case .notStarted, .completed:
            verticalStackViewLeadingAnchor = verticalStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .smallSpacing)
            verticalStackViewTrailingAnchor = verticalStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.mediumSpacing)
            verticalStackViewTopAnchor = verticalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)

            NSLayoutConstraint.activate([
                verticalStackViewLeadingAnchor!,
                verticalStackViewTrailingAnchor!,
                verticalStackViewTopAnchor!,

                titleView.heightAnchor.constraint(greaterThanOrEqualToConstant: .mediumPlusSpacing),
            ])

        case .active:
            verticalStackViewLeadingAnchor = verticalStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .mediumLargeSpacing)
            verticalStackViewTrailingAnchor = verticalStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.mediumSpacing)
            verticalStackViewTopAnchor = verticalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .mediumLargeSpacing)

            NSLayoutConstraint.activate([
                verticalStackViewLeadingAnchor!,
                verticalStackViewTrailingAnchor!,
                verticalStackViewTopAnchor!,

                titleView.heightAnchor.constraint(greaterThanOrEqualToConstant: .mediumPlusSpacing),
            ])
        }

        titleView.setContentHuggingPriority(.required, for: .vertical)
        setupOptionalViews()
    }

    private func setupOptionalViews() {
        if let bodyText = model.body {
            bodyView.text = bodyText
            verticalStackView.addArrangedSubview(bodyView)

            bodyView.setContentHuggingPriority(.required, for: .vertical)
            NSLayoutConstraint.activate([bodyView.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor)])

            bottomAnchorConstraint = bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: .mediumPlusSpacing)
        }

        if let buttonModel = primaryButtonModel {
            let buttonText = buttonModel.text
            let buttonStyle = TransactionStepView.PrimaryButton(rawValue: buttonModel.style).style

            let primaryButton = Button(style: buttonStyle, withAutoLayout: true)
            primaryButton.setTitle(buttonText, for: .normal)
            primaryButton.isEnabled = style.actionButtonEnabled
            primaryButton.addTarget(self, action: #selector(handlePrimaryButtonTap), for: .touchUpInside)

            verticalStackView.addArrangedSubview(primaryButton)

            if model.state == .completed {
                primaryButton.contentHorizontalAlignment = .leading
                primaryButton.contentEdgeInsets = .leadingInset(4)
            }

            primaryButton.setContentHuggingPriority(.required, for: .vertical)
            NSLayoutConstraint.activate([primaryButton.heightAnchor.constraint(equalToConstant: 40)])

            bottomAnchorConstraint = bottomAnchor.constraint(equalTo: primaryButton.bottomAnchor, constant: .mediumPlusSpacing)
        }

        if let detailText = model.detail {
            detailView.text = detailText
            verticalStackView.addArrangedSubview(detailView)

            bottomAnchorConstraint = bottomAnchor.constraint(equalTo: detailView.bottomAnchor, constant: .mediumPlusSpacing)
        }

        bottomAnchorConstraint?.isActive = true
    }
}

// MARK: - Selectors

private extension TransactionStepView {
    @objc func handlePrimaryButtonTap() {
        let action = PrimaryButton.Action(rawValue: primaryButtonModel?.action ?? "unknown")
        let urlString = primaryButtonModel?.urlString
        let fallbackUrlString = primaryButtonModel?.fallbackUrlString

        delegate?.transactionStepViewDidTapPrimaryButton(self, inTransactionStep: step, withAction: action,
                                                         withUrl: urlString, withFallbackUrl: fallbackUrlString)
    }
}
