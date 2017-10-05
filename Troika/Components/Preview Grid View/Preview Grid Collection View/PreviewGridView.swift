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
        collectionView.isPrefetchingEnabled = false
        return collectionView
    }()

    private weak var delegate: PreviewGridViewDelegate?
    private weak var dataSource: PreviewGridViewDataSource?

    // Mark: - External properties

    public var headerView: UIView? {
        willSet {
            headerView?.removeFromSuperview()
        }
        didSet {
            guard let headerView = headerView else {
                return // View was removed
            }

            collectionView.addSubview(headerView)
            collectionView.contentInset.top = headerView.frame.size.height
            headerView.frame.origin.y = -headerView.frame.size.height
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
        let colors: [UIColor] = [.red, .blue, .yellow] // TODO: Use Troika colors
        let color = colors[indexPath.row % 3]

        let presentable = previewPresentables[indexPath.row]
        cell.loadingColor = color
        cell.dataSource = self
        cell.presentable = presentable

        return cell
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
