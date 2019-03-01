//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol TextViewDelegate: UITextViewDelegate {
    func textViewDidChange(_ textView: TextView)
}

public class TextView: UIView {
    // MARK: - Internal properties

    private lazy var textView: UITextView = {
        let view = UITextView(frame: .zero, textContainer: nil)
        view.font = .body
        view.textColor = .licorice
        view.backgroundColor = .ice
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.isScrollEnabled = false
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var underLine: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .secondaryBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var placeholderLabel: UILabel = {
        let label = Label(style: .body)
        label.textColor = .sardine
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var textViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Public properties

    public override var intrinsicContentSize: CGSize {
        return textView.intrinsicContentSize
    }

    public var text: String! {
        get { return textView.text }
        set { textView.text = newValue }
    }

    public var placeholderText: String? {
        didSet {
            placeholderLabel.text = placeholderText
        }
    }

    public var minimumHeight: CGFloat = 0 {
        didSet {
            textViewHeightConstraint.constant = minimumHeight
        }
    }

    public weak var delegate: UITextViewDelegate?

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

        textViewHeightConstraint = textView.heightAnchor.constraint(greaterThanOrEqualToConstant: minimumHeight)

        NSLayoutConstraint.activate([
            // Added 5 pts to align it with the text of the text view
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: textView.textContainerInset.left + 5),
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: textView.textContainerInset.top),
            placeholderLabel.widthAnchor.constraint(lessThanOrEqualTo: textView.widthAnchor,
                                                    multiplier: 1.0,
                                                    constant: textView.textContainerInset.left + textView.textContainerInset.right - 10),

            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textViewHeightConstraint,

            underLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            underLine.topAnchor.constraint(equalTo: textView.bottomAnchor),
            underLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            underLine.heightAnchor.constraint(equalToConstant: 2),

            bottomAnchor.constraint(equalTo: underLine.bottomAnchor)
        ])
    }
}

// MARK: - UITextView Delegate

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
