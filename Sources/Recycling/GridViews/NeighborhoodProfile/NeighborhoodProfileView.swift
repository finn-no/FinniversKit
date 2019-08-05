//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol NeighborhoodProfileViewDelegate: AnyObject {
    func neighborhoodProfileViewDidSelectExplore(_ view: NeighborhoodProfileView)
}

public final class NeighborhoodProfileView: UIView {
    private static let cellWidth: CGFloat = 204
    private static var minimumCellHeight: CGFloat { return cellWidth }

    // MARK: - Public properties

    public weak var delegate: NeighborhoodProfileViewDelegate?

    public var title = "" {
        didSet {
            headerView.title = title
        }
    }

    public var buttonTitle = "" {
        didSet {
            headerView.buttonTitle = buttonTitle
        }
    }

    // MARK: - Private properties

    private lazy var headerView: NeighborhoodProfileHeaderView = {
        let view = NeighborhoodProfileHeaderView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ice
        collectionView.contentInset = UIEdgeInsets(top: 0, left: .mediumSpacing, bottom: .mediumSpacing, right: .mediumSpacing)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NeighborhoodProfileViewCell.self)
        return collectionView
    }()

    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 10
        return layout
    }()

    private lazy var collectionViewHeight = collectionView.heightAnchor.constraint(
        equalToConstant: NeighborhoodProfileView.minimumCellHeight + .mediumLargeSpacing
    )

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Public

    public func reloadData() {
        collectionView.reloadData()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .ice

        addSubview(headerView)
        addSubview(collectionView)

        let verticalSpacing: CGFloat = 20

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor, constant: verticalSpacing),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: verticalSpacing),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionViewHeight,

            bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: verticalSpacing),
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension NeighborhoodProfileView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(NeighborhoodProfileViewCell.self, for: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NeighborhoodProfileView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: NeighborhoodProfileView.cellWidth, height: NeighborhoodProfileView.minimumCellHeight)
    }
}

// MARK: - NeighborhoodProfileHeaderViewDelegate

extension NeighborhoodProfileView: NeighborhoodProfileHeaderViewDelegate {
    func neighborhoodProfileHeaderViewDidSelectButton(_ view: NeighborhoodProfileHeaderView) {
        delegate?.neighborhoodProfileViewDidSelectExplore(self)
    }
}
