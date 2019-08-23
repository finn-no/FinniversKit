//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

protocol MessageInputTextViewDelegate: AnyObject {
    func messageFormView(_ view: MessageInputTextView, didEditMessageText text: String)
}

class MessageInputTextView: UIView {

    // MARK: - UI properties

    private lazy var textView: TextView = {
        let textView = TextView(withAutoLayout: true)
        textView.delegate = self
        textView.isScrollEnabled = true
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

    required init(additionalInfoText: String) {
        super.init(frame: .zero)

        setup()
        additionalInfoLabel.text = additionalInfoText
    }

    private func setup() {
        addSubview(textView)
        addSubview(additionalInfoLabel)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            textView.bottomAnchor.constraint(equalTo: additionalInfoLabel.topAnchor, constant: -.mediumSpacing),

            additionalInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            additionalInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            additionalInfoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing)
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
