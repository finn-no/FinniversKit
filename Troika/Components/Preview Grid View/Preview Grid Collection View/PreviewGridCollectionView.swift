import UIKit

protocol PreviewGridCollectionViewDelegate: NSObjectProtocol {
    func didSelect(item: PreviewPresentable, in gridView: PreviewGridCollectionView)
}

class PreviewGridCollectionView: UIView {

    // Mark: - Internal properties

    // Have the collection view be private so nobody messes with it.
    private let collectionView = UICollectionView()
    private weak var delegate: PreviewGridCollectionViewDelegate?

    // Mark: - External properties

    // Mark: - Setup

    init(frame: CGRect = .zero, delegate: PreviewGridCollectionViewDelegate) {
        super.init(frame: frame)

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
    var previewPresentables: [PreviewPresentable] = [PreviewPresentable]() {
        didSet {
            collectionView.reloadData()
        }
    }
}
