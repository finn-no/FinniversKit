//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

public class TransactionWarningView: UIView {
    private lazy var titleLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.textColor = .textToast
        return label
    }()

    private lazy var messageLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .textToast
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

        titleLabel.text = model.title
        messageLabel.text = model.message

        layer.cornerRadius = .mediumSpacing
        clipsToBounds = true

        addSubview(titleLabel)
        titleLabel.fillInSuperview(margin: .mediumLargeSpacing)
    }
}
