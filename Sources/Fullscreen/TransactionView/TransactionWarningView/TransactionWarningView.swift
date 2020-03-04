//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

public class TransactionWarningView: UIView {
    weak var dataSource: RemoteImageViewDataSource? {
        didSet {
            imageView.dataSource = dataSource
        }
    }

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textColor = .licorice
        label.numberOfLines = 0
        return label
    }()

    private lazy var messageLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.textColor = .licorice
        label.numberOfLines = 0
        return label
    }()

    private lazy var imageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.layer.cornerRadius = .spacingM
        imageView.backgroundColor = .clear
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
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
        guard let imagePath = model.imageUrl else {
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
        layer.cornerRadius = .spacingS

        titleLabel.text = model.title
        messageLabel.text = model.message

        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -.spacingS),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingM),

            messageLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingS),

            imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: .spacingXXL),
            imageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingXXL),
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingS),
            imageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -.spacingS),

            bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: .spacingM),
        ])

        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        messageLabel.setContentHuggingPriority(.required, for: .vertical)
    }
}
