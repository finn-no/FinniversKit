//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

public class TransactionWarningView: UIView {
    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var messageLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var imageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.layer.cornerRadius = .mediumLargeSpacing
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private var defaultImageSize: CGFloat = 64
    private var loadingColor: UIColor? = .toothPaste
    private var fallbackImage = UIImage(named: .noImage)

    private var model: TransactionWarningViewModel

    public init(withAutoLayout autoLayout: Bool = false, model: TransactionWarningViewModel) {
        self.model = model

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = !autoLayout

        setup()
    }

    public func loadImage() {
        guard let imagePath = model.imageUrlString else {
            imageView.image = fallbackImage
            return
        }

        imageView.loadImage(
            for: imagePath,
            imageWidth: defaultImageSize,
            loadingColor: loadingColor,
            fallbackImage: fallbackImage
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .bgAlert
        layer.cornerRadius = .mediumSpacing

        titleLabel.text = model.title
        messageLabel.text = model.message

        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -.mediumSpacing),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .mediumLargeSpacing),

            messageLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumSpacing),

            imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.mediumSpacing),
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .mediumSpacing),
            imageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -.mediumSpacing),

            bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: .mediumLargeSpacing),
        ])

        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        messageLabel.setContentHuggingPriority(.required, for: .vertical)

        loadImage()
    }
}
