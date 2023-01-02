//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class DemoViewsTableViewController: UITableViewController {
    private lazy var selectorTitleView: SelectorTitleView = {
        let titleView = SelectorTitleView(withAutoLayout: true)
        titleView.delegate = self
        return titleView
    }()

    private var bottomSheet: BottomSheet?

    private var indexAndValues = [String: [String]]()

    init() {
        super.init(style: .grouped)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        evaluateIndexAndValues()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let indexPath = State.lastSelectedIndexPath {
            if let viewController = Sections.viewController(for: indexPath) {
                if let bottomSheet = viewController as? BottomSheet {
                    present(bottomSheet, animated: true)
                } else {
                    present(viewController, animated: false)
                }
            }
        }
    }

    private func setup() {
        tableView.register(UITableViewCell.self)
        tableView.delegate = self
        tableView.separatorStyle = .none
        navigationItem.titleView = selectorTitleView
        selectorTitleView.title = Sections.title(for: State.lastSelectedSection).uppercased()

        tableView.sectionIndexColor = .textAction
        tableView.backgroundColor = .bgPrimary
        setNeedsStatusBarAppearanceUpdate()
    }

    private func evaluateIndexAndValues() {
        indexAndValues.removeAll()

        for name in Sections.formattedNames(for: State.lastSelectedSection) {
            let firstLetter = String(name.prefix(1))
            var values = [String]()
            if let existingValues = indexAndValues[firstLetter] {
                values = existingValues
            }
            values.append(name)
            indexAndValues[firstLetter] = values
        }
    }

    private func value(for indexPath: IndexPath) -> String {
        let index = sections[indexPath.section]
        if let values = indexAndValues[index] {
            return values[indexPath.row]
        } else {
            return ""
        }
    }

    private func evaluateRealIndexPath(for indexPath: IndexPath) -> IndexPath {
        var row = 0
        for sectionIndex in 0..<indexPath.section {
            let key = sections[sectionIndex]
            let elementsInSection = indexAndValues[key]?.count ?? 0
            row += elementsInSection
        }
        row += indexPath.row
        return IndexPath(row: row, section: State.lastSelectedSection)
    }

    private var sections: [String] {
        return Array(indexAndValues.keys.sorted(by: <))
    }

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool = true, completion: (() -> Void)? = nil) {
        if viewControllerToPresent.modalPresentationStyle == .pageSheet {
            viewControllerToPresent.modalPresentationStyle = .fullScreen
        }
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

// MARK: - UITableViewDelegate

extension DemoViewsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = sections[section]
        if let values = indexAndValues[index] {
            return values.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = value(for: indexPath)
        cell.textLabel?.font = .bodyRegular
        cell.selectionStyle = .none
        cell.backgroundColor = .clear

        let cellTextColor: UIColor = .textPrimary
        cell.textLabel?.textColor = cellTextColor

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let realIndexPath = evaluateRealIndexPath(for: indexPath)
        State.lastSelectedIndexPath = realIndexPath
        if let viewController = Sections.viewController(for: realIndexPath) {
            present(viewController, animated: true)
        }
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .textDisabled // DARK
            headerView.textLabel?.font = UIFont.captionStrong
        }
    }

    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
}

// MARK: - SelectorTitleViewDelegate

extension DemoViewsTableViewController: SelectorTitleViewDelegate {
    func selectorTitleViewDidSelectButton(_ selectorTitleView: SelectorTitleView) {
        let items = Sections.items.map { BasicTableViewItem(title: $0.rawValue.uppercased()) }
        let sectionsTableView = BasicTableView(items: items)
        sectionsTableView.selectedIndexPath = IndexPath(row: State.lastSelectedSection, section: 0)
        sectionsTableView.delegate = self
        bottomSheet = BottomSheet(view: sectionsTableView, draggableArea: .everything)
        if let controller = bottomSheet {
            present(controller, animated: true)
        }
    }
}

// MARK: - BasicTableViewDelegate

extension DemoViewsTableViewController: BasicTableViewDelegate {
    func basicTableView(_ basicTableView: BasicTableView, didSelectItemAtIndex index: Int) {
        State.lastSelectedSection = index
        selectorTitleView.title = Sections.title(for: State.lastSelectedSection).uppercased()
        evaluateIndexAndValues()
        tableView.reloadData()
        bottomSheet?.state = .dismissed
    }
}
