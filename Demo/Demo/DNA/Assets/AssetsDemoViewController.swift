//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class AssetsDemoViewController: BaseDemoViewController<UIView> {
    private var images = FinniversImageAsset.imageNames {
        didSet {
            tableView.reloadData()
        }
    }

    public override func viewDidLoad() {
        setup()
    }

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.searchBar.placeholder = "Få orden på rotet 🧹"
        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .bgPrimary
        return view
    }()

    private func setup() {
        title = "Assets"
        navigationItem.searchController = searchController

        view.addSubview(tableView)
        tableView.fillInSuperview()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self)
    }
}

extension AssetsDemoViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UITableViewCell.self, for: indexPath)
        let image = images[indexPath.row]
        cell.imageView?.image = UIImage(named: image)
        cell.textLabel?.text = image.rawValue
        cell.textLabel?.font = .body
        return cell
    }
}

extension AssetsDemoViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else {
            return
        }

        let lowercasedQuery = query.lowercased()

        images = !lowercasedQuery.isEmpty
            ? FinniversImageAsset.imageNames.filter { $0.rawValue.lowercased().contains(lowercasedQuery) }
            : FinniversImageAsset.imageNames
    }
}
