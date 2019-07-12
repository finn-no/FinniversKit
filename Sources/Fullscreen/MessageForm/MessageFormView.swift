//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

protocol MessageFormViewDelegate: AnyObject {
    func messageFormView(_ view: MessageFormView, didEditMessageText text: String)
}

class MessageFormView: UIView {

    // MARK: - UI properties

    private lazy var textView: TextView = {
        let textView = TextView(withAutoLayout: true)
        textView.delegate = self
        return textView
    }()

    private lazy var transparencyLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = viewModel.transparencyText
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    // MARK: - Internal properties

    weak var delegate: MessageFormViewDelegate?

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

    // MARK: - Private properties

    private let viewModel: MessageFormViewModel

    // MARK: - Init

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    required init(viewModel: MessageFormViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        addSubview(textView)
        addSubview(transparencyLabel)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            textView.bottomAnchor.constraint(equalTo: transparencyLabel.topAnchor, constant: -.mediumSpacing),

            transparencyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            transparencyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            transparencyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing)
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

extension MessageFormView: TextViewDelegate {
    func textViewDidChange(_ textView: TextView) {
        delegate?.messageFormView(self, didEditMessageText: text)
    }
}
