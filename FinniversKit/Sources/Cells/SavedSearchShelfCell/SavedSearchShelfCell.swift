import UIKit

public class SavedSearchShelfCell: UICollectionViewCell {
    private let imageWidth: CGFloat = 64
    
    private var defaultImage: UIImage? {
        UIImage(named: .noImage)
    }
    
    public weak var imageDatasource: RemoteImageViewDataSource? {
        didSet {
            remoteImageView.dataSource = imageDatasource
        }
    }
    
    private var model: SavedSearchShelfViewModel?
    
    private lazy var smallShadowView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .white
        view.layer.masksToBounds = false
        view.layer.cornerRadius = imageWidth / 2
        view.dropShadow(color: .shadowColor, opacity: 0.24, offset: CGSize(width: 0, height: 1), radius: 1)
        return view
    }()
    
    private lazy var largeShadowView: UIView = {
        let view = UIView(withAutoLayout: false)
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = false
        view.layer.cornerRadius = imageWidth / 2
        view.dropShadow(color: .shadowColor, opacity: 0.16, offset: CGSize(width: 0, height: 5), radius: 5)
        return view
    }()
    
    private lazy  var remoteImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.image = defaultImage
        imageView.layer.masksToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageWidth).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageWidth / 2
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
        
        stackView.addArrangedSubviews([imageContainerView, titleLabel])
        stackView.spacing = .spacingS
        return stackView
    }()
    
    private lazy var imageContainerView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.layer.masksToBounds = false
        
        view.addSubview(largeShadowView)
        view.addSubview(smallShadowView)
        view.addSubview(remoteImageView)
        
        largeShadowView.fillInSuperview()
        smallShadowView.fillInSuperview()
        
        view.widthAnchor.constraint(equalToConstant: 60).isActive = true
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return view
    }()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        remoteImageView.setImage(defaultImage, animated: false)
        titleLabel.text = ""
    }
    
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
        
        imageContainerView.layer.cornerRadius = imageWidth / 2
    }
}

// MARK: - public functions

public extension SavedSearchShelfCell {
    func loadImage() {
        guard let model = model, let url = model.imageUrlString else {
            remoteImageView.setImage(defaultImage, animated: false)
            return
        }
        
        remoteImageView.loadImage(for: url, imageWidth: imageWidth, fallbackImage: defaultImage)
    }
    
    func configure(withModel model: SavedSearchShelfViewModel) {
        self.model = model
        self.titleLabel.text = model.title
    }
}

private extension UIColor {
    static var shadowColor: UIColor {
        UIColor(hex: "#475569")
    }
}
