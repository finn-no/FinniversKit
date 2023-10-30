//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

protocol MessageInputTextViewDelegate: AnyObject {
    func messageFormView(_ view: MessageInputTextView, didEditMessageText text: String)
}

class MessageInputTextView: UIView {

    // MARK: - UI properties

    private lazy var textViewLabel: Label = {
        let label = Label(style: .captionStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    private lazy var textView: TextView = {
        let textView = TextView(withAutoLayout: true)
        textView.delegate = self
        textView.isScrollEnabled = true
        return textView
    }()

    private lazy var disclaimerLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    private lazy var phoneViewLabel: Label = {
        let label = Label(style: .captionStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    private lazy var phoneView: TextView = {
        let textView = TextView(withAutoLayout: true)
        textView.isScrollEnabled = false
        return textView
    }()

    private lazy var additionalInfoLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    // MARK: - Internal properties

    weak var delegate: MessageInputTextViewDelegate?

    var text: String {
        get {
            return textView.text ?? ""
        }
        set {
            textView.text = newValue
            delegate?.messageFormView(self, didEditMessageText: newValue)
        }
    }

    var telephone: String {
        get {
            return phoneView.text ?? ""
        }
        set {
            textView.text = newValue
        }
    }

    var inputEnabled: Bool = true {
        didSet {
            textView.isUserInteractionEnabled = inputEnabled
            if inputEnabled {
                becomeFirstResponder()
            } else {
                resignFirstResponder()
            }
        }
    }

    // MARK: - Init

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    required init(disclaimerText: String, additionalInfoText: String, messageLabel: String, messageHint: String, telephoneLabel: String, telephoneHint: String) {
        super.init(frame: .zero)

        setup()
        disclaimerLabel.text = disclaimerText
        additionalInfoLabel.text = additionalInfoText
        textViewLabel.text = messageLabel
        textView.placeholderText = messageHint
        phoneViewLabel.text = telephoneLabel
        phoneView.placeholderText = telephoneHint
    }

    private func setup() {
        addSubview(textViewLabel)
        addSubview(textView)
        addSubview(disclaimerLabel)
        addSubview(phoneViewLabel)
        addSubview(phoneView)
        addSubview(additionalInfoLabel)

        NSLayoutConstraint.activate([
            textViewLabel.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            textViewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            textViewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            textViewLabel.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -.spacingS),

            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            textView.bottomAnchor.constraint(equalTo: disclaimerLabel.topAnchor, constant: -.spacingS),

            disclaimerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            disclaimerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            disclaimerLabel.bottomAnchor.constraint(equalTo: phoneViewLabel.topAnchor, constant: -.spacingM),

            phoneViewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            phoneViewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            phoneViewLabel.bottomAnchor.constraint(equalTo: phoneView.topAnchor, constant: -.spacingS),

            phoneView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            phoneView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            phoneView.bottomAnchor.constraint(equalTo: additionalInfoLabel.topAnchor, constant: -.spacingS),

            additionalInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            additionalInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            additionalInfoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingS)
        ])
    }

    // MARK: - Overrides

    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }

    @discardableResult
    public override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }
}

extension MessageInputTextView: TextViewDelegate {
    func textViewDidChange(_ textView: TextView) {
        delegate?.messageFormView(self, didEditMessageText: text)
    }
}
