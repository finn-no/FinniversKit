import UIKit

protocol GridCollectionViewDataSource: NSObjectProtocol {
    var items: [GridPresentable] { get }
}

protocol GridCollectionViewDelegate: NSObjectProtocol {
    func didSelect(item: GridPresentable, in gridView: GridCollectionView)
}

class GridCollectionView: UIView {

    // Mark: - Internal properties

    // Have the collection view be private so nobody messes with it.
    private let collectionView = UICollectionView()
    private weak var dataSource: GridCollectionViewDataSource?
    private weak var delegate: GridCollectionViewDelegate?

    // Mark: - External properties

    // Mark: - Setup

    init(frame: CGRect = .zero, dataSource: GridCollectionViewDataSource, delegate: GridCollectionViewDelegate) {
        super.init(frame: frame)

        self.dataSource = dataSource
        self.delegate = delegate

        setup()
    }

    private override init(frame: CGRect) {
        super.init(frame: frame)
    }

    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setup() {

    }

    // Mark: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        // Add custom subviews
        // Layout your custom views
    }

    // Mark: - Dependency injection

}
