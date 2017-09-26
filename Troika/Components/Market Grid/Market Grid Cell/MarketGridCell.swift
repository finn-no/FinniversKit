import UIKit

public class MarketGridCell: UICollectionViewCell {
    
    // Mark: - Internal properties
    
    private static let titleLabelHeight: CGFloat = 20.0
    private static let titleLabelMargin: CGFloat = 8.0
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .t1
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()
    
    // Mark: - External properties
    
    public static var nonImageHeight: CGFloat {
        return titleLabelHeight + titleLabelMargin
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
        addSubview(titleLabel)
        imageView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    // Mark: - Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: MarketGridCell.titleLabelMargin).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: MarketGridCell.titleLabelHeight).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    // Mark: - Dependency injection
    
    public var presentable: MarketGridPresentable? {
        didSet {
            imageView.image = presentable?.image
            titleLabel.text = presentable?.title
        }
    }
}

