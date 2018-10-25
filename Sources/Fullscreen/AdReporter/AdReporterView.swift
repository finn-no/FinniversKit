//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol AdReporterDelegate: RadioButtonDelegate {
    func adReporterViewHelpButtonPressed(_ adReporterView: AdReporterView)
}

public class AdReporterView: UIScrollView {
    // MARK: - Private properties

    private lazy var radioButton: RadioButton = {
        let radioButton = RadioButton(frame: .zero)
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        return radioButton
    }()

    private lazy var hairlineView: UIView = {
        let line = UIView(frame: .zero)
        line.backgroundColor = .sardine
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()

    private lazy var descriptionView: DescriptionView = {
        let descriptionView = DescriptionView(frame: .zero)
        descriptionView.delegate = self
        descriptionView.textViewMinimumHeight = 147
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        return descriptionView
    }()

    private lazy var helpButton: Button = {
        let button = Button(style: .link)
        button.addTarget(self, action: #selector(helpButtonPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    public lazy var contentView: UIView = {
        let content = UIView(frame: .zero)
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()

    private var textViewShouldGrow = false

    // MARK: - Public properties

    public var model: AdReporterViewModel? {
        didSet {
            guard let model = model else { return }
            radioButton.title = model.radioButtonTitle
            radioButton.fields = model.radioButtonFields
            descriptionView.titleLabel.text = model.descriptionViewTitle
            descriptionView.textView.placeholderText = model.descriptionViewPlaceholderText
            helpButton.setTitle(model.helpButtonText, for: .normal)
        }
    }

    public var message: String {
        return descriptionView.textView.text
    }

    public weak var reporterDelegate: AdReporterDelegate? {
        didSet {
            radioButton.delegate = reporterDelegate
        }
    }

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        contentView.addSubview(radioButton)
        contentView.addSubview(hairlineView)
        contentView.addSubview(descriptionView)
        contentView.addSubview(helpButton)
        addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor),

            radioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            radioButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            radioButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            hairlineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            hairlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            hairlineView.topAnchor.constraint(equalTo: radioButton.bottomAnchor),
            hairlineView.heightAnchor.constraint(equalToConstant: 1),

            descriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionView.topAnchor.constraint(equalTo: hairlineView.bottomAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            helpButton.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: .mediumLargeSpacing),
            helpButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            helpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumLargeSpacing)
        ])
    }

    // MARK: - Actions

    @objc func helpButtonPressed(sender: UIButton) {
        endEditing(true)
        reporterDelegate?.adReporterViewHelpButtonPressed(self)
    }
}

// MARK: -

extension AdReporterView: UITextViewDelegate {
    // MARK: TextView Delegate

    public func textViewDidChange(_ textView: UITextView) {
        let deltaHeight = textView.intrinsicContentSize.height - textView.frame.height

        if deltaHeight > 0 {
            textViewShouldGrow = true
            contentOffset.y += deltaHeight

        } else if deltaHeight < 0, textViewShouldGrow {
            if textView.intrinsicContentSize.height < descriptionView.textViewMinimumHeight {
                textViewShouldGrow = false
                contentOffset.y += descriptionView.textViewMinimumHeight - textView.frame.height
                return
            }
            contentOffset.y += deltaHeight
        }
    }
}
