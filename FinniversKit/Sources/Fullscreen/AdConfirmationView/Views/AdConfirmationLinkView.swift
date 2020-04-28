//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public protocol AdConfirmationLinkViewDelegate: AnyObject {
    func adConfirmationLinkView(_ view: AdConfirmationLinkView, buttonWasTapped sender: UIButton)
}

public class AdConfirmationLinkView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.text = model.title
        label.font = .bodyStrong
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var bodyLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .body
        label.text = model.body
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var linkButton: Button = {
        let button = Button(style: .default, size: .small, withAutoLayout: true)
        button.setTitle(model.linkTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var linkIcon: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .webview)
        return imageView
    }()

    private var model: AdConfirmationLinkViewModel
    private weak var delegate: AdConfirmationLinkViewDelegate?

    init(model: AdConfirmationLinkViewModel, delegate: AdConfirmationLinkViewDelegate?) {
        self.model = model
        self.delegate = delegate

        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .bgPrimary
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let actionButtonIconWidth: CGFloat = 12
        let margins = UIEdgeInsets(
            top: .spacingS,
            leading: .spacingM,
            bottom: .spacingS,
            trailing: .spacingM + actionButtonIconWidth
        )

        linkButton.style = linkButton.style.overrideStyle(margins: margins)
        linkButton.addSubview(linkIcon)

        NSLayoutConstraint.activate([
            linkIcon.widthAnchor.constraint(equalToConstant: actionButtonIconWidth),
            linkIcon.heightAnchor.constraint(equalToConstant: actionButtonIconWidth),
            linkIcon.trailingAnchor.constraint(equalTo: linkButton.trailingAnchor, constant: -.spacingS - linkButton.style.borderWidth),
            linkIcon.centerYAnchor.constraint(equalTo: linkButton.centerYAnchor)
        ])

        addSubview(linkButton)
        NSLayoutConstraint.activate([
            linkButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomAnchor.constraint(equalTo: linkButton.bottomAnchor)
        ])

        let maxWidth: CGFloat = 640 - .spacingXL

        if model.title != nil {
            addSubview(titleLabel)
                NSLayoutConstraint.activate([
                    titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                    titleLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
                    titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth),
                ])
        }

        if model.body != nil {
            addSubview(bodyLabel)
             NSLayoutConstraint.activate([
                 bodyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                 bodyLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
                 bodyLabel.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth),
             ])
        }

        // Some constraints need to consider which views that actually exist in the hiearchy
        if subviews.contains(titleLabel) && subviews.contains(bodyLabel) {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingXS),
                linkButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: .spacingM)
            ])
        } else if subviews.contains(titleLabel) {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                linkButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM)
            ])
        } else if subviews.contains(bodyLabel) {
            NSLayoutConstraint.activate([
                bodyLabel.topAnchor.constraint(equalTo: topAnchor),
                linkButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: .spacingM)
            ])
        }
    }

    @objc private func buttonWasTapped(_ sender: Button) {
        delegate?.adConfirmationLinkView(self, buttonWasTapped: sender)
    }
}
