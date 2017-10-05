import UIKit

public protocol MarketGridCollectionViewDelegate: NSObjectProtocol {
    func didSelect(item: MarketGridPresentable, in gridView: MarketGridCollectionView)
    func contentSizeDidChange(newSize: CGSize, in gridView: MarketGridCollectionView)
}

public class MarketGridCollectionView: UIView {
    
    // Mark: - Internal properties
    
    @objc private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    private weak var delegate: MarketGridCollectionViewDelegate?
    
    // Mark: - External properties
    
    // Mark: - Setup
    
    public init(frame: CGRect = .zero, delegate: MarketGridCollectionViewDelegate) {
        super.init(frame: frame)
        
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

        addObserver(self, forKeyPath: "collectionView.contentSize", options: .new, context: nil)
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

    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "collectionView.contentSize" {
            delegate?.contentSizeDidChange(newSize: collectionView.contentSize, in: self)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

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

// MARK: - UICollectionViewDataSource

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

// MARK: - UICollectionViewDelegate

extension MarketGridCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = marketGridPresentables[indexPath.row]
        delegate?.didSelect(item: item, in: self)
    }
}
