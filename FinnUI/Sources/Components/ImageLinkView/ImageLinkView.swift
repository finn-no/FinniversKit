//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class ImageLinkView: UIView {
    public enum OverlayKind {
        case video
        case virtualViewing
    }

    // MARK: - Private properties

    private lazy var overlayView = OverlayView(withAutoLayout: true)

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = .spacingS
        return imageView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(descriptionLabel)
        addSubview(imageView)
        addSubview(overlayView)

        NSLayoutConstraint.activate(
        [
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            imageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: .spacingS),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 3/4),

            overlayView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            overlayView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }

    // MARK: - Public methods

    public func configure(with viewModel: ImageLinkViewModel) {
        descriptionLabel.text = viewModel.description
        imageView.image = viewModel.image

        switch viewModel.overlayKind {
        case .video?:
            overlayView.configure(withImage: UIImage(named: .speechbubbleSmiley))
            overlayView.isHidden = false
        case .virtualViewing?:
            overlayView.configure(withImage: UIImage(named: .handshake))
            overlayView.isHidden = false
        default:
            overlayView.isHidden = true
        }
    }
}

// MARK: - Private class

private class OverlayView: UIView {

    // MARK: - Private properties

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .milk
        return imageView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        layer.cornerRadius = .spacingS
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        addSubview(iconImageView)
        iconImageView.fillInSuperview(margin: .spacingS)

        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: .spacingXL),
            iconImageView.heightAnchor.constraint(equalToConstant: .spacingXL)
        ])
    }

    // MARK: - Internal methods

    func configure(withImage image: UIImage) {
        iconImageView.image = image.withRenderingMode(.alwaysTemplate)
    }
}
