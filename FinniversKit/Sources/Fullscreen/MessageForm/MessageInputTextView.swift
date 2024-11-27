import Foundation
import Warp

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

    private var additionalInfoLabel = UIView()

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

        disclaimerLabel.text = disclaimerText
        textViewLabel.text = messageLabel
        textView.placeholderText = messageHint
        phoneViewLabel.text = telephoneLabel
        phoneView.placeholderText = telephoneHint
        additionalInfoLabel = setupAdditionalInfoLabel(additionalInfoText)

        setup()
    }

    private func setup() {
        addSubview(textViewLabel)
        addSubview(textView)
        addSubview(disclaimerLabel)
        addSubview(phoneViewLabel)
        addSubview(phoneView)
        addSubview(additionalInfoLabel)

        NSLayoutConstraint.activate([
            textViewLabel.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing200),
            textViewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            textViewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200),
            textViewLabel.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -Warp.Spacing.spacing100),

            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200),
            textView.bottomAnchor.constraint(equalTo: disclaimerLabel.topAnchor, constant: -Warp.Spacing.spacing100),

            disclaimerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            disclaimerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200),
            disclaimerLabel.bottomAnchor.constraint(equalTo: phoneViewLabel.topAnchor, constant: -Warp.Spacing.spacing200),

            phoneViewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            phoneViewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200),
            phoneViewLabel.bottomAnchor.constraint(equalTo: phoneView.topAnchor, constant: -Warp.Spacing.spacing100),

            phoneView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            phoneView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200),
            phoneView.bottomAnchor.constraint(equalTo: additionalInfoLabel.topAnchor, constant: -Warp.Spacing.spacing100),

            additionalInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            additionalInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200),
            additionalInfoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Warp.Spacing.spacing100)
        ])
    }

    private func setupAdditionalInfoLabel(_ html: String) -> UIView {
        let htmlView = HTMLText(html)
            .font(from: .detail)
            .frame(maxWidth: .infinity, alignment: .leading)
            .uiView

        htmlView.translatesAutoresizingMaskIntoConstraints = false

        return htmlView
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
