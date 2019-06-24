//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

class MessageFormView: UIView {

    // MARK: - UI properties

    private lazy var textView: TextView = {
        let textView = TextView(withAutoLayout: true)
        return textView
    }()

    private lazy var transparencyLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var transparencyLabelHeightConstraint = transparencyLabel.heightAnchor.constraint(equalToConstant: 0)

    // MARK: - Init

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        addSubview(textView)
        addSubview(transparencyLabel)

        // Adding a low-priority "infinite" height constraint to the TextView
        // makes sure it gets chosen to fill the available vertical space.
        let textViewHeightConstraint = textView.heightAnchor.constraint(lessThanOrEqualToConstant: 3000)
        textViewHeightConstraint.priority = .defaultLow

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            textView.bottomAnchor.constraint(equalTo: transparencyLabel.topAnchor, constant: -.mediumSpacing),
            textViewHeightConstraint,

            transparencyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            transparencyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            transparencyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing),
            transparencyLabelHeightConstraint
        ])

        TEMPORARY_SETUP()
    }

    private func TEMPORARY_SETUP() {
        transparencyLabel.text = "FINN.no forebeholder seg retten til å kontrollere meldinger og stoppe useriøs e-post."
    }

    // MARK: - Overrides

    public override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        if let text = transparencyLabel.text {
            let width = transparencyLabel.frame.width
            let height = text.height(withConstrainedWidth: width, font: transparencyLabel.font)
            transparencyLabelHeightConstraint.constant = height
        }
    }
}
