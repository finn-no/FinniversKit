import UIKit

public class RecentlyFavoritedShelfCell: UICollectionViewCell {
    public typealias ButtonAction = ((_ model: RecentlyFavoritedViewmodel, _ isFavorited: Bool) -> ())
    
    private static let titleHeight: CGFloat = 8
    private static let priceTagHeight: CGFloat = 30
    private let imageviewWidth: CGFloat = 128
    private var defaultImage: UIImage? {
        return UIImage(named: .noImage)
    }
    
    public var buttonAction: ButtonAction?
    private var model: RecentlyFavoritedViewmodel?
    private var isFavorited: Bool = true {
        didSet {
            favoriteButton.isToggled = isFavorited
        }
    }
    
    private var task: URLSessionDataTask?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: imageviewWidth).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageviewWidth).isActive = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = Label(style: .captionStrong)
        label.textColor = .textTertiary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var priceBackground: UIView = {
        let background = UIVisualEffectView(withAutoLayout: true)
        if #available(iOS 13.0, *) {
            background.effect = UIBlurEffect(style: .systemThinMaterialDark)
        } else {
            background.effect = nil
            background.backgroundColor = UIColor.priceLabelBackgroundColor.withAlphaComponent(0.8)
        }
        background.alpha = 1.0
        background.layer.cornerRadius = RecentlyFavoritedShelfCell.priceTagHeight / 2
        background.clipsToBounds = true
        
        background.contentView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            background.heightAnchor.constraint(equalToConstant: RecentlyFavoritedShelfCell.priceTagHeight),
            priceLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 8),
            priceLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: 4),
            priceLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -8),
            priceLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -4)
            
        ])
        
        return background
    }()
    
    private let smallShadowView: UIView = {
        let view = UIView(withAutoLayout: false)
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 8
        view.dropShadow(color: .shadowColor, opacity: 0.24, offset: CGSize(width: 0, height: 1), radius: 1)
        return view
    }()
    
    private let largeShadowView: UIView = {
        let view = UIView(withAutoLayout: false)
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 8
        view.dropShadow(color: .shadowColor, opacity: 0.16, offset: CGSize(width: 0, height: 5), radius: 5)
        return view
    }()
    
    
    private lazy var imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(largeShadowView)
        view.addSubview(smallShadowView)
        view.addSubview(imageView)
        view.addSubview(priceLabel)
        
        return view
    }()
    
    private lazy var favoriteButton: IconButton = {
        let button = IconButton(style: .favorite)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var ribbonView: RibbonView = RibbonView(withAutoLayout: true)
    
    private lazy var titleLabel: Label = {
        let label = Label(style: .body)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Stol - Som NY!"
        label.numberOfLines = 2
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var locationLabel: Label = {
        let label = Label(style: .detail)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.textColor = .textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "Oslo"
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var verticalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = .spacingS
        
        stackView.addArrangedSubviews([ribbonView, locationLabel, titleLabel])
        stackView.setCustomSpacing(4, after: locationLabel)
        return stackView
    }()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = defaultImage
        titleLabel.text = ""
        locationLabel.text = ""
        priceLabel.text = ""
        favoriteButton.isToggled = true
        model = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    @objc private func favoriteButtonPressed() {
        guard let model = model else {
            return
        }
        buttonAction?(model, isFavorited)
    }
    
    public func configure(withModel model: RecentlyFavoritedViewmodel) {
        self.model = model
        titleLabel.text = model.title
        locationLabel.text = model.location
        priceLabel.text = model.price
        
        if let price = model.price {
            priceLabel.text = price
            priceLabel.isHidden = price.isEmpty
            priceBackground.isHidden = price.isEmpty
        } else {
            priceLabel.isHidden = true
            priceBackground.isHidden = true
        }
    }
    
    func setImage(_ image: UIImage?) {
        if let image = image {
            imageView.image = image
        } else {
            imageView.image = defaultImage
        }
        DispatchQueue.main.async {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    public func loadImage() {
        guard let model = model, let path = model.imageUrl, let url = URL(string: path) else {
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            DispatchQueue.main.async {
                if let data = data {
                    self?.setImage(UIImage(data: data))
                }
            }
        }

        task?.resume()
        
    }
    
    public func cancelImageLoading() {
        task?.cancel()
        task = nil
        imageView.image = defaultImage
    }
}

//MARK: - Layout & Setups
private extension RecentlyFavoritedShelfCell {
    private func setup() {
        ribbonView.style = .disabled
        ribbonView.title = "Solgt"
        ribbonView.isHidden = Int.random(in: 0...2) % 2 == 0
        ribbonView.setContentCompressionResistancePriority(.required, for: .vertical)
        favoriteButton.isToggled = true
        
        contentView.addSubview(imageContainerView)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(priceBackground)
        contentView.addSubview(verticalStack)
        
        imageView.image = defaultImage
        imageContainerView.setContentCompressionResistancePriority(.required, for: .vertical)
        NSLayoutConstraint.activate([
            imageContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            imageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            imageContainerView.heightAnchor.constraint(equalToConstant: 128),
            
            verticalStack.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            verticalStack.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 8),
            verticalStack.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            titleLabel.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -8),
            priceBackground.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 8),
            priceBackground.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -8),
            priceBackground.trailingAnchor.constraint(lessThanOrEqualTo: imageContainerView.trailingAnchor, constant: -8),
            ribbonView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
        ])
        
        largeShadowView.fillInSuperview()
        smallShadowView.fillInSuperview()
    }
}


private extension UIColor {
    static var shadowColor: UIColor {
        UIColor(hex: "#475569")
    }
    
    static var priceLabelBackgroundColor: UIColor {
        UIColor(hex: "#262626")
    }
}
