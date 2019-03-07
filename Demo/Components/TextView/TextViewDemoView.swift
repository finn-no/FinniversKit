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
        addSubview(textView)
        addSubview(scrollableTextView)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            scrollableTextView.topAnchor.constraint(equalTo: centerYAnchor),
            scrollableTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            scrollableTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            scrollableTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing)
        ])
    }
}
