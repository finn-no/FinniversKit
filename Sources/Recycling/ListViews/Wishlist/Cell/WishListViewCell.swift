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
    private static let cornerRadius: CGFloat = 4
    
    private lazy var adImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = WishListViewCell.cornerRadius
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var leftImageDetail: Label = {
        let label = Label(style: .title4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .licorice
        label.textColor = .milk
        label.textAlignment = .center
        label.layer.opacity = WishListViewCell.layerOpacity
        return label
    }()
    
    private lazy var rightImageDetail: Label = {
        let label = Label(style: .title4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .mint
        label.textAlignment = .center
        return label
    }()
    
    private lazy var leftSubtitleDetail: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .stone
        return label
    }()
    
    private lazy var rightSubtitleDetail: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .stone
        label.textAlignment = .right
        return label
    }()
    
    private lazy var subtitleContainer: UIStackView = {
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
        adImageView.addSubview(leftImageDetail)
        adImageView.addSubview(rightImageDetail)
        
        addSubview(subtitleContainer)
        subtitleContainer.addArrangedSubview(leftSubtitleDetail)
        subtitleContainer.addArrangedSubview(rightSubtitleDetail)
        
        addSubview(titleLabel)
        
        backgroundColor = .milk

        NSLayoutConstraint.activate([
            adImageView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            adImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            adImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.80),
            adImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95),
            
            leftImageDetail.leadingAnchor.constraint(equalTo: adImageView.leadingAnchor),
            leftImageDetail.bottomAnchor.constraint(equalTo: adImageView.bottomAnchor),
            leftImageDetail.heightAnchor.constraint(equalTo: adImageView.heightAnchor, multiplier: 0.15),
            leftImageDetail.widthAnchor.constraint(equalTo: adImageView.widthAnchor, multiplier: 0.25),
            
            rightImageDetail.trailingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: -.mediumLargeSpacing),
            rightImageDetail.bottomAnchor.constraint(equalTo: adImageView.bottomAnchor, constant: -.mediumSpacing),
            rightImageDetail.heightAnchor.constraint(equalTo: adImageView.heightAnchor, multiplier: 0.10),
            rightImageDetail.widthAnchor.constraint(equalTo: adImageView.widthAnchor, multiplier: 0.20),
            
            subtitleContainer.leadingAnchor.constraint(equalTo: adImageView.leadingAnchor),
            subtitleContainer.trailingAnchor.constraint(equalTo: adImageView.trailingAnchor),
            subtitleContainer.topAnchor.constraint(equalTo: adImageView.bottomAnchor, constant: .mediumSpacing),
            
            titleLabel.leadingAnchor.constraint(equalTo: subtitleContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: subtitleContainer.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: subtitleContainer.bottomAnchor),
        ])
    }
    
    public override func layoutSubviews() {
        let roundedCornerLayer = CAShapeLayer()
        roundedCornerLayer.bounds = rightImageDetail.frame
        roundedCornerLayer.position = rightImageDetail.center
        roundedCornerLayer.path = UIBezierPath(roundedRect: rightImageDetail.bounds, cornerRadius: WishListViewCell.cornerRadius * 2).cgPath
        rightImageDetail.layer.mask = roundedCornerLayer
        
        let roundedRightCornerLayer = CAShapeLayer()
        roundedRightCornerLayer.bounds = leftImageDetail.frame
        roundedRightCornerLayer.position = leftImageDetail.center
        roundedRightCornerLayer.path = UIBezierPath(roundedRect: leftImageDetail.bounds, byRoundingCorners: [UIRectCorner.topRight],
                                                    cornerRadii: CGSize(width: WishListViewCell.cornerRadius * 2,
                                                                        height: WishListViewCell.cornerRadius * 2)).cgPath
        leftImageDetail.layer.mask = roundedRightCornerLayer
    }
    
    // MARK: - Superclass Overrides
    
    override public func prepareForReuse() {
        adImageView.image = nil
        leftImageDetail.text = ""
        rightImageDetail.text = ""
        leftSubtitleDetail.text = ""
        rightSubtitleDetail.text = ""
        titleLabel.text = ""
        
        if let model = model {
            dataSource?.wishListViewCell(self, cancelLoadingImageForModel: model, imageWidth: adImageView.frame.size.width)
        }
    }
    
    // MARK: - Depedency injection
    
    /// The model contains data used to populate the view.
    public var model: WishListViewModel? {
        didSet {
            guard let model = model else { return }
            leftImageDetail.text = model.leftImageDetail
            rightImageDetail.text = model.rightImageDetail
            leftSubtitleDetail.text = model.leftSubtitleDetail
            rightSubtitleDetail.text = model.rightSubtitleDetail
            titleLabel.text = model.title
            accessibilityLabel = model.accessibilityLabel
        }
    }
    
    // MARK: - Public
    
    /// Loads the image for the `model` if imagePath is set
    public func loadImage() {
        if let model = model {
            loadImage(model: model)
        }
    }
    
    // MARK: - Private
    
    private func loadImage(model: WishListViewModel) {
        guard let dataSource = dataSource else {
            loadingColor = .clear
            adImageView.image = defaultImage
            return
        }
        
        adImageView.backgroundColor = loadingColor
        
        dataSource.wishListViewCell(self, loadImageForModel: model, imageWidth: adImageView.frame.size.width) { [weak self] image in
            self?.adImageView.backgroundColor = .clear
            
            if let image = image {
                self?.adImageView.image = image
            } else {
                self?.adImageView.image = self?.defaultImage
            }
        }
    }
    
    private var defaultImage: UIImage? {
        return UIImage(named: .noImage)
    }
}
