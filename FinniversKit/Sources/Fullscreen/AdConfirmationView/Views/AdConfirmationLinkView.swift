//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public protocol AdConfirmationLinkViewDelegate: AnyObject {
    func adConfirmationLinkView(_ view: AdConfirmationLinkView, buttonWasTapped sender: UIButton)
}

public class AdConfirmationLinkView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = model.title
        label.font = .bodyStrong
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .body
        label.text = model.descriptionText
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var linkButton: Button = {
        let button = Button(style: .default)
        button.setTitle(model.linkTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
        return button
    }()

    private var model: AdConfirmationLinkViewModel
    private weak var delegate: AdConfirmationLinkViewDelegate?

    init(model: AdConfirmationLinkViewModel, delegate: AdConfirmationLinkViewDelegate?) {
        self.model = model
        self.delegate = delegate

        super.init(frame: .zero)
         translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let maxWidth: CGFloat = 640 - .spacingXL

        addSubview(linkButton)
        NSLayoutConstraint.activate([
            linkButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            linkButton.heightAnchor.constraint(equalToConstant: 44),
            bottomAnchor.constraint(equalTo: linkButton.bottomAnchor)
        ])

        if model.title != nil {
            addSubview(titleLabel)
                NSLayoutConstraint.activate([
                    titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                    titleLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -.spacingXL),
                    titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth),
                ])
        }

        if model.descriptionText != nil {
            addSubview(descriptionLabel)
             NSLayoutConstraint.activate([
                 descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                 descriptionLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -.spacingXL),
                 descriptionLabel.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth),
             ])
        }

        // TitleLabels bottomAnchor & descriptionLabel's topAnchor depends on which views are present
        if subviews.contains(titleLabel) && subviews.contains(descriptionLabel) {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingXS),
                linkButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: .spacingM)
            ])
        } else if subviews.contains(titleLabel) {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                linkButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM)
            ])
        } else if subviews.contains(descriptionLabel) {
            NSLayoutConstraint.activate([
                descriptionLabel.topAnchor.constraint(equalTo: topAnchor),
                linkButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: .spacingM)
            ])
        }
    }

    @objc private func buttonWasTapped(_ sender: Button) {
        delegate?.adConfirmationLinkView(self, buttonWasTapped: sender)
    }
}
