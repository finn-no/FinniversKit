//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol IdentityViewModel {
    /// If defined, `profileImage` will take precedense over the image located at `profileImageUrl`.
    var profileImage: UIImage? { get }

    /// If `profileImage` is not defined, the `delegate` will be queried to download the image
    /// located at this URL.
    var profileImageUrl: URL? { get }

    var displayName: String { get }
    var subtitle: String { get }
    var description: String? { get }

    var isVerified: Bool { get }
    var displayMode: IdentityView.DisplayMode { get }
    var offlineDescription: String? { get }
    var offlineButtonTitle: String? { get }

}

public protocol IdentityViewDelegate: AnyObject {
    func identityViewWasTapped(_ identityView: IdentityView)
    func identityView(_ identityView: IdentityView, loadImageWithUrl url: URL, completionHandler: @escaping (UIImage?) -> Void)
    func identityViewDidTapOfflineButton()
}

public class IdentityView: UIView {
    public enum DisplayMode {
        /// Subtitle visible, profile name blue
        case interactible

        /// Subtitle visible, profile name black
        case nonInteractible

        /// Subtitle hidden, profile name black
        case anonymous

        /// Subtitle hidden, profile name hidden, offlineButton visible
        case offline
    }

    private var lastLoadedImageUrl: URL?

    // MARK: - Public properties

    public weak var delegate: IdentityViewDelegate? {
        didSet {
            loadProfileImage()
        }
    }

    public var viewModel: IdentityViewModel? {
        didSet {
            viewModelChanged()
            loadProfileImage()
        }
    }

    public var hideDescription: Bool = false {
        didSet {
            viewModelChanged()
            loadProfileImage()
        }
    }

    // MARK: - UI properties

    public static let profileImageSize: CGFloat = 40.0
    private lazy var defaultProfileImage = UIImage(named: FinniversImageAsset.avatar)

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = IdentityView.profileImageSize / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var profileNameOrOfflineDescriptionLabel: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var verifiedBadge: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: .verified))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var profileWrapperView: UIView = {
        let wrapperView = UIView(withAutoLayout: true)

        wrapperView.addSubview(profileNameOrOfflineDescriptionLabel)
        wrapperView.addSubview(verifiedBadge)
        wrapperView.addSubview(offlineButton)

        NSLayoutConstraint.activate([
            profileNameOrOfflineDescriptionLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            profileNameOrOfflineDescriptionLabel.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            profileNameOrOfflineDescriptionLabel.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor),

            offlineButton.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            offlineButton.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor)
        ])

        return wrapperView
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.spacing = .spacingXXS
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var offlineButton: UIButton = {
        let button = Button(style: .default, size: .small)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.addTarget(self, action: #selector(offlineButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    private lazy var descriptionLabelConstraints: [NSLayoutConstraint] = [
        descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
        descriptionLabel.topAnchor.constraint(greaterThanOrEqualTo: profileStackView.bottomAnchor, constant: .spacingM),
        descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
        descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM)
    ]

    private lazy var offlineDescriptionLabelConstraint: [NSLayoutConstraint] = [
        profileNameOrOfflineDescriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: offlineButton.leadingAnchor, constant: -.spacingM),
    ]

    private lazy var verifiedBadgeConstraint: [NSLayoutConstraint] = [
        verifiedBadge.leadingAnchor.constraint(equalTo: profileNameOrOfflineDescriptionLabel.trailingAnchor, constant: .spacingXS),
        verifiedBadge.centerYAnchor.constraint(equalTo: profileNameOrOfflineDescriptionLabel.centerYAnchor),
        verifiedBadge.widthAnchor.constraint(equalToConstant: 18),
        verifiedBadge.heightAnchor.constraint(equalToConstant: 18),
    ]

    // MARK: - Setup

    public required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) not implemented")
    }

    public required init(viewModel: IdentityViewModel?) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        setupSubviews()
        addTapListener()
        setupDefaultProfileImage()
        viewModelChanged()
    }

    private func setupSubviews() {
        layer.cornerRadius = 8
        backgroundColor = .bgSecondary

        addSubview(profileStackView)
        addSubview(profileImageView)
        addSubview(descriptionLabel)

        profileStackView.addArrangedSubview(profileWrapperView)
        profileStackView.addArrangedSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            profileImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -.spacingM),
            profileImageView.widthAnchor.constraint(equalToConstant: IdentityView.profileImageSize),
            profileImageView.heightAnchor.constraint(equalToConstant: IdentityView.profileImageSize),

            profileStackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: .spacingS),
            profileStackView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            profileStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -.spacingM),
            profileStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS)
        ])
    }

    private func addTapListener() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped))
        addGestureRecognizer(recognizer)
    }

    private func setupDefaultProfileImage() {
        /// If we don't have a URL, set the default image immediately. Otherwise, give the download-task a bit
        /// of time to download the actual profile image before setting the default to avoid flickering.
        if viewModel?.profileImageUrl == nil {
            profileImageView.image = defaultProfileImage
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                if self.profileImageView.image == nil {
                    UIView.transition(with: self.profileImageView, duration: 0.1, options: .transitionCrossDissolve, animations: {
                        self.profileImageView.image = self.defaultProfileImage
                    })
                }
            })
        }
    }

    // MARK: - Updating view model

    private func viewModelChanged() {
        resetViews()
        if let viewModel = viewModel {
            populateViews(with: viewModel)
        }
    }

    private func resetViews() {
        profileImageView.image = nil
        profileNameOrOfflineDescriptionLabel.text = nil
        verifiedBadge.isHidden = true
        verifiedBadgeConstraint.forEach { $0.isActive = false }

        subtitleLabel.text = nil
        subtitleLabel.isHidden = true

        descriptionLabel.isHidden = true
        descriptionLabelConstraints.forEach { $0.isActive = false }

        offlineButton.isHidden = true
        offlineDescriptionLabelConstraint.forEach { $0.isActive = false }
    }

    private func populateViews(with viewModel: IdentityViewModel) {
        profileNameOrOfflineDescriptionLabel.text = viewModel.displayMode == .offline ? viewModel.offlineDescription : viewModel.displayName
        profileNameOrOfflineDescriptionLabel.textColor = .textPrimary

        let hideVerifiedBadge = (!viewModel.isVerified || viewModel.displayMode == .offline)
        verifiedBadge.isHidden = hideVerifiedBadge
        verifiedBadgeConstraint.forEach { $0.isActive = !hideVerifiedBadge }

        if viewModel.displayMode == .offline {
            offlineButton.isHidden = false
            offlineButton.setTitle(viewModel.offlineButtonTitle, for: .normal)

            subtitleLabel.isHidden = false
            subtitleLabel.text = viewModel.subtitle

            offlineDescriptionLabelConstraint.forEach { $0.isActive = true }

        } else if viewModel.displayMode == .anonymous {
            subtitleLabel.isHidden = true
        } else {
            subtitleLabel.isHidden = false
            subtitleLabel.text = viewModel.subtitle
        }

        let showDescription = ((viewModel.description != nil && !hideDescription) && viewModel.displayMode != .offline)
        descriptionLabel.isHidden = !showDescription
        descriptionLabel.text = viewModel.description
        descriptionLabelConstraints.forEach { $0.isActive = showDescription }
    }

    // MARK: - Private methods

    private func loadProfileImage() {
        if let profileImage = viewModel?.profileImage {
            profileImageView.image = profileImage
            return
        }

        guard let url = viewModel?.profileImageUrl else {
            profileImageView.image = defaultProfileImage
            return
        }

        guard lastLoadedImageUrl != url else { return }
        lastLoadedImageUrl = url

        delegate?.identityView(self, loadImageWithUrl: url, completionHandler: { [weak self] image in
            guard let self = self else { return }
            if let image = image, self.lastLoadedImageUrl == url {
                DispatchQueue.main.async(execute: {
                    UIView.transition(with: self.profileImageView, duration: 0.1, options: .transitionCrossDissolve, animations: {
                        self.profileImageView.image = image
                    })
                })
            } else {
                self.profileImageView.image = self.defaultProfileImage
            }

            self.lastLoadedImageUrl = nil
        })
    }

    // MARK: - Actions

    @objc private func viewWasTapped() {
        delegate?.identityViewWasTapped(self)
    }

    @objc private func offlineButtonTapped() {
        delegate?.identityViewDidTapOfflineButton()
    }
}
