//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika

// MARK: - DemoViewsTableViewController

class DemoViewsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
}

// MARK: - UITableViewDelegate

extension DemoViewsTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TroikaViews.all.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let rawClassName = TroikaViews.all[indexPath.row].rawValue
        let formattedName = rawClassName.replacingOccurrences(of: "DemoView", with: "").capitalizingFirstLetter()
        cell.textLabel?.font = UIFont.title3
        cell.textLabel?.text = formattedName

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedView = TroikaViews.all[indexPath.row]
        present(selectedView.viewController(), animated: true)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}
