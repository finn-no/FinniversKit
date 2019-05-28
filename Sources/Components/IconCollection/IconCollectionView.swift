//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public final class IconCollectionView: UIView {
    private var viewModels = [IconCollectionViewModel]()

    private lazy var collectionView: UICollectionView = {
        let collectionView = CollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(IconCollectionViewCell.self)
        collectionView.backgroundColor = .milk
        collectionView.allowsSelection = false
        collectionView.isScrollEnabled = false
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = IconCollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.minimumLineSpacing = .mediumSpacing
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
        let width = cellWidth(forWidth: collectionView.frame.width, viewModel: viewModel)
        let height = IconCollectionViewCell.height(for: viewModel, withWidth: width)

        return CGSize(width: width, height: height)
    }

    private func cellWidth(forWidth width: CGFloat, viewModel: IconCollectionViewModel) -> CGFloat {
        let width = UIDevice.isIPad()
            ? max(width / CGFloat(viewModels.count), viewModel.image.size.width * 2)
            : width / 2
        return width
    }
}

// MARK: - Private types

private final class CollectionView: UICollectionView {
    override var intrinsicContentSize: CGSize {
        return contentSize
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
}
