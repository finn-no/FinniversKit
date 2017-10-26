//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol PreviewCellDataSource {
    func loadImage(for url: URL, completion: @escaping ((UIImage?) -> Void))
}

public class PreviewCell: UICollectionViewCell {

    // Mark: - Internal properties

    private static let titleHeight: CGFloat = 20.0
    private static let titleTopMargin: CGFloat = 3.0
    private static let titleBottomMargin: CGFloat = 17.0
    private static let subtitleHeight: CGFloat = 17.0
    private static let subtitleTopMargin: CGFloat = 6.0
    private static let margin: CGFloat = 8.0
    private static let cornerRadius: CGFloat = 2.0
    private static let imageDescriptionHeight: CGFloat = 35.0
    private static let iconSize: CGFloat = 23.0

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = PreviewCell.cornerRadius
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .milk
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.style = .detail(.licorice)
        label.backgroundColor = .clear
        return label
    }()

    private lazy var subTitleLabel: Label = {
        let label = Label()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.style = .detail(.licorice)
        label.backgroundColor = .clear
        return label
    }()

    private lazy var imageDesciptionView: UIView = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        view.alpha = 1.0
        view.layer.cornerRadius = PreviewCell.cornerRadius
        view.layer.masksToBounds = true

        if #available(iOS 11.0, *) {
            view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        }

        return view
    }()

    private lazy var imageTextLabel: Label = {
        let label = Label()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.style = .t4(.milk)
        label.backgroundColor = .clear
        return label
    }()

    // Mark: - External properties

    public static var nonImageHeight: CGFloat {
        return subtitleTopMargin + subtitleHeight + titleTopMargin + titleHeight + titleBottomMargin
    }

    // Mark: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        isAccessibilityElement = true

        addSubview(imageView)
        addSubview(subTitleLabel)
        addSubview(titleLabel)
        addSubview(imageDesciptionView)

        imageDesciptionView.addSubview(iconImageView)
        imageDesciptionView.addSubview(imageTextLabel)

        backgroundColor = .white
    }

    // Mark: - Superclass Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        iconImageView.image = nil
        titleLabel.text = ""
        subTitleLabel.text = ""
        imageTextLabel.text = ""
        accessibilityLabel = ""
    }

    // Mark: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true

        subTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: PreviewCell.subtitleTopMargin).isActive = true
        subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subTitleLabel.heightAnchor.constraint(equalToConstant: PreviewCell.subtitleHeight).isActive = true

        titleLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: PreviewCell.titleTopMargin).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: PreviewCell.titleHeight).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -PreviewCell.titleBottomMargin).isActive = true

        iconImageView.leadingAnchor.constraint(equalTo: imageDesciptionView.leadingAnchor, constant: PreviewCell.margin).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: PreviewCell.iconSize).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: PreviewCell.iconSize).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: imageDesciptionView.centerYAnchor).isActive = true

        //        imageTextLabel.topAnchor.constraint(equalTo: imageDesciptionView.topAnchor).isActive = true
        imageTextLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: PreviewCell.margin).isActive = true
        //        imageTextLabel.bottomAnchor.constraint(equalTo: imageDesciptionView.bottomAnchor).isActive = true
        imageTextLabel.centerYAnchor.constraint(equalTo: imageDesciptionView.centerYAnchor).isActive = true

        imageDesciptionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageDesciptionView.trailingAnchor.constraint(equalTo: imageTextLabel.trailingAnchor, constant: PreviewCell.margin).isActive = true
        imageDesciptionView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor).isActive = true
        imageDesciptionView.heightAnchor.constraint(equalToConstant: PreviewCell.imageDescriptionHeight).isActive = true
        imageDesciptionView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
    }

    // Mark: - Dependency injection

    /// The presentable contains data used to populate the view.
    public var presentable: PreviewPresentable? {
        didSet {
            if let presentable = presentable {
                iconImageView.image = presentable.iconImage.withRenderingMode(.alwaysTemplate)
                titleLabel.text = presentable.title
                subTitleLabel.text = presentable.subTitle
                imageTextLabel.text = presentable.imageText
                accessibilityLabel = presentable.accessibilityLabel

                loadImage(presentable: presentable)
            }
        }
    }

    /// The loading color is used to fill the image view while we load the image.
    public var loadingColor: UIColor?

    /// A data source for the loading of the image
    public var dataSource: PreviewCellDataSource?

    // Mark: - Private

    private func loadImage(presentable: PreviewPresentable) {
        guard let dataSource = dataSource, let imageUrl = presentable.imageUrl else {
            loadingColor = .clear
            imageView.image = defaultImage
            return
        }

        imageView.backgroundColor = loadingColor

        dataSource.loadImage(for: imageUrl) { [weak self] image in
            self?.imageView.backgroundColor = .clear

            if let image = image {
                self?.imageView.image = image
            } else {
                self?.imageView.image = self?.defaultImage
            }
        }
    }

    private var defaultImage: UIImage? {
        return UIImage(frameworkImageNamed: "NoImage")
    }
}
