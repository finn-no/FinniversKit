import UIKit

class KeyValueCollectionLayoutFactory {
    let useNewLayout: Bool = false

    public func createColumnLayout(numberOfColumns: Int) -> UICollectionViewLayout {
        if #available(iOS 13.0, *), useNewLayout {
            return createCompositionalLayout(numberOfColumns: numberOfColumns)
        } else {
            return ColumnBasedFlowLayout(numberOfColumns: numberOfColumns)
        }
    }

    @available(iOS 13.0, *)
    private func createCompositionalLayout(numberOfColumns: Int) -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / CGFloat(numberOfColumns)),
            heightDimension: .estimated(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: nil,
            top: .fixed(.mediumLargeSpacing),
            trailing: nil,
            bottom: .fixed(.mediumLargeSpacing)
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: numberOfColumns)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = .mediumLargeSpacing

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
