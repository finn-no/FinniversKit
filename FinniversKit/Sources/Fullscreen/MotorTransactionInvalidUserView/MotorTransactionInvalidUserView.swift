//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public protocol MotorTransactionInvalidUserViewDelegate: AnyObject {
    func didTapContinueButton(_ button: Button)
    func didTapCancelButton(_ button: Button)
}

public class MotorTransactionInvalidUserView: UIView {
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: .motorTransaction)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var detailLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var continueButton: Button = {
        let button = Button(style: .callToAction, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleContinueButtonTap(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var cancelButton: Button = {
        let button = Button(style: .flat, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleCancelButtonTap(_:)), for: .touchUpInside)
        return button
    }()

    public weak var delegate: MotorTransactionInvalidUserViewDelegate?

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }

    public func configure(_ viewModel: MotorTransactionInvalidUserViewModel) {
        titleLabel.text = viewModel.title
        detailLabel.attributedText = viewModel.detail
        continueButton.setTitle(viewModel.continueButtonText, for: .normal)
        cancelButton.setTitle(viewModel.cancelButtonText, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(continueButton)
        addSubview(cancelButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingXL),
            imageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 144),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: .spacingXL),
            titleLabel.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: -.spacingXL),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            continueButton.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: .spacingXL),
            continueButton.leadingAnchor.constraint(equalTo: detailLabel.leadingAnchor),
            continueButton.trailingAnchor.constraint(equalTo: detailLabel.trailingAnchor),

            cancelButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: .spacingL),
            cancelButton.leadingAnchor.constraint(equalTo: continueButton.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: continueButton.trailingAnchor),
        ])
    }
}

private extension MotorTransactionInvalidUserView {
    @objc func handleContinueButtonTap(_ sender: Button) {
        delegate?.didTapContinueButton(sender)
    }

    @objc func handleCancelButtonTap(_ sender: Button) {
        delegate?.didTapCancelButton(sender)
    }
}
