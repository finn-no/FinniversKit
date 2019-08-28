//
//  Copyright © 2019 FINN AS. All rights reserved.
//

public protocol VerificationCardViewDelegate: AnyObject {
    func didTapVerificationButton(_ : VerificationCardView)
}

public class VerificationCardView: UIView {
    private lazy var verificationImageView: UIImageView = {
        let image = UIImage(named: .noImage)
        let imageView = UIImageView(image: image)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .caption)
        label.translatesAutoresizingMaskIntoConstraints = false
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

    public weak var delegate: VerificationCardViewDelegate?

    public var model: VerificationViewModel? {
        didSet {
            titleLabel.text = model?.title
            descriptionLabel.text = model?.description
            verificationButton.setTitle(model?.buttonTitle, for: .normal)
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

private extension VerificationCardView {
    func setup() {
        clipsToBounds = true
        layer.cornerRadius = 16

        if UIDevice.isIPhone() {
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }

        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor

        backgroundColor = .white

        addSubview(verificationImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(verificationButton)
        addSubview(verificationButtonImageView)

        let insets = UIEdgeInsets(
            top: 0,
            leading: .largeSpacing,
            bottom: .largeSpacing,
            trailing: .largeSpacing
        )

        let imageWidth: CGFloat = 18
        verificationButton.titleEdgeInsets = UIEdgeInsets(top: verificationButton.titleEdgeInsets.top,
                                                          leading: verificationButton.titleEdgeInsets.leading + .mediumLargeSpacing + imageWidth,
                                                          bottom: verificationButton.titleEdgeInsets.bottom,
                                                          trailing: verificationButton.titleEdgeInsets.trailing + .mediumLargeSpacing + imageWidth)

        NSLayoutConstraint.activate([
            verificationImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            verificationImageView.widthAnchor.constraint(equalToConstant: 120),
            verificationImageView.heightAnchor.constraint(equalToConstant: 120),
            verificationImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: verificationImageView.bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 48),
            titleLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: insets.leading),
            descriptionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -insets.trailing),

            verificationButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: insets.bottom),
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
