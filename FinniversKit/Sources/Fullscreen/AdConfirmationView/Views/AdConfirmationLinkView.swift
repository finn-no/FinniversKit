//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public protocol AdConfirmationLinkViewDelegate: AnyObject {
    func adConfirmationLinkView(_ view: AdConfirmationLinkView, buttonWasTapped sender: UIButton)
}

public class AdConfirmationLinkView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .green
        return label
    }()

    // Why won't this work ?!
//    private lazy var descriptionLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 2
//        label.backgroundColor = .orange
//        return UILabel()
//    }()
    private var descriptionLabel: UILabel = UILabel()

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
        let minWidth: CGFloat = 280

        addSubview(linkButton)
        NSLayoutConstraint.activate([
            linkButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            linkButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            linkButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        if let title = model.title {
            titleLabel.text = title
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(titleLabel)
                NSLayoutConstraint.activate([
                    titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                    titleLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: .spacingXL),
                    titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth),
                    titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth),
                    titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: .spacingXXL)
                ])
        }

        if let description = model.descriptionText {
            descriptionLabel.text = description
            descriptionLabel.numberOfLines = 0
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(descriptionLabel)
             NSLayoutConstraint.activate([
                 descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                 descriptionLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -.spacingXXL),
                 descriptionLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth),
                 descriptionLabel.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth),
                 descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: .spacingXXL)
             ])
        }

        // TitleLabels bottomAnchor & descriptionLabel's topAnchor depends on which views are present
        if subviews.contains(titleLabel) && subviews.contains(descriptionLabel) {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: .spacingM),
            ])
        } else if subviews.contains(titleLabel) {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: linkButton.topAnchor, constant: .spacingM),
            ])
        } else if subviews.contains(descriptionLabel) {
            NSLayoutConstraint.activate([
                descriptionLabel.topAnchor.constraint(equalTo: topAnchor),
                descriptionLabel.bottomAnchor.constraint(equalTo: linkButton.topAnchor, constant: .spacingM),
            ])
        }
    }

    @objc private func buttonWasTapped(_ sender: Button) {
        delegate?.adConfirmationLinkView(self, buttonWasTapped: sender)
    }
}
