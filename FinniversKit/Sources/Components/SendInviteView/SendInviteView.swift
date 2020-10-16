//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public protocol SendInviteViewDelegate: AnyObject {
    func loadImage(_ view: SendInviteView, loadImageWithUrl url: URL, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func didTapSendInviteButton(_ button: Button)
    func didTapSendInviteLaterButton(_ button: Button)
}

public class SendInviteView: UIView {
    static let profileImageSize: CGFloat = 44

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var profileImage: RoundedImageView = RoundedImageView(withAutoLayout: true)

    private lazy var profileNameLabel = Label(style: .body, withAutoLayout: true)

    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImage, profileNameLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = .spacingS
        return stackView
    }()

    private lazy var sendInviteButton: Button = {
        let button = Button(style: .callToAction, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleSendInviteButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var sendInviteLaterButton: Button = {
        let button = Button(style: .flat, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleSendInviteLaterButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sendInviteButton, sendInviteLaterButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = .spacingXL
        return stackView
    }()

    public weak var delegate: SendInviteViewDelegate?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(_ viewModel: SendInviteViewModel) {
        titleLabel.text = viewModel.title
        profileNameLabel.text = viewModel.profileName
        sendInviteButton.setTitle(viewModel.sendInviteButtonText, for: .normal)
        sendInviteLaterButton.setTitle(viewModel.sendInviteLaterButtonText, for: .normal)
    }

    private func setup() {
        [titleLabel, profileStackView, buttonStackView].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingL),
            titleLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: .spacingS),
            titleLabel.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: -.spacingS),

            profileImage.widthAnchor.constraint(equalToConstant: SendInviteView.profileImageSize),
            profileImage.heightAnchor.constraint(equalToConstant: SendInviteView.profileImageSize),

            profileStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingL),
            profileStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),

            buttonStackView.topAnchor.constraint(equalTo: profileStackView.bottomAnchor, constant: .spacingL),
            buttonStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: .spacingM),
            buttonStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -.spacingM),
        ])
    }

    public func loadImage(_ url: URL) {
        delegate?.loadImage(self, loadImageWithUrl: url, imageWidth: SendInviteView.profileImageSize, completion: { [weak self] image in
            guard
                let self = self,
                let image = image
            else { return }

            self.profileImage.image = image
        })
    }
}

// MARK: - Delegate methods

private extension SendInviteView {
    @objc func handleSendInviteButtonTap(_ sender: Button) {
        delegate?.didTapSendInviteButton(sender)
    }

    @objc func handleSendInviteLaterButtonTap(_ sender: Button) {
        delegate?.didTapSendInviteLaterButton(sender)
    }
}
