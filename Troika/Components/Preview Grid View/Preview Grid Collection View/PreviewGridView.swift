import UIKit

public protocol PreviewGridViewDelegate: NSObjectProtocol {
    func didSelect(item: PreviewPresentable, in gridView: PreviewGridView)
}

public protocol PreviewGridViewDataSource: NSObjectProtocol {
    func loadImage(for url: URL, completion: @escaping ((UIImage?) -> ()))
}

public class PreviewGridView: UIView {

    // Mark: - Internal properties

    private lazy var collectionViewLayout: PreviewGridLayout = {
        return PreviewGridLayout(delegate: self)
    }()

    // Have the collection view be private so nobody messes with it.
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        return collectionView
    }()

    private weak var delegate: PreviewGridViewDelegate?
    private weak var dataSource: PreviewGridViewDataSource?

    // Mark: - External properties

    public var headerView: UIView? {
        willSet {
            headerView?.removeFromSuperview()
        }
    }

    // Mark: - Setup

    public init(frame: CGRect = .zero, delegate: PreviewGridViewDelegate, dataSource: PreviewGridViewDataSource) {
        super.init(frame: frame)

        self.delegate = delegate
        self.dataSource = dataSource

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
        collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: String(describing: PreviewCell.self))
        collectionView.register(PreviewGridHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: PreviewGridHeaderView.self))
        addSubview(collectionView)
    }

    // Mark: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }

    // Mark: - Dependency injection
    public var previewPresentables: [PreviewPresentable] = [PreviewPresentable]() {
        didSet {
            collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension PreviewGridView: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = previewPresentables[indexPath.row]
        delegate?.didSelect(item: item, in: self)
    }
}

// MARK: - UICollectionViewDataSource
extension PreviewGridView: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return previewPresentables.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PreviewCell.self), for: indexPath) as! PreviewCell

        // Show a pretty color while we load the image
        let colors: [UIColor] = [.toothPaste, .mint, .banana, .salmon]
        let color = colors[indexPath.row % 4]

        let presentable = previewPresentables[indexPath.row]
        cell.loadingColor = color
        cell.dataSource = self
        cell.presentable = presentable

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader, let headerView = headerView else {
            fatalError("Suplementary view of kind '\(kind)' not supported.")
        }

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: PreviewGridHeaderView.self), for: indexPath) as! PreviewGridHeaderView
        header.contentView = headerView

        return header
    }
}

// MARK: - PreviewCellDataSource
extension PreviewGridView: PreviewCellDataSource {

    public func loadImage(for url: URL, completion: @escaping ((UIImage?) -> ())) {
        dataSource?.loadImage(for: url, completion: completion)
    }
}

// MARK: - PreviewGridLayoutDelegate
extension PreviewGridView: PreviewGridLayoutDelegate {
    
    func heightForHeaderView(inCollectionView collectionView: UICollectionView) -> CGFloat? {
        return headerView?.frame.size.height
    }

    func imageHeightRatio(forItemAt indexPath: IndexPath, inCollectionView collectionView: UICollectionView) -> CGFloat {
        let presentable = previewPresentables[indexPath.row]

        guard presentable.imageSize != .zero, presentable.imageUrl != nil else {
            let defaultImageSize = CGSize(width: 104, height: 78)
            return defaultImageSize.height / defaultImageSize.width
        }

        return presentable.imageSize.height / presentable.imageSize.width
    }

    func itemNonImageHeight(forItemAt indexPath: IndexPath, inCollectionView collectionView: UICollectionView) -> CGFloat {
        return PreviewCell.nonImageHeight
    }
}
