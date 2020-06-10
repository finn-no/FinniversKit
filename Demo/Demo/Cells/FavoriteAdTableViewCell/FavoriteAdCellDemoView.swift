//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class FavoriteAdCellDemoView: UIView {
    private let viewModels = FavoriteAdsFactory.create()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteAdTableViewCell.self)
        tableView.separatorInset = .leadingInset(frame.width)
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITableViewDelegate

extension FavoriteAdCellDemoView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == (viewModels.count - 1)

        if isLastCell {
            cell.separatorInset = .leadingInset(frame.width)
        }

        if let cell = cell as? FavoriteAdTableViewCell {
            cell.loadImage()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension FavoriteAdCellDemoView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FavoriteAdTableViewCell.self, for: indexPath)
        cell.configure(with: viewModels[indexPath.row])
        cell.remoteImageViewDataSource = DemoRemoteImageViewDataSource.shared

        // Show a pretty color while we load the image
        let colors: [UIColor] = [.toothPaste, .mint, .banana, .salmon]
        cell.loadingColor = colors[indexPath.row % colors.count]

        return cell
    }
}
