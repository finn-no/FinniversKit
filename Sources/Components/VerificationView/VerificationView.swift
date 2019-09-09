//
//  Copyright © 2019 FINN AS. All rights reserved.
//

public protocol VerificationViewDelegate: AnyObject {
    func didTapVerificationButton(_ : VerificationView)
}

public class VerificationView: UIView {
    private lazy var verificationImageView: UIImageView = {
        let image = UIImage(named: .spidLogo)
        let imageView = UIImageView(image: image)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = . center
        label.numberOfLines = 1
        return label
    }()

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .caption)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var verificationButton: Button = {
        let button = Button(style: .callToAction)
        button.addTarget(self, action: #selector(didTapVerificationButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var verificationButtonImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: .webview))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    public var viewModel: VerificationViewModel? {
        didSet {
            titleLabel.text = viewModel?.title
            descriptionLabel.text = viewModel?.description
            verificationButton.setTitle(viewModel?.buttonTitle, for: .normal)
        }
    }

    public weak var delegate: VerificationViewDelegate?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

private extension VerificationView {
    func setup() {
        backgroundColor = .white

        addSubview(verificationImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(verificationButton)
        addSubview(verificationButtonImageView)

        let insets = UIEdgeInsets(
            top: .mediumSpacing,
            leading: .mediumLargeSpacing,
            bottom: .mediumLargeSpacing,
            trailing: .mediumLargeSpacing
        )

        let imageWidth: CGFloat = 18
        verificationButton.titleEdgeInsets = UIEdgeInsets(top: verificationButton.titleEdgeInsets.top,
                                                          leading: verificationButton.titleEdgeInsets.leading + .mediumLargeSpacing + imageWidth,
                                                          bottom: verificationButton.titleEdgeInsets.bottom,
                                                          trailing: verificationButton.titleEdgeInsets.trailing + .mediumLargeSpacing + imageWidth)

        NSLayoutConstraint.activate([
            verificationImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: insets.top),
            verificationImageView.widthAnchor.constraint(equalToConstant: 64),
            verificationImageView.heightAnchor.constraint(equalToConstant: 32),
            verificationImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: verificationImageView.bottomAnchor, constant: insets.top),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: insets.leading),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -insets.trailing),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumLargeSpacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: insets.leading),
            descriptionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -insets.trailing),

            verificationButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: .mediumLargeSpacing),
            verificationButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: insets.leading),
            verificationButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -insets.trailing),

            verificationButtonImageView.widthAnchor.constraint(equalToConstant: imageWidth),
            verificationButtonImageView.heightAnchor.constraint(equalToConstant: imageWidth),
            verificationButtonImageView.centerYAnchor.constraint(equalTo: verificationButton.centerYAnchor),
            verificationButtonImageView.trailingAnchor.constraint(equalTo: verificationButton.trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }

    @objc func didTapVerificationButton() {
        delegate?.didTapVerificationButton(self)
    }
}
