//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class DescriptionView: UIView {
    // MARK: - Internal properties

    lazy var titleLabel: UILabel = {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var textView: TextView = {
        let view = TextView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    weak var delegate: TextViewDelegate? {
        didSet {
            textView.delegate = delegate
        }
    }

    var textViewMinimumHeight: CGFloat = 0 {
        didSet {
            textView.minimumHeight = textViewMinimumHeight
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
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),

            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: .spacingM)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
