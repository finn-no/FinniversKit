//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol TransactionStepViewDelegate: AnyObject {
    func transactionStepViewDidTapActionButton(
        _ view: TransactionStepView,
        inTransactionStep step: Int,
        withAction action: TransactionStepView.ActionButton.Action,
        withUrl urlString: String?,
        withFallbackUrl fallbackUrlString: String?
    )
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

public enum TransactionStepViewCustomStyle: String {
    case warning
    case error

    public var color: UIColor {
        switch self {
        case .error:
            return .bgCritical
        case .warning:
            return .bgAlert
        }
    }
}

public class TransactionStepView: UIView {
    // MARK: - Public properties

    public weak var delegate: TransactionStepViewDelegate?

    // MARK: - Private properties

    private enum ButtonTag: Int {
        case native = 1
        case primary = 2
    }

    private var step: Int
    private var model: TransactionStepViewModel
    private var nativeButtonModel: TransactionStepActionButtonViewModel?
    private var primaryButtonModel: TransactionStepActionButtonViewModel?

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
        stackView.isLayoutMarginsRelativeArrangement = true
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

    public init(
        step: Int,
        model: TransactionStepViewModel,
        withCustomStyle customStyle: TransactionStepViewCustomStyle? = nil,
        withAutoLayout autoLayout: Bool = false
    ) {
        self.step = step
        self.model = model
        self.nativeButtonModel = model.main?.nativeButton ?? nil
        self.primaryButtonModel = model.main?.primaryButton ?? nil
        self.style = model.state.style

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = !autoLayout
        setup(withCustomStyle: customStyle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension TransactionStepView {
    private func setup(withCustomStyle customStyle: TransactionStepViewCustomStyle?) {
        backgroundColor = customStyle?.color ?? style.backgroundColor
        layer.cornerRadius = style.cornerRadius

        addSubview(verticalStackView)

        titleView.text = model.main?.title
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
        if let bodyText = model.main?.body {
            bodyView.attributedText = bodyText

            verticalStackView.addArrangedSubview(bodyView)
            bottomAnchorConstraint = bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: .spacingM)
        }

        setupOptionalButton(model.main?.nativeButton, tag: ButtonTag.native.rawValue)
        setupOptionalButton(model.main?.primaryButton, tag: ButtonTag.primary.rawValue)

        if let detailText = model.detail?.body {
            detailView.attributedText = detailText

            verticalStackView.addArrangedSubview(detailView)

            detailView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor).isActive = true
            bottomAnchorConstraint = bottomAnchor.constraint(equalTo: detailView.bottomAnchor, constant: .spacingM)
        }

        bottomAnchorConstraint?.isActive = true
    }

    func setupOptionalButton(_ buttonModel: TransactionStepActionButtonViewModel?, tag: Int) {
        if let buttonModel = buttonModel {
            let buttonText = buttonModel.text
            let buttonStyle = TransactionStepView.ActionButton(rawValue: buttonModel.style).style
            let buttonAction = TransactionStepView.ActionButton.Action(rawValue: buttonModel.action ?? "")

            let button = Button(style: buttonStyle, withAutoLayout: true)
            button.setTitle(buttonText, for: .normal)
            button.isEnabled = style.actionButtonEnabled
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.tag = tag
            button.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
            button.setContentHuggingPriority(.required, for: .vertical)

            verticalStackView.addArrangedSubview(button)
            verticalStackView.setCustomSpacing(.spacingM, after: button)

            switch buttonAction {
            case .seeAd:
                button.contentHorizontalAlignment = .leading
                button.contentEdgeInsets = .leadingInset(.spacingS)
            default:
                addWebViewIconToButton(button)
            }

            button.leadingAnchor.constraint(equalTo: titleView.leadingAnchor).isActive = true
            bottomAnchorConstraint = bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: .spacingM)
        }
    }

    func addWebViewIconToButton(_ button: Button) {
        let imageView = UIImageView(image: UIImage(named: .webview))
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let imageWidth: CGFloat = 16
        var leadingInset = CGFloat.zero

        if model.state == .completed {
            button.contentHorizontalAlignment = .leading
            leadingInset = -10
        } else {
            leadingInset = button.titleEdgeInsets.leading + imageWidth - .spacingM
        }

        button.titleEdgeInsets = UIEdgeInsets(
            top: button.titleEdgeInsets.top,
            leading: leadingInset,
            bottom: button.titleEdgeInsets.bottom,
            trailing: button.titleEdgeInsets.trailing + imageWidth + .spacingS
        )

        addSubview(imageView)

        let buttonWidth = button.widthAnchor.constraint(
            greaterThanOrEqualToConstant: button.intrinsicContentSize.width + imageWidth + .spacingS
        )
        buttonWidth.priority = .required

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: imageWidth),
            imageView.heightAnchor.constraint(equalToConstant: imageWidth),
            imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20),

            buttonWidth
        ])
    }
}

// MARK: - Selectors

private extension TransactionStepView {
    @objc func handleButtonTap(_ sender: Button) {
        var model: TransactionStepActionButtonViewModel?

        switch sender.tag {
        case ButtonTag.native.rawValue:
            model = nativeButtonModel
        case ButtonTag.primary.rawValue:
            model = primaryButtonModel
        default:
            model = nil
        }

        let action = ActionButton.Action(rawValue: model?.action ?? "unknown")
        let urlString = model?.url
        let fallbackUrlString = model?.fallbackUrl

        delegate?.transactionStepViewDidTapActionButton(
            self,
            inTransactionStep: step,
            withAction: action,
            withUrl: urlString,
            withFallbackUrl: fallbackUrlString
        )
    }
}
