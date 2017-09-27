import UIKit

public protocol PreviewGridViewDelegate: NSObjectProtocol {
    func didSelect(item: PreviewPresentable, in gridView: PreviewGridView)
}

public class PreviewGridView: UIView {

    // Mark: - Internal properties

    // Have the collection view be private so nobody messes with it.
    private lazy var collectionViewLayout: PreviewGridLayout = {
        return PreviewGridLayout(delegate: self)
    }()

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

    // Mark: - External properties

    // Mark: - Setup

    public init(frame: CGRect = .zero, delegate: PreviewGridViewDelegate) {
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
            print(previewPresentables.count)
            collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension PreviewGridView: UICollectionViewDelegate {

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

        let presentable = previewPresentables[indexPath.row]
        cell.presentable = presentable

        return cell
    }
}

// MARK: - PreviewGridLayoutDelegate
extension PreviewGridView: PreviewGridLayoutDelegate {

    func imageHeightRatio(forItemAt indexPath: IndexPath, inCollectionView collectionView: UICollectionView) -> CGFloat {
        let presentable = previewPresentables[indexPath.row]

        guard let size = presentable.image?.size, size != .zero else {
            let defaultImageSize = CGSize(width: 104, height: 78)
            return defaultImageSize.height / defaultImageSize.width
        }

        return size.height / size.width
    }

    func itemNonImageHeight(forItemAt indexPath: IndexPath, inCollectionView collectionView: UICollectionView) -> CGFloat {
        return PreviewCell.nonImageHeight
    }
}
