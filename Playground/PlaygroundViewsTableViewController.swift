//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

let views = [
    ButtonPlayground(),
    LabelPlayground(),
    LoginViewPlayground(),
    MarketGridViewPlayground(),
    MarketGridCellPlayground(),
    PreviewGridViewPlayground(),
    PreviewGridCellPlayground(),
    RibbonPlayground(),
    TextFieldPlayground(),
    ToastPlayground(),
    EmptyViewPlayground(),
]

let viewNames: [String] = [
    "ButtonPlayground",
    "LabelPlayground",
    "LoginViewPlayground",
    "MarketGridViewPlayground",
    "MarketGridCellPlayground",
    "PreviewGridViewPlayground",
    "PreviewGridCellPlayground",
    "RibbonPlayground",
    "TextFieldPlayground",
    "ToastPlayground",
    "EmptyViewPlayground",
]

class PlaygroundViewsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        tableView.delegate = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return views.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewNames[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedView = views[indexPath.row]

        switch selectedView {
        case is ButtonPlayground:
            typealias View = ButtonPlayground
            present(ViewController<View>(), animated: true, completion: nil)
        case is LabelPlayground:
            typealias View = LabelPlayground
            present(ViewController<View>(), animated: true, completion: nil)
        case is LoginViewPlayground:
            typealias View = LoginViewPlayground
            present(ViewController<View>(), animated: true, completion: nil)
        case is MarketGridViewPlayground:
            typealias View = MarketGridViewPlayground
            present(ViewController<View>(), animated: true, completion: nil)
        case is MarketGridCellPlayground:
            typealias View = MarketGridCellPlayground
            present(ViewController<View>(), animated: true, completion: nil)
        case is PreviewGridViewPlayground:
            typealias View = PreviewGridViewPlayground
            present(ViewController<View>(), animated: true, completion: nil)
        case is PreviewGridCellPlayground:
            typealias View = PreviewGridCellPlayground
            present(ViewController<View>(), animated: true, completion: nil)
        case is RibbonPlayground:
            typealias View = RibbonPlayground
            present(ViewController<View>(), animated: true, completion: nil)
        case is TextFieldPlayground:
            typealias View = TextFieldPlayground
            present(ViewController<View>(), animated: true, completion: nil)
        case is ToastPlayground:
            typealias View = ToastPlayground
            present(ViewController<View>(), animated: true, completion: nil)
        case is EmptyViewPlayground:
            typealias View = EmptyViewPlayground
            present(ViewController<View>(), animated: true, completion: nil)
        default:
            break
        }
    }
}
