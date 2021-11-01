import UIKit

public class RecentlyFavoritedShelfCell: UICollectionViewCell {
    private lazy var backgroundContentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .red
        view.layer.cornerRadius = 20
        view.heightAnchor.constraint(equalToConstant: 150).isActive = true
        view.widthAnchor.constraint(equalToConstant: 140).isActive = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(backgroundContentView)
        backgroundContentView.fillInSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
