import UIKit

public class RecentlySavedShelfCell: UICollectionViewCell {
    private lazy var backgroundContentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .red
        view.widthAnchor.constraint(equalToConstant: 64).isActive = true
        view.heightAnchor.constraint(equalToConstant: 64).isActive = true
        view.layer.cornerRadius = 32
        
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
        contentView.addSubview(backgroundContentView)
        backgroundContentView.fillInSuperview()
    }
}
