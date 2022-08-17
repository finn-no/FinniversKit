//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

public protocol ConfirmationViewDelegate: AnyObject {
    func confirmationViewDidPressDismissButton(_ confirmationView: ConfirmationView)
}

public class ConfirmationView: UIView {
    // MARK: - Private properties

    private lazy var titleLabel: Label = {
        let label = Label(style: .title2, withAutoLayout: true)
        return label
    }()

    private lazy var messageLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var closeButton: Button = {
        let button = Button(style: .flat, withAutoLayout: true)
        return button
    }()

    // MARK: - Public properties

    public var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }

    public var message: String? {
        get { return messageLabel.text }
        set { messageLabel.text = newValue }
    }

    public var buttonTitle: String? {
        get { return closeButton.titleLabel?.text }
        set { closeButton.setTitle(newValue, for: .normal) }
    }

    public weak var delegate: ConfirmationViewDelegate?

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .bgPrimary

        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)
        view.addSubview(closeButton)
        addSubview(view)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),

            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM),
            messageLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),

            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: .spacingXL),

            view.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            view.bottomAnchor.constraint(equalTo: closeButton.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXL),
            view.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        closeButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func buttonPressed() {
        delegate?.confirmationViewDidPressDismissButton(self)
    }
}
