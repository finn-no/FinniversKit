//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol NeighborhoodProfileViewDelegate: AnyObject {
    func neighborhoodProfileView(_ view: NeighborhoodProfileView, didSelectUrl: URL?)
}

public final class NeighborhoodProfileView: UIView {
    private static let cellWidth: CGFloat = 204
    private static var minimumCellHeight: CGFloat { return cellWidth }

    // MARK: - Public properties

    public weak var delegate: NeighborhoodProfileViewDelegate?

    public var title = "" {
        didSet { headerView.title = title }
    }

    public var buttonTitle = "" {
        didSet { headerView.buttonTitle = buttonTitle }
    }

    // MARK: - Private properties

    private var viewModel = NeighborhoodProfileViewModel(title: "", readMoreLink: nil, cards: [])

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
        collectionView.dataSource = self
        collectionView.register(NeighborhoodProfileInfoViewCell.self)
        collectionView.register(NeighborhoodProfileButtonViewCell.self)
        return collectionView
    }()

    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(
            width: NeighborhoodProfileView.cellWidth,
            height: NeighborhoodProfileView.minimumCellHeight
        )
        return layout
    }()

    private lazy var collectionViewHeightConstraint = collectionView.heightAnchor.constraint(
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

    public func configure(with viewModel: NeighborhoodProfileViewModel) {
        self.viewModel = viewModel

        let cellWidth = NeighborhoodProfileView.cellWidth
        let cellHeights = viewModel.cards.map({
            height(forCard: $0, width: cellWidth)
        })
        let maxCellHeight = cellHeights.max() ?? NeighborhoodProfileView.minimumCellHeight

        collectionViewLayout.itemSize = CGSize(width: cellWidth, height: maxCellHeight)
        collectionViewHeightConstraint.constant = maxCellHeight + .mediumLargeSpacing

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
            collectionViewHeightConstraint,

            bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: verticalSpacing),
        ])
    }

    private func height(forCard card: NeighborhoodProfileViewModel.Card, width: CGFloat) -> CGFloat {
        switch card {
        case let .info(content, rows):
            return NeighborhoodProfileInfoViewCell.height(forContent: content, rows: rows, width: width)
        case let .button(content):
            return NeighborhoodProfileButtonViewCell.height(forContent: content, width: width)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension NeighborhoodProfileView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cards.count
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reusableCell: UICollectionViewCell
        let card = viewModel.cards[indexPath.item]

        switch card {
        case let .info(content, rows):
            let cell = collectionView.dequeue(NeighborhoodProfileInfoViewCell.self, for: indexPath)
            cell.delegate = self
            cell.configure(withContent: content, rows: rows)
            reusableCell = cell
        case let .button(content):
            let cell = collectionView.dequeue(NeighborhoodProfileButtonViewCell.self, for: indexPath)
            cell.delegate = self
            cell.configure(withContent: content)
            reusableCell = cell
        }

        return reusableCell
    }
}

// MARK: - NeighborhoodProfileHeaderViewDelegate

extension NeighborhoodProfileView: NeighborhoodProfileHeaderViewDelegate {
    func neighborhoodProfileHeaderViewDidSelectButton(_ view: NeighborhoodProfileHeaderView) {
        delegate?.neighborhoodProfileView(self, didSelectUrl: viewModel.readMoreLink?.url)
    }
}

// MARK: - NeighborhoodProfileInfoViewCellDelegate

extension NeighborhoodProfileView: NeighborhoodProfileInfoViewCellDelegate {
    func neighborhoodProfileInfoViewCellDidSelectLinkButton(_ view: NeighborhoodProfileInfoViewCell) {
        delegate?.neighborhoodProfileView(self, didSelectUrl: view.linkButtonUrl)
    }
}

// MARK: - NeighborhoodProfileButtonViewCellDelegate

extension NeighborhoodProfileView: NeighborhoodProfileButtonViewCellDelegate {
    func neighborhoodProfileButtonViewCellDidSelectLinkButton(_ view: NeighborhoodProfileButtonViewCell) {
        delegate?.neighborhoodProfileView(self, didSelectUrl: view.linkButtonUrl)
    }
}
