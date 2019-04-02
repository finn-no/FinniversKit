//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public final class NativeContentAdvertView: UIView {

    // MARK: - Public properties

    public weak var delegate: NativeAdvertViewDelegate?
    public weak var imageDelegate: NativeAdvertImageDelegate?

    // MARK: - Private properties

    private let containerMaxWidth: CGFloat = 400
    private let logoImageSize: CGFloat = 48.0
    private let cornerRadius: CGFloat = 8.0

    // MARK: - UI properties

    private lazy var containerView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(r: 248, g: 248, b: 248)!
        return view
    }()

    private lazy var mainImageView: UIImageView = {
        let view = UIImageView(withAutoLayout: true)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    private lazy var logoImageView: UIImageView = {
        let view = UIImageView(withAutoLayout: true)
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
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
        build(viewModel: viewModel)
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
        containerView.addSubview(logoImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(settingsButton)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing),

            mainImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            mainImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.61),

            settingsButton.topAnchor.constraint(equalTo: mainImageView.topAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),

            logoImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.mediumLargeSpacing),
            logoImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -.mediumLargeSpacing),
            logoImageView.widthAnchor.constraint(equalToConstant: logoImageSize),
            logoImageView.heightAnchor.constraint(equalToConstant: logoImageSize),

            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .mediumSpacing),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: logoImageView.leadingAnchor, constant: -.mediumLargeSpacing),
            titleLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: .mediumLargeSpacing),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -.mediumLargeSpacing),
        ])
    }

    func build(viewModel: NativeAdvertViewModel) {
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
