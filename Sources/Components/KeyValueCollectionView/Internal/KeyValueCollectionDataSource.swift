import UIKit

class KeyValueCollectionDataSource: NSObject {
    var keyValuePairs: [KeyValuePair] = [] {
        didSet {
            if #available(iOS 13.0, *) {
                updateSnapshotIfAvailable()
            } else {
                collectionView?.reloadData()
            }
        }
    }

    // MARK: - Private variables

    private weak var collectionView: UICollectionView?
    private var diffableDataSource: Any?

    // MARK: - Internal methods

    func configure(for collectionView: UICollectionView) {
        if #available(iOS 13.0, *) {
            configureDiffableDataSource(for: collectionView)
        } else {
            collectionView.dataSource = self
        }

        self.collectionView = collectionView
    }

    func item(for indexPath: IndexPath) -> KeyValuePair {
        return keyValuePairs[indexPath.row]
    }

    // MARK: - Private methods

    @available(iOS 13.0, *)
    private func configureDiffableDataSource(for collectionView: UICollectionView) {
        let dataSource = UICollectionViewDiffableDataSource<Int, KeyValuePair>(
            collectionView: collectionView,
            cellProvider: collectionView(_:cellForItemAt:with:)
        )
        diffableDataSource = dataSource
    }

    private func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, with item: KeyValuePair
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeue(KeyValueCollectionViewCell.self, for: indexPath)
        cell.configure(title: item.title, value: item.value)

        return cell
    }

    @available(iOS 13.0, *)
    private func updateSnapshotIfAvailable() {
        guard let dataSource = diffableDataSource as? UICollectionViewDiffableDataSource<Int, KeyValuePair> else {
            return
        }

        var snapshot = NSDiffableDataSourceSnapshot<Int, KeyValuePair>()
        snapshot.appendSections([0])
        snapshot.appendItems(keyValuePairs)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// - MARK: UICollectionViewDataSource
extension KeyValueCollectionDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        keyValuePairs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = keyValuePairs[indexPath.row]
        return self.collectionView(collectionView, cellForItemAt: indexPath, with: item)
    }
}
