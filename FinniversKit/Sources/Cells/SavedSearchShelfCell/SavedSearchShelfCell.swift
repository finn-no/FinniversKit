import UIKit

public class SavedSearchShelfCell: UICollectionViewCell {
    static let width: CGFloat = 74
    private let borderInsets: CGFloat = 2

    private var defaultImage: UIImage? {
        UIImage(named: .noImage)
    }

    public weak var imageDatasource: RemoteImageViewDataSource? {
        didSet {
            remoteImageView.dataSource = imageDatasource
        }
    }

    private var model: SavedSearchShelfViewModel?

    private lazy  var remoteImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.image = defaultImage
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = (Self.width - 2 * borderInsets) / 2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        return imageView
    }()
    
    private lazy var titleLabel: Label = {
        let label = Label(style: .detailStrong, withAutoLayout: true)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = .spacingS
        return stackView
    }()

    private lazy var storyBorderView: StoryBorderView = {
        let view = StoryBorderView(withAutoLayout: true)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = Self.width / 2
        return view
    }()

    private lazy var imageContainerView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.layer.masksToBounds = false
        view.layer.cornerRadius = Self.width / 2
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        return view
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(stackView)
        stackView.fillInSuperview()
        stackView.addArrangedSubviews([imageContainerView, titleLabel])

        imageContainerView.addSubview(remoteImageView)
        imageContainerView.addSubview(storyBorderView)
        storyBorderView.fillInSuperview()
        remoteImageView.fillInSuperview(margin: borderInsets)

        NSLayoutConstraint.activate([
            imageContainerView.heightAnchor.constraint(equalTo: imageContainerView.widthAnchor),
        ])
    }

    // MARK: - Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        remoteImageView.setImage(defaultImage, animated: false)
        titleLabel.text = ""
        model = nil
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        remoteImageView.layer.borderColor = FrontPageView.backgroundColor.cgColor
    }
}

// MARK: - public functions

public extension SavedSearchShelfCell {
    func loadImage() {
        guard let model = model, let url = model.imageUrlString else {
            remoteImageView.setImage(defaultImage, animated: false)
            return
        }

        remoteImageView.loadImage(for: url, imageWidth: Self.width, fallbackImage: defaultImage)
    }

    func configure(withModel model: SavedSearchShelfViewModel) {
        self.model = model
        self.titleLabel.text = model.title
        updateBorderColor()
    }

    private func updateBorderColor() {
        guard let isRead = model?.isRead else { return }
        storyBorderView.configure(isRead: isRead)
    }
}

private extension UIColor {
    static var unreadStoryTopGradientColor: CGColor {
        UIColor(hex: "#0063FB").cgColor
    }

    static var unreadStoryBottomGradientColor: CGColor {
        UIColor(hex: "#06BEFB").cgColor
    }
}

private class StoryBorderView: UIView {
    private var borderSize: CGSize = .zero
    private var isRead: Bool = true

    override func layoutSubviews() {
        super.layoutSubviews()
        if frame.size != borderSize {
            updateGradientBorder()
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateGradientBorder()
        }
    }

    func configure(isRead: Bool) {
        guard self.isRead != isRead else { return }
        self.isRead = isRead
        updateGradientBorder()
    }

    private func updateGradientBorder() {
        borderSize = frame.size

        layer.sublayers?.forEach({ $0.removeFromSuperlayer() })

        let shape = CAShapeLayer()
        shape.lineWidth = isRead ? 2 : 4
        shape.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor

        let topColor = isRead ? .btnDisabled : UIColor.unreadStoryTopGradientColor
        let bottomColor = isRead ? .btnDisabled : UIColor.unreadStoryBottomGradientColor

        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: .zero, size: frame.size)
        gradient.colors = [topColor, bottomColor]
        gradient.mask = shape

        layer.addSublayer(gradient)
    }
}
