//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit
import Warp

protocol ContactFormCheckboxDelegate: AnyObject {
    func contactFormCheckbox(_ checkbox: ContactFormCheckbox, didChangeSelection isSelected: Bool)
}

final class ContactFormCheckbox: UIView {
    weak var delegate: ContactFormCheckboxDelegate?

    private lazy var questionLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .body
        label.textColor = .text
        label.numberOfLines = 0
        return label
    }()

    private lazy var checkboxView: CheckboxView = {
        let view = CheckboxView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCheckboxTap)))
        return view
    }()

    private lazy var answerLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .body
        label.textColor = .text
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    func configure(question: String, answer: String) {
        questionLabel.text = question
        answerLabel.text = answer
    }

    private func setup() {
        addSubview(questionLabel)
        addSubview(checkboxView)
        addSubview(answerLabel)

        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: topAnchor),
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            checkboxView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: .spacingXS),
            checkboxView.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkboxView.bottomAnchor.constraint(equalTo: bottomAnchor),

            answerLabel.centerYAnchor.constraint(equalTo: checkboxView.centerYAnchor),
            answerLabel.leadingAnchor.constraint(equalTo: checkboxView.trailingAnchor, constant: .spacingXS),
            answerLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    // MARK: - Action

    @objc private func handleCheckboxTap() {
        let isSelected = !checkboxView.isHighlighted

        checkboxView.configure(isSelected: isSelected)
        delegate?.contactFormCheckbox(self, didChangeSelection: isSelected)
    }
}
