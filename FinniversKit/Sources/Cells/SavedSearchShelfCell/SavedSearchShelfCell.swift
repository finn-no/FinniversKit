import UIKit

public class SavedSearchShelfCell: UICollectionViewCell {
    static let width: CGFloat = 74
    private let borderInsets: CGFloat = 5

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
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = (Self.width - 2 * borderInsets) / 2
        imageView.clipsToBounds = true
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
        view.layer.cornerRadius = Self.width / 2
        view.clipsToBounds = true
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

        let imageContainerView = UIView(withAutoLayout: true)
        imageContainerView.addSubview(remoteImageView)
        remoteImageView.fillInSuperview(margin: borderInsets)
        imageContainerView.addSubview(storyBorderView)
        storyBorderView.fillInSuperview()

        stackView.addArrangedSubviews([imageContainerView, titleLabel])

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
        storyBorderView.configure(isRead: model.isRead)
    }
}
