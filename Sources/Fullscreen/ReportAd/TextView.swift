//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class TextView: UIView {

    // MARK: - Internal properties

    lazy var textView: UITextView = {
        let view = UITextView(frame: .zero, textContainer: nil)
        view.font = .body
        view.textColor = .licorice
        view.backgroundColor = .ice
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var underLine: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .secondaryBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var placeholderLabel: UILabel = {
        let label = Label(style: .body(.stone))
        label.textColor = .sardine
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Public properties

    public var placeholderText: String? {
        didSet {
            placeholderLabel.text = placeholderText
        }
    }

    weak var delegate: UITextViewDelegate?

    @discardableResult
    public override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }

    // MARK: - Setup

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        textView.addSubview(placeholderLabel)
        addSubview(textView)
        addSubview(underLine)

        NSLayoutConstraint.activate([
            // Added 5 pts to align it with the text of the text view
            placeholderLabel.leftAnchor.constraint(equalTo: textView.leftAnchor, constant: textView.textContainerInset.left + 5),
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: textView.textContainerInset.top),

            textView.leftAnchor.constraint(equalTo: leftAnchor),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.rightAnchor.constraint(equalTo: rightAnchor),
            textView.bottomAnchor.constraint(equalTo: underLine.topAnchor),

            underLine.leftAnchor.constraint(equalTo: leftAnchor),
            underLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            underLine.rightAnchor.constraint(equalTo: rightAnchor),
            underLine.heightAnchor.constraint(equalToConstant: 2),
        ])
    }
}

// MARK: - TextView Delegate

extension TextView: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textViewDidBeginEditing?(textView)
    }

    public func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewDidChange?(textView)

        if textView.text.isEmpty {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.textViewDidEndEditing?(textView)
    }
}
