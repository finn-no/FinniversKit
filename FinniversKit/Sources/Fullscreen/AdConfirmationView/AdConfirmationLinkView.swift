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
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.text = model.description
        label.numberOfLines = 0
        return UILabel()
    }()

    private lazy var linkButton: Button = {
        let button = Button(style: .link)
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

        self.translatesAutoresizingMaskIntoConstraints = false
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
            linkButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        if model.title != nil {
            addSubview(titleLabel)
            NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                titleLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: .spacingXL),
                titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth)
            ])
        }
        if model.description != nil {
            addSubview(descriptionLabel)
            NSLayoutConstraint.activate([
                descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                descriptionLabel.bottomAnchor.constraint(equalTo: linkButton.topAnchor, constant: .spacingM),
                descriptionLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: .spacingXL),
                descriptionLabel.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth)
            ])
        }

        // TitleLabels bottomAnchor & descriptionLabel's topAnchor depends on which views are present
        if subviews.contains(titleLabel) && subviews.contains(descriptionLabel) {
            NSLayoutConstraint.activate([
                titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: .spacingM)
            ])
        } else if subviews.contains(titleLabel) {
            NSLayoutConstraint.activate([
                titleLabel.bottomAnchor.constraint(equalTo: linkButton.topAnchor, constant: .spacingM)
            ])
        } else if subviews.contains(descriptionLabel) {
            NSLayoutConstraint.activate([
                descriptionLabel.topAnchor.constraint(equalTo: topAnchor)
            ])
        }
    }

    @objc private func buttonWasTapped(_ sender: Button) {
        delegate?.adConfirmationLinkView(self, buttonWasTapped: sender)
    }
}
