//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol WishListViewCellDataSource: class {
    func wishListViewCell(_ wishlistListViewCell: WishListViewCell, loadImageForModel model: WishListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func wishListViewCell(_ wishlistListViewCell: WishListViewCell, cancelLoadingImageForModel model: WishListViewModel, imageWidth: CGFloat)
}

public class WishListViewCell: UITableViewCell {
    // MARK: - External properties
    
    /// The loading color is used to fill the image view while we load the image.
    public var loadingColor: UIColor?
    
    /// A data source for the loading of the image
    public weak var dataSource: WishListViewCellDataSource?
    
    // MARK: - Internal properties
    
    private static let layerOpacity: Float = 0.85
    private static let cornerRadius: CGFloat = 8
    private static let defaultImage: UIImage = UIImage(named: .noImage)
    
    private lazy var adImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = WishListViewCell.cornerRadius
        return imageView
    }()
    
    private lazy var priceLabel: Label = {
        let label = Label(style: .title4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .licorice
        label.textColor = .milk
        label.textAlignment = .center
        label.layer.opacity = WishListViewCell.layerOpacity
        return label
    }()
    
    private lazy var statusLabel: RibbonView = {
        let view = RibbonView(style: .success)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var recentUpdateLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .stone
        return label
    }()
    
    private lazy var locationLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .stone
        label.textAlignment = .right
        return label
    }()
    
    private lazy var infoContainer: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.axis = .horizontal
        view.distribution = .fillProportionally
        return view
    }()
    
    private lazy var titleLabel: Label = {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Setup
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        isAccessibilityElement = true
        selectionStyle = .none
        
        addSubview(adImageView)
        adImageView.addSubview(priceLabel)
        adImageView.addSubview(statusLabel)
        
        addSubview(infoContainer)
        infoContainer.addArrangedSubview(recentUpdateLabel)
        infoContainer.addArrangedSubview(locationLabel)
        
        addSubview(titleLabel)
        
        backgroundColor = .milk

        NSLayoutConstraint.activate([
            adImageView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            adImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            adImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
            adImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95),
            
            priceLabel.leadingAnchor.constraint(equalTo: adImageView.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: adImageView.bottomAnchor),
            priceLabel.heightAnchor.constraint(equalTo: adImageView.heightAnchor, multiplier: 0.15),
            
            statusLabel.trailingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: -.mediumLargeSpacing),
            statusLabel.bottomAnchor.constraint(equalTo: adImageView.bottomAnchor, constant: -.mediumSpacing),
            
            infoContainer.leadingAnchor.constraint(equalTo: adImageView.leadingAnchor),
            infoContainer.trailingAnchor.constraint(equalTo: adImageView.trailingAnchor),
            infoContainer.topAnchor.constraint(equalTo: adImageView.bottomAnchor, constant: .mediumSpacing),
            
            titleLabel.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: infoContainer.bottomAnchor),
        ])
    }
    
    public override func layoutSubviews() {
        let roundedRightCornerLayer = CAShapeLayer()
        roundedRightCornerLayer.bounds = priceLabel.frame
        roundedRightCornerLayer.position = priceLabel.center
        roundedRightCornerLayer.path = UIBezierPath(roundedRect: priceLabel.bounds, byRoundingCorners: [UIRectCorner.topRight],
                                                    cornerRadii: CGSize(width: WishListViewCell.cornerRadius, height: WishListViewCell.cornerRadius)).cgPath
        priceLabel.layer.mask = roundedRightCornerLayer
    }
    
    // MARK: - Superclass Overrides
    
    override public func prepareForReuse() {
        adImageView.image = nil
        priceLabel.text = ""
        statusLabel.title = ""
        recentUpdateLabel.text = ""
        locationLabel.text = ""
        titleLabel.text = ""
        
        if let model = model {
            dataSource?.wishListViewCell(self, cancelLoadingImageForModel: model, imageWidth: adImageView.frame.size.width)
        }
    }
    
    // MARK: - Depedency injection
    
    /// The model contains data used to populate the view.
    public var model: WishListViewModel? {
        didSet {
            priceLabel.text = String(repeating: " ", count: 2) + "\(model?.priceLabel ?? "")" + String(repeating: " ", count: 2)
            statusLabel.title = model?.statusLabel ?? ""
            recentUpdateLabel.text = model?.recentUpdateLabel
            locationLabel.text = model?.locationLabel
            titleLabel.text = model?.title
            accessibilityLabel = model?.accessibilityLabel
        }
    }
    
    // MARK: - Public
    
    /// Loads the image for the `model` if imagePath is set
    public func loadImage() {
        guard let dataSource = dataSource, let model = model, let _ = model.imagePath else {
            loadingColor = .clear
            adImageView.image = WishListViewCell.defaultImage
            return
        }
        
        adImageView.backgroundColor = loadingColor
        
        dataSource.wishListViewCell(self, loadImageForModel: model, imageWidth: adImageView.frame.size.width) { [weak self] image in
            self?.adImageView.backgroundColor = .clear
            
            if let image = image {
                self?.adImageView.image = image
            } else {
                self?.adImageView.image = WishListViewCell.defaultImage
            }
        }
    }
}
