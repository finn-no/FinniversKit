import UIKit
import FinniversKit
import Combine

class ScrollableTabDemoView: UIView, Tweakable {

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Default") { self.sideScrollableView.configure(with: .default) },
        TweakingOption(title: "Reversed") { self.sideScrollableView.configure(with: .reversed) }
    ]

    // MARK: - Private properties

    private lazy var sideScrollableView: ScrollableTabView = {
        let view = ScrollableTabView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.backgroundColor = .bgPrimary
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.register(UITableViewCell.self)
        return tableView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        tweakingOptions.first?.action?()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(tableView)
        addSubview(sideScrollableView)

        NSLayoutConstraint.activate([
            sideScrollableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sideScrollableView.topAnchor.constraint(equalTo: topAnchor),
            sideScrollableView.trailingAnchor.constraint(equalTo: trailingAnchor),

            tableView.topAnchor.constraint(equalTo: sideScrollableView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: - ScrollableTabViewDelegate

extension ScrollableTabDemoView: ScrollableTabViewDelegate {
    func scrollableTabViewDidTapItem(_ sidescrollableView: ScrollableTabView, item: ScrollableTabViewModel.Item) {
        print("👉 Did select item: \(item.title) ")
    }
}

// MARK: - UITableViewDataSource

extension ScrollableTabDemoView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        cell.backgroundColor = .bgPrimary
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ScrollableTabDemoView: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        sideScrollableView.updateShadow(using: scrollView)
    }
}

// MARK: - Private extensions

private extension ScrollableTabViewModel {
    static var `default`: Self {
        self.init(selectedIdentifier: "Alle", items: .defaultItems)
    }

    static var reversed: Self {
        self.init(items: .defaultItems.reversed())
    }
}

private extension Array where Element == ScrollableTabViewModel.Item {
    static var defaultItems: [ScrollableTabViewModel.Item] {
        [
            .create(title: "Alle"),
            .create(title: "Aktiv (3)"),
            .create(title: "Påbegynte (17)"),
            .create(title: "Avvist (2)"),
            .create(title: "Lorem ipsum (42)")
        ]
    }
}
private extension ScrollableTabViewModel.Item {
    static func create(title: String) -> Self {
        self.init(identifier: title, title: title)
    }
}
