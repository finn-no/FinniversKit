//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class TextViewDemoView: UIView {

    // MARK: - Private properties

    private lazy var textView: TextView = {
        let textView = TextView(withAutoLayout: true)
        textView.placeholderText = "Non-scrollable TextView"
        return textView
    }()

    private lazy var scrollableTextView: TextView = {
        let textView = TextView(withAutoLayout: true)
        textView.placeholderText = "Scrollable TextView"
        textView.isScrollEnabled = true
        return textView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        textView.delegate = self
        addSubview(textView)
        addSubview(scrollableTextView)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingS),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            scrollableTextView.topAnchor.constraint(equalTo: centerYAnchor),
            scrollableTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            scrollableTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            scrollableTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingS)
        ])
    }

// MARK: - TextViewDelegate

extension TextViewDemoView: TextViewDelegate {
    public func textViewDidChange(_ textView: TextView) {
    }

    public func textViewShouldBeginEditing(_ textView: TextView) -> Bool {
        true
    }

    public func textViewDidBeginEditing(_ textView: TextView) {
    }

    public func textViewDidEndEditing(_ textView: TextView) {
    }

    public func textView(_ textView: TextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        true
    }
}
