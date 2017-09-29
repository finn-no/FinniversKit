import UIKit

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
        imageView.tintColor = .white
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .t4
        label.textColor = .black
        label.backgroundColor = .clear
        return label
    }()

    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .t4
        label.textColor = .gray
        label.backgroundColor = .clear
        return label
    }()

    private lazy var imageDesciptionView: UIView = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        view.alpha = 1.0
        view.layer.cornerRadius = PreviewCell.cornerRadius
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var imageTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .t3
        label.textColor = .white
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

        imageTextLabel.topAnchor.constraint(equalTo: imageDesciptionView.topAnchor).isActive = true
        imageTextLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: PreviewCell.margin ).isActive = true
        imageTextLabel.heightAnchor.constraint(equalToConstant: PreviewCell.titleHeight).isActive = true
        imageTextLabel.bottomAnchor.constraint(equalTo: imageDesciptionView.bottomAnchor).isActive = true

        imageDesciptionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageDesciptionView.trailingAnchor.constraint(equalTo: imageTextLabel.trailingAnchor, constant: PreviewCell.margin).isActive = true
        imageDesciptionView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor).isActive = true
        imageDesciptionView.heightAnchor.constraint(equalToConstant: PreviewCell.imageDescriptionHeight).isActive = true
        imageDesciptionView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
    }

    // Mark: - Dependency injection

    public var presentable: PreviewPresentable? {
        didSet {
            imageView.image = presentable?.image
            iconImageView.image = presentable?.iconImage?.withRenderingMode(.alwaysTemplate)
            titleLabel.text = presentable?.title
            subTitleLabel.text = presentable?.subTitle
            imageTextLabel.text = presentable?.imageText
        }
    }
}
