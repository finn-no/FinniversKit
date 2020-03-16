//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol TransactionStepViewDelegate: AnyObject {
    func transactionStepViewDidTapActionButton(_ view: TransactionStepView, inTransactionStep step: Int,
                                               withAction action: TransactionStepView.ActionButton.Action, withUrl urlString: String?,
                                               withFallbackUrl fallbackUrlString: String?)
}

public enum TransactionStepViewState: String {
    case notStarted = "not_started"
    case active = "active"
    case completed = "completed"

    public init(rawValue: String) {
        switch rawValue {
        case "not_started":
            self = .notStarted
        case "active":
            self = .active
        case "completed":
            self = .completed
        default:
            fatalError("No state exists for rawValue: '\(rawValue)'")
        }
    }

    public var style: TransactionStepView.Style {
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

    private enum ButtonTag: Int {
        case primary = 1
        case secondary = 2
    }

    private var step: Int
    private var model: TransactionStepViewModel
    private var primaryButtonModel: TransactionStepActionButtonViewModel?
    private var secondaryButtonModel: TransactionStepActionButtonViewModel?

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
        view.contentInset = .init(top: -.spacingS, leading: 0, bottom: 0, trailing: 0)
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
        view.contentInset = .init(top: -.spacingS, leading: 0, bottom: 0, trailing: 0)
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

    public init(step: Int, model: TransactionStepViewModel, withAutoLayout autoLayout: Bool = false) {
        self.step = step
        self.model = model
        self.primaryButtonModel = model.primaryButton ?? nil
        self.secondaryButtonModel = model.secondaryButton ?? nil
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

        verticalStackViewTopAnchor?.constant = .spacingM
        verticalStackViewLeadingAnchor?.constant = .spacingM
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
            verticalStackViewLeadingAnchor = verticalStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingXS)
            verticalStackViewTrailingAnchor = verticalStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingS)
            verticalStackViewTopAnchor = verticalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)

            NSLayoutConstraint.activate([
                verticalStackViewLeadingAnchor!,
                verticalStackViewTrailingAnchor!,
                verticalStackViewTopAnchor!,
            ])

        case .active:
            verticalStackViewLeadingAnchor = verticalStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM)
            verticalStackViewTrailingAnchor = verticalStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingS)
            verticalStackViewTopAnchor = verticalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingM)

            NSLayoutConstraint.activate([
                verticalStackViewLeadingAnchor!,
                verticalStackViewTrailingAnchor!,
                verticalStackViewTopAnchor!,
            ])
        }

        setupOptionalViews()
    }

    private func setupOptionalViews() {
        if let bodyText = model.body {
            bodyView.attributedText = bodyText

            verticalStackView.addArrangedSubview(bodyView)
            bottomAnchorConstraint = bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: .spacingM)
        }

        setupOptionalButton(model.secondaryButton, tag: ButtonTag.secondary.rawValue)
        setupOptionalButton(model.primaryButton, tag: ButtonTag.primary.rawValue)

        if let detailText = model.detail {
            detailView.text = detailText

            verticalStackView.addArrangedSubview(detailView)
            bottomAnchorConstraint = bottomAnchor.constraint(equalTo: detailView.bottomAnchor, constant: .spacingM)
        }

        bottomAnchorConstraint?.isActive = true
    }

    func setupOptionalButton(_ buttonModel: TransactionStepActionButtonViewModel?, tag: Int) {
        if let buttonModel = buttonModel {
            let buttonText = buttonModel.text
            let buttonStyle = TransactionStepView.ActionButton(rawValue: buttonModel.style).style

            let button = Button(style: buttonStyle, withAutoLayout: true)
            button.setTitle(buttonText, for: .normal)
            button.isEnabled = style.actionButtonEnabled
            button.tag = tag
            button.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
            button.setContentHuggingPriority(.required, for: .vertical)

            if model.state == .completed {
                button.contentHorizontalAlignment = .leading
                button.contentEdgeInsets = .leadingInset(4)
            }

            verticalStackView.addArrangedSubview(button)
            verticalStackView.setCustomSpacing(.spacingM, after: button)

            bottomAnchorConstraint = bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: .spacingM)
        }
    }
}

// MARK: - Selectors

private extension TransactionStepView {
    @objc func handleButtonTap(_ sender: Button) {
        var model: TransactionStepActionButtonViewModel?

        switch sender.tag {
        case ButtonTag.primary.rawValue:
            model = primaryButtonModel
        case ButtonTag.secondary.rawValue:
            model = secondaryButtonModel
        default:
            model = nil
        }

        let action = ActionButton.Action(rawValue: model?.action ?? "unknown")
        let urlString = model?.url
        let fallbackUrlString = model?.fallbackUrl

        delegate?.transactionStepViewDidTapActionButton(self, inTransactionStep: step, withAction: action,
                                                         withUrl: urlString, withFallbackUrl: fallbackUrlString)
    }
}
