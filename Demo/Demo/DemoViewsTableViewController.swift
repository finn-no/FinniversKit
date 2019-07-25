//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

// MARK: - DemoViewsTableViewController

class DemoViewsTableViewController: UITableViewController {
    lazy var selectorTitleView: SelectorTitleView = {
        let titleView = SelectorTitleView(withAutoLayout: true)
        titleView.delegate = self
        return titleView
    }()

    private var bottomSheet: BottomSheet?

    private var indexAndValues = [String: [String]]()

    init() {
        super.init(style: .grouped)

        NotificationCenter.default.addObserver(self, selector: #selector(userInterfaceStyleDidChange(_:)), name: .DidChangeUserInterfaceStyle, object: nil)
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

    @objc func userInterfaceStyleDidChange(_ userInterfaceStyle: UserInterfaceStyle) {
        updateColors()
        evaluateIndexAndValues()
        tableView.reloadData()
    }

    private func setup() {
        tableView.register(UITableViewCell.self)
        tableView.delegate = self
        tableView.separatorStyle = .none
        navigationItem.titleView = selectorTitleView
        selectorTitleView.title = Sections.title(for: State.lastSelectedSection).uppercased()
        updateColors()
    }

    private func updateMoonButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: State.currentUserInterfaceStyle.image, style: .done, target: self, action: #selector(moonTapped))
    }

    @objc private func moonTapped() {
        State.currentUserInterfaceStyle = State.currentUserInterfaceStyle == .light ? .dark : .light
        NotificationCenter.default.post(name: .DidChangeUserInterfaceStyle, object: nil)
    }

    private func updateColors() {
        let interfaceBackgroundColor: UIColor
        let sectionIndexColor: UIColor
        switch State.currentUserInterfaceStyle {
        case .light:
            interfaceBackgroundColor = .milk
            sectionIndexColor = .primaryBlue
        case .dark:
            interfaceBackgroundColor = .midnightBackground
            sectionIndexColor = .secondaryBlue
        }

        tableView.sectionIndexColor = sectionIndexColor
        tableView.backgroundColor = interfaceBackgroundColor
        selectorTitleView.updateColors()
        updateMoonButton()
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

        let cellTextColor: UIColor
        switch State.currentUserInterfaceStyle {
        case .light:
            cellTextColor = .licorice
        case .dark:
            cellTextColor = .milk
        }
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
            headerView.textLabel?.textColor = .midnightSectionHeader
            headerView.textLabel?.font = UIFont.captionStrong
        }
    }

    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
}

extension DemoViewsTableViewController: SelectorTitleViewDelegate {
    func selectorTitleViewDidSelectButton(_ selectorTitleView: SelectorTitleView) {
        let sections = Sections.items.map { $0.rawValue.uppercased() }
        let options = sections.map { TweakingOption(title: $0) }
        let tweakingController = TweakingOptionsTableViewController(options: options)
        tweakingController.selectedIndexPath = IndexPath(row: State.lastSelectedSection, section: 0)
        tweakingController.delegate = self
        bottomSheet = BottomSheet(rootViewController: tweakingController, draggableArea: .everything)
        if let controller = bottomSheet {
            present(controller, animated: true)
        }
    }
}

extension DemoViewsTableViewController: TweakingOptionsTableViewControllerDelegate {
    func tweakingOptionsTableViewController(_ tweakingOptionsTableViewController: TweakingOptionsTableViewController, didDismissWithIndexPath indexPath: IndexPath) {
        bottomSheet?.state = .dismissed
        State.lastSelectedSection = indexPath.row
        selectorTitleView.title = Sections.title(for: State.lastSelectedSection).uppercased()
        evaluateIndexAndValues()
        tableView.reloadData()
    }
}
