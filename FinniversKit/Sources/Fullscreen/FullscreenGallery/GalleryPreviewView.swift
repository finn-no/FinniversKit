//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit
import Warp

protocol GalleryPreviewViewDataSource: AnyObject {
    func galleryPreviewView(_: GalleryPreviewView, loadImageWithWidth width: CGFloat, imageIndex index: Int, dataCallback: @escaping (Int, UIImage?) -> Void)
}

protocol GalleryPreviewViewDelegate: AnyObject {
    func galleryPreviewView(_: GalleryPreviewView, selectedImageAtIndex index: Int)
}

class GalleryPreviewView: UIView {

    // MARK: - Public properties

    weak var dataSource: GalleryPreviewViewDataSource?
    weak var delegate: GalleryPreviewViewDelegate?

    var viewModel: FullscreenGalleryViewModel? {
        didSet {
            reloadData()
        }
    }

    // MARK: - Private properties

    private let cellSpacing: CGFloat = Warp.Spacing.spacing100

    private var images = [UIImage?]()
    private var newSuperviewSize: CGSize?
    private var selectedRow: Int?

    private lazy var cellSize: CGSize = {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return CGSize(width: 107, height: 71)
        default:
            return CGSize(width: 160, height: 120)
        }
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = cellSize

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GalleryPreviewCell.self)
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        return collectionView
    }()

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        clipsToBounds = false

        addSubview(collectionView)
        collectionView.fillInSuperview()

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: cellSize.height)
        ])

    }

    // MARK: - Public methods

    public func superviewWillTransition(to size: CGSize) {
        newSuperviewSize = size
        collectionView.reloadSections(IndexSet(integer: 0))
    }

    public func scrollToItem(atIndex index: Int, animated: Bool) {
        collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: animated)
    }

    public func addBorderToItem(atIndex index: Int) {
        if let previouslySelectedRow = selectedRow {
            guard let previousCell = collectionView.cellForItem(at: IndexPath(row: previouslySelectedRow, section: 0)) as? GalleryPreviewCell else {
                selectedRow = index
                collectionView.reloadData()
                return
            }
            previousCell.showBorder(false)
        }

        selectedRow = index
        guard let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? GalleryPreviewCell else {
            collectionView.reloadData()
            return
        }
        cell.showBorder(true)
    }

    // MARK: - Private methods

    private func reloadData() {
        let imageCount = viewModel?.imageUrls.count ?? 0
        images = [UIImage?](repeating: nil, count: imageCount)

        collectionView.reloadData()

        for counter in 0 ..< imageCount {
            dataSource?.galleryPreviewView(self, loadImageWithWidth: cellSize.width, imageIndex: counter, dataCallback: { [weak self] (index, image) in
                guard let self = self else { return }

                if index >= 0 && index < self.images.count {
                    self.images[index] = image
                }

                self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            })
        }
    }
}

extension GalleryPreviewView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(GalleryPreviewCell.self, for: indexPath)
        let image = images[safe: indexPath.row]

        cell.showBorder(indexPath.row == selectedRow)
        cell.configure(withImage: image)

        return cell
    }
}

extension GalleryPreviewView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.galleryPreviewView(self, selectedImageAtIndex: indexPath.row)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = cellSize.width * CGFloat(images.count)
        let totalSpacingWidth = cellSpacing * CGFloat(images.count - 1)
        let availableWidth = (newSuperviewSize?.width) ?? (collectionView.layer.frame.size.width)

        let inset = (availableWidth - CGFloat(totalCellWidth + totalSpacingWidth)) / 2

        if inset > 0 {
            return UIEdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset)
        } else {
            return .zero
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}
