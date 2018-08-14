//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class AssetsDemoView: UIView {
    let images = FinniversImageAsset.imageNames

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let size = UIScreen.main.bounds.width / 5
        let spacing: CGFloat = 10
        layout.itemSize = CGSize(width: size, height: size * 2)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .milk
        return view
    }()

    private func setup() {
        addSubview(collectionView)
        collectionView.fillInSuperview()
        collectionView.dataSource = self
        collectionView.register(AssetsDemoViewCell.self)
    }
}

extension AssetsDemoView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(AssetsDemoViewCell.self, for: indexPath)
        let image = images[indexPath.row]
        cell.imageView.image = UIImage(named: image)
        cell.nameLabel.text = image.rawValue
        return cell
    }
}
