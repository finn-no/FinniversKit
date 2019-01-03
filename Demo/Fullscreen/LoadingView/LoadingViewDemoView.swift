//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

private struct Option {
    var title: String
    var action: (() -> Void)
}

public class LoadingViewDemoView: UIView {
    private lazy var options: [Option] = {
        var options = [Option]()

        options.append(Option(title: "Simple show (hides after a second)", action: {
            LoadingView.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                LoadingView.hide()
            })
        }))

        options.append(Option(title: "Show with message (hides after a second)", action: {
            LoadingView.show(withMessage: "Hi there!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                LoadingView.hide()
            })
        }))

        options.append(Option(title: "Show success (hides after a second)", action: {
            LoadingView.showSuccess()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                LoadingView.hide()
            })
        }))

        options.append(Option(title: "Show success with message (hides after a second)", action: {
            LoadingView.showSuccess(withMessage: "Hi there!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                LoadingView.hide()
            })
        }))

        options.append(Option(title: "Full: Show w/ message, Success, Hides", action: {
            LoadingView.show(withMessage: "Hi there!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                LoadingView.showSuccess(withMessage: "It worked!")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    LoadingView.hide()
                })
            })
        }))

        options.append(Option(title: "throttling: show and hide right after", action: {
            LoadingView.show(withMessage: "Hi there!")
            LoadingView.hide()
        }))

        return options
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
        tableView.register(UITableViewCell.self)
    }
}

// MARK: - UITableViewDataSource

extension LoadingViewDemoView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UITableViewCell.self, for: indexPath)
        let option = options[indexPath.row]
        cell.textLabel?.text = option.title
        return cell
    }
}

// MARK: - UITableViewDelegate

extension LoadingViewDemoView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = options[indexPath.row]
        option.action()
    }
}
