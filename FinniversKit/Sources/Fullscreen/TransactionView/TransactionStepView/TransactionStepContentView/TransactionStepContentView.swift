//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol TransactionStepContentViewDelegate: AnyObject {
    func transactionStepContentViewDidTapActionButton(
        _ view: TransactionStepContentView,
        inTransactionStep step: Int,
        withAction action: TransactionStepContentView.ActionButton.Action,
        withUrl urlString: String?,
        withFallbackUrl fallbackUrlString: String?
    )
}

public class TransactionStepContentView: UIView {

    // MARK: - Public properties

    public weak var delegate: TransactionStepContentViewDelegate?

    // MARK: - Private properties

    private enum ButtonTag: Int {
        case native = 1
        case primary = 2
    }

    private var step: Int
    private var state: TransactionStepViewState
    private var model: TransactionStepContentViewModel

    private var nativeButtonModel: TransactionStepContentActionButtonViewModel?
    private var primaryButtonModel: TransactionStepContentActionButtonViewModel?

    private var verticalStackViewLeadingAnchor: NSLayoutConstraint?
    private var verticalStackViewTrailingAnchor: NSLayoutConstraint?
    private var verticalStackViewTopAnchor: NSLayoutConstraint?

    private var bottomAnchorConstraint: NSLayoutConstraint?

    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(withAutoLayout: true)
        view.backgroundColor = .clear
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        return view
    }()

    private lazy var titleView: UITextView = {
        let view = UITextView(withAutoLayout: true)
        view.backgroundColor = .clear
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
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.isEditable = false
        view.contentInset = .init(top: -.spacingS, leading: 0, bottom: 0, trailing: 0)
        view.adjustsFontForContentSizeCategory = true
        view.textContainer.widthTracksTextView = true
        view.textContainer.heightTracksTextView = true
        return view
    }()

    // MARK: - Init

    public init(
        step: Int,
        state: TransactionStepViewState,
        model: TransactionStepContentViewModel,
        withFontForTitle font: UIFont,
        withColorForTitle textColor: UIColor,
        withAutoLayout autoLayout: Bool = false
    ) {
        self.step = step
        self.state = state
        self.model = model

        self.nativeButtonModel = model.nativeButton ?? nil
        self.primaryButtonModel = model.primaryButton ?? nil

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = !autoLayout

        titleView.font = font
        titleView.textColor = textColor

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension TransactionStepContentView {
    private func setup() {
        backgroundColor = .clear

        addSubview(verticalStackView)

        switch state {
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

        if let titleText = model.title {
            titleView.text = titleText
            verticalStackView.addArrangedSubview(titleView)
        }

        setupBodyView(model.nativeBody, model.body)
        // NativeButton should always precede primaryButton
        setupButton(model.nativeButton, tag: ButtonTag.native)
        setupButton(model.primaryButton, tag: ButtonTag.primary)

        bottomAnchorConstraint?.isActive = true
    }

    private func setupBodyView(_ nativeBody: NSAttributedString?, _ body: NSAttributedString?) {
        let text = nativeBody != nil ? nativeBody : body
        guard text != nil else { return }

        bodyView.attributedText = text
        verticalStackView.addArrangedSubview(bodyView)
        bottomAnchorConstraint = bottomAnchor.constraint(equalTo: bodyView.bottomAnchor)
    }

    private func setupButton(_ buttonModel: TransactionStepContentActionButtonViewModel?, tag: ButtonTag) {
        if let buttonModel = buttonModel {
            let buttonText = buttonModel.text
            let buttonStyle = TransactionStepContentView.ActionButton(rawValue: buttonModel.style).style
            let buttonAction = TransactionStepContentView.ActionButton.Action(rawValue: buttonModel.action ?? "")

            let button = Button(style: buttonStyle, withAutoLayout: true)
            button.setTitle(buttonText, for: .normal)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.tag = tag.rawValue
            button.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
            button.setContentHuggingPriority(.required, for: .vertical)

            verticalStackView.addArrangedSubview(button)
            verticalStackView.setCustomSpacing(.spacingM, after: button)

            switch buttonAction {
            case .seeAd:
                button.contentHorizontalAlignment = .leading
                button.contentEdgeInsets = .leadingInset(.spacingS)
            case .republishAd:
                break
            default:
                addWebViewIconToButton(button)
            }

            switch tag {
            case .native:
                bottomAnchorConstraint = bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: .spacingS)
            case .primary:
                bottomAnchorConstraint = bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: .spacingM)
            }
        }
    }

    private func addWebViewIconToButton(_ button: Button) {
        let image = UIImage(named: .webview).withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = button.titleLabel?.textColor ?? .bgPrimary
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let imageWidth: CGFloat = .spacingM
        var leadingTitleInset = CGFloat.zero
        var trailingAnchorConstant = CGFloat.zero

        if state == .completed {
            button.contentHorizontalAlignment = .leading
            leadingTitleInset = -8
            trailingAnchorConstant = -24
        } else {
            leadingTitleInset = button.titleEdgeInsets.leading + imageWidth - 20
            trailingAnchorConstant = -20
        }

        button.titleEdgeInsets = UIEdgeInsets(
            top: button.titleEdgeInsets.top,
            leading: leadingTitleInset,
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
            imageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: trailingAnchorConstant),

            buttonWidth
        ])
    }
}

// MARK: - Selectors

private extension TransactionStepContentView {
    @objc func handleButtonTap(_ sender: Button) {
        var model: TransactionStepContentActionButtonViewModel?

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

        delegate?.transactionStepContentViewDidTapActionButton(
            self,
            inTransactionStep: step,
            withAction: action,
            withUrl: urlString,
            withFallbackUrl: fallbackUrlString
        )
    }
}
