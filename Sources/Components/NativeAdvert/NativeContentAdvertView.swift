//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public final class NativeContentAdvertView: UIView {

    // MARK: - Public properties

    public weak var delegate: NativeAdvertViewDelegate?
    public weak var imageDelegate: NativeAdvertImageDelegate?

    // MARK: - Private properties

    private let containerMaxWidth: CGFloat = 320
    private let logoImageSize: CGFloat = 48.0
    private let cornerRadius: CGFloat = 8.0

    // See specification on:
    // https://annonseweb.schibsted.no/nb-no/product/finn-native-ads-16031
    private let imageAspectRatio: CGFloat = (1200.0 / 627)

    // MARK: - UI properties

    private lazy var containerView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var mainImageView: UIImageView = {
        let view = UIImageView(withAutoLayout: true)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    private lazy var bottomContainerView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = UIColor(r: 248, g: 248, b: 248)!
        return view
    }()

    private lazy var logoImageView: UIImageView = {
        let view = UIImageView(withAutoLayout: true)
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .textToast
        return label
    }()

    private lazy var settingsButton: NativeContentSettingsButton = {
        let button = NativeContentSettingsButton(cornerRadius: cornerRadius)
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        fatalError("init(frame:) not implemented")
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    public init(viewModel: NativeAdvertViewModel, imageDelegate: NativeAdvertImageDelegate?) {
        super.init(frame: .zero)
        self.imageDelegate = imageDelegate
        setup()
        configure(viewModel: viewModel)
    }

    // MARK: - Private methods

    @objc private func settingsButtonTapped() {
        delegate?.nativeAdvertViewDidSelectSettingsButton()
    }
}

private extension NativeContentAdvertView {
    func setup() {
        addSubview(containerView)

        containerView.addSubview(mainImageView)
        containerView.addSubview(bottomContainerView)
        containerView.addSubview(settingsButton)

        bottomContainerView.addSubview(logoImageView)
        bottomContainerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing),
            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: .mediumSpacing),
            containerView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -.mediumSpacing),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.widthAnchor.constraint(lessThanOrEqualToConstant: containerMaxWidth),
            containerView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),

            mainImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor, multiplier: 1.0 / imageAspectRatio),

            settingsButton.topAnchor.constraint(equalTo: mainImageView.topAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),

            bottomContainerView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            bottomContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            logoImageView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -.mediumSpacing),
            logoImageView.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -.mediumSpacing),
            logoImageView.widthAnchor.constraint(equalToConstant: logoImageSize),
            logoImageView.heightAnchor.constraint(equalToConstant: logoImageSize),

            titleLabel.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: .mediumSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: .mediumSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: logoImageView.leadingAnchor, constant: -.mediumLargeSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -.mediumSpacing)
        ])
    }

    func configure(viewModel: NativeAdvertViewModel) {
        mainImageView.image = nil
        if let mainImageURL = viewModel.mainImageURL {
            imageDelegate?.nativeAdvertView(setImageWithURL: mainImageURL, onImageView: mainImageView)
        }

        logoImageView.image = nil
        if let logoImageURL = viewModel.iconImageURL {
            imageDelegate?.nativeAdvertView(setImageWithURL: logoImageURL, onImageView: logoImageView)
        }

        titleLabel.text = viewModel.title
        settingsButton.text = viewModel.sponsoredText
    }
}
