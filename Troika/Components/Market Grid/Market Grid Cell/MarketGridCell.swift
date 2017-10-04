import UIKit

public class MarketGridCell: UICollectionViewCell {
    
    // Mark: - Internal properties
    
    private static let titleLabelMargin: CGFloat = 8.0
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var externalLinkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "webview.png")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .t4
        label.textAlignment = .center
        label.textColor = .licorice
        return label
    }()
    
    // Mark: - External properties
    
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
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(externalLinkImageView)
        backgroundColor = .clear
    }
    
    // Mark: - Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: MarketGridCell.titleLabelMargin).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        externalLinkImageView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor).isActive = true
        externalLinkImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
    }
    
    // Mark: - Dependency injection
    
    public var presentable: MarketGridPresentable? {
        didSet {
            iconImageView.image = presentable?.iconImage
            titleLabel.text = presentable?.title
            if let presentable = presentable, presentable.showExternalLinkIcon {
                externalLinkImageView.isHidden = false
            } else {
                externalLinkImageView.isHidden = true
            }
        }
    }
}

