//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol IdentityViewModel {
    var profileImageUrl: URL? { get }
    var displayName: String { get }
    var subtitle: String { get }
    var description: String? { get }

    var isVerified: Bool { get }
    var isTappable: Bool { get }
}

public protocol IdentityViewDelegate: AnyObject {
    func identityViewWasTapped(_ identityView: IdentityView)
    func identityView(_ identityView: IdentityView, loadImageWithUrl url: URL, completionHandler: @escaping (UIImage?) -> Void)
}

public class IdentityView: UIView {

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

    // MARK: - UI properties

    private let profileImageSize: CGFloat = 40.0
    private lazy var defaultProfileImage = UIImage(named: FinniversImageAsset.avatar)

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.layer.cornerRadius = profileImageSize / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var profileNameLabel: Label = {
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

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabelConstraints: [NSLayoutConstraint] = [
        descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
        descriptionLabel.topAnchor.constraint(greaterThanOrEqualTo: profileImageView.bottomAnchor, constant: .mediumLargeSpacing),
        descriptionLabel.topAnchor.constraint(greaterThanOrEqualTo: subtitleLabel.bottomAnchor, constant: .mediumLargeSpacing),
        descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
        descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing)
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
        backgroundColor = .ice

        addSubview(profileImageView)
        addSubview(profileNameLabel)
        addSubview(verifiedBadge)
        addSubview(subtitleLabel)
        addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            profileImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -.mediumLargeSpacing),
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageSize),
            profileImageView.heightAnchor.constraint(equalToConstant: profileImageSize),

            profileNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: .mediumSpacing),
            profileNameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),

            verifiedBadge.leadingAnchor.constraint(equalTo: profileNameLabel.trailingAnchor, constant: .smallSpacing),
            verifiedBadge.centerYAnchor.constraint(equalTo: profileNameLabel.centerYAnchor),
            verifiedBadge.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -.mediumSpacing),
            verifiedBadge.widthAnchor.constraint(equalToConstant: 18),
            verifiedBadge.heightAnchor.constraint(equalToConstant: 18),

            subtitleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: .mediumSpacing),
            subtitleLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: .verySmallSpacing),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
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
        if let viewModel = viewModel {
            populateViews(with: viewModel)
        } else {
            resetViews()
        }
    }

    private func resetViews() {
        profileImageView.image = nil
        profileNameLabel.text = nil
        verifiedBadge.isHidden = true
        subtitleLabel.text = nil
        descriptionLabel.isHidden = true
        descriptionLabelConstraints.forEach { $0.isActive = false }
    }

    private func populateViews(with viewModel: IdentityViewModel) {
        profileNameLabel.text = viewModel.displayName
        profileNameLabel.font = viewModel.isTappable ? .body : .bodyStrong
        profileNameLabel.textColor = viewModel.isTappable ? .primaryBlue : .licorice

        verifiedBadge.isHidden = !viewModel.isVerified

        subtitleLabel.text = viewModel.subtitle

        let showDescription = viewModel.description != nil
        descriptionLabel.isHidden = !showDescription
        descriptionLabel.text = viewModel.description
        descriptionLabelConstraints.forEach { $0.isActive = showDescription }
    }

    // MARK: - Private methods

    private func loadProfileImage() {
        guard let url = viewModel?.profileImageUrl else { return }

        delegate?.identityView(self, loadImageWithUrl: url, completionHandler: { [weak self] image in
            guard let self = self else { return }
            if let image = image {
                DispatchQueue.main.async(execute: {
                    UIView.transition(with: self.profileImageView, duration: 0.1, options: .transitionCrossDissolve, animations: {
                        self.profileImageView.image = image
                    })
                })
            } else {
                self.profileImageView.image = self.defaultProfileImage
            }
        })
    }

    @objc private func viewWasTapped() {
        if viewModel?.isTappable ?? false {
            delegate?.identityViewWasTapped(self)
        }
    }
}
