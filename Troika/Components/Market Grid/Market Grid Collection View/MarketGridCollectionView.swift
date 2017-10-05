import UIKit

protocol MarketGridCollectionViewDataSource: NSObjectProtocol {
    var items: [MarketGridPresentable] { get }
}

protocol MarketGridCollectionViewDelegate: NSObjectProtocol {
    func didSelect(item: MarketGridPresentable, in gridView: MarketGridCollectionView)
}

public class MarketGridCollectionView: UIView {
    
    // Mark: - Internal properties
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
//    private weak var dataSource: MarketGridCollectionViewDataSource?
    private weak var delegate: MarketGridCollectionViewDelegate?
    
    // Mark: - External properties
    
    // Mark: - Setup
    
    init(frame: CGRect = .zero, dataSource: MarketGridCollectionViewDataSource, delegate: MarketGridCollectionViewDelegate) {
        super.init(frame: frame)
        
//        self.dataSource = dataSource
        self.delegate = delegate
        
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        collectionView.register(MarketGridCell.self)
        addSubview(collectionView)
    }
    
    // Mark: - Test
    
    // Mark: - Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    // Mark: - Dependency injection
    public var marketGridPresentables: [MarketGridPresentable] = [MarketGridPresentable]() {
        didSet {
            collectionView.reloadData()
        }
    }
}

extension MarketGridCollectionView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = ScreenSizeCategory(width: bounds.width)
        let itemSize = CGSize(width: bounds.width/screenWidth.itemsPerRow - screenWidth.sideMargins - screenWidth.interimSpacing, height: screenWidth.itemHeight)
        return itemSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let screenWidth = ScreenSizeCategory(width: bounds.width)
        return screenWidth.edgeInsets
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let screenWidth = ScreenSizeCategory(width: bounds.width)
        return screenWidth.lineSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let screenWidth = ScreenSizeCategory(width: bounds.width)
        return screenWidth.interimSpacing
    }
}

extension MarketGridCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return marketGridPresentables.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(MarketGridCell.self, for: indexPath)
        cell.presentable = marketGridPresentables[indexPath.row]
        return cell
    }
}
