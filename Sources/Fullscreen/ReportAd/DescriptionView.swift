//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class DescriptionView: UIView {

    // MARK: - Internal properties

    private lazy var titleLabel: UILabel = {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var textView: TextView = {
        let view = TextView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    var placeholderText: String? {
        didSet {
            textView.placeholderText = placeholderText
        }
    }

    weak var delegate: UITextViewDelegate? {
        didSet {
            textView.delegate = delegate
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(textView)

        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: .mediumLargeSpacing),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),

            textView.leftAnchor.constraint(equalTo: leftAnchor, constant: .mediumLargeSpacing),
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumLargeSpacing),
            textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -.mediumLargeSpacing),

            bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: .mediumLargeSpacing),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
