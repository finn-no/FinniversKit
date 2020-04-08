//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol TextViewDelegate: AnyObject {
    func textViewDidChange(_ textView: TextView)
    func textViewDidBeginEditing(_ textView: TextView)
    func textViewDidEndEditing(_ textView: TextView)
}

public extension TextViewDelegate {
    func textViewDidChange(_ textView: TextView) {
        // Default empty implementation.
    }
    func textViewDidBeginEditing(_ textView: TextView) {
        // Default empty implementation.
    }
    func textViewDidEndEditing(_ textView: TextView) {
        // Default empty implementation.
    }
}

public class TextView: UIView {

    // MARK: - Public properties

    public weak var delegate: TextViewDelegate?

    public var text: String! {
        get { return textView.text }
        set {
            textView.text = newValue
            updatePlaceholderAppearance()
        }
    }

    public var placeholderText: String? {
        didSet {
            placeholderLabel.text = placeholderText
            updatePlaceholderAppearance()
        }
    }

    public var minimumHeight: CGFloat = 0 {
        didSet {
            textViewHeightConstraint.constant = minimumHeight
        }
    }

    public var isScrollEnabled: Bool {
        get {
            return textView.isScrollEnabled
        }
        set {
            textView.isScrollEnabled = newValue
        }
    }

    public override var intrinsicContentSize: CGSize {
        return textView.intrinsicContentSize
    }

    // MARK: - Private properties

    private lazy var textView: UITextView = {
        let view = UITextView(frame: .zero, textContainer: nil)
        view.font = .body
        view.textColor = .textPrimary
        view.backgroundColor = .bgSecondary
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.isScrollEnabled = false
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontForContentSizeCategory = true

        return view
    }()

    private lazy var underLine: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .accentSecondaryBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var placeholderLabel: UILabel = {
        let label = Label(style: .body)
        label.textColor = .textDisabled
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var textViewHeightConstraint: NSLayoutConstraint!

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
                                                    constant: -(textView.textContainerInset.left + textView.textContainerInset.right + 10)),

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

    private func updatePlaceholderAppearance() {
        if textView.text.isEmpty {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
    }
}

// MARK: - UITextViewDelegate

extension TextView: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textViewDidBeginEditing(self)
    }

    public func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewDidChange(self)
        updatePlaceholderAppearance()
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.textViewDidEndEditing(self)
    }
}

// MARK: - First Responder

extension TextView {
    public override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }

    public override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }

    public override var canBecomeFirstResponder: Bool {
        return textView.canBecomeFirstResponder
    }

    public override var canResignFirstResponder: Bool {
        return textView.canResignFirstResponder
    }
}
