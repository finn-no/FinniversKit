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

    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .milk
        view.rowHeight = AssetsDemoViewCell.size
        return view
    }()

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
        tableView.dataSource = self
        tableView.register(AssetsDemoViewCell.self)
    }
}

extension AssetsDemoView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(AssetsDemoViewCell.self, for: indexPath)
        let image = images[indexPath.row]
        cell.asset = image
        return cell
    }
}
