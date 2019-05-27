//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public final class IconCollectionView: UIView {
    private var viewModels = [IconCollectionViewModel]()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(IconCollectionViewCell.self)
        collectionView.backgroundColor = .milk
        collectionView.allowsSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = IconCollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    public func configure(with viewModels: [IconCollectionViewModel]) {
        self.viewModels = viewModels
        collectionView.reloadData()
    }

    private func setup() {
        backgroundColor = .milk
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }
}

// MARK: - UICollectionViewDataSource

extension IconCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(IconCollectionViewCell.self, for: indexPath)
        cell.configure(with: viewModels[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension IconCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = viewModels[indexPath.item]
        let width = UIDevice.isIPad()
            ? max(collectionView.frame.width / CGFloat(viewModels.count), viewModel.image.size.width * 2)
            : collectionView.frame.width / 2
        let height = IconCollectionViewCell.height(for: viewModel, withWidth: width)

        return CGSize(width: width, height: height)
    }
}
