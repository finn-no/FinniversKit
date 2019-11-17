import UIKit
import Bootstrap

public class SparkleViewController: UITableViewController {
    private lazy var selectorTitleView: SelectorTitleView = {
        let titleView = SelectorTitleView(withAutoLayout: true)
        titleView.delegate = self
        return titleView
    }()

    private var bottomSheet: BottomSheet?

    private var firstLetterAndItems = [String: [SparkleItem]]()
    private var sections: [SparkleSection]

    public init(sections: [SparkleSection]) {
        self.sections = sections
        super.init(style: .grouped)

        NotificationCenter.default.addObserver(self, selector: #selector(userInterfaceStyleDidChange), name: .didChangeUserInterfaceStyle, object: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("") }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
        evaluateIndexAndValues()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let indexPath = SparkleState.lastSelectedIndexPath {
            if let item = value(for: indexPath) {
                if let bottomSheet = item.viewController as? BottomSheet {
                    present(bottomSheet, animated: true)
                } else {
                    present(item.viewController, animated: false)
                }
            }
        }
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            #if swift(>=5.1)
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                userInterfaceStyleDidChange()
            }
            #endif
        }
    }

    @objc private func userInterfaceStyleDidChange() {
        updateColors(animated: true)
        tableView.reloadData()
    }

    private func setup() {
        tableView.register(UITableViewCell.self)
        tableView.delegate = self
        tableView.separatorStyle = .none
        navigationItem.titleView = selectorTitleView

        let section = sections[safe: SparkleState.lastSelectedSection]
        selectorTitleView.title = section?.title.uppercased()
        updateColors(animated: false)
    }

    private func updateMoonButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: SparkleState.currentUserInterfaceStyle(for: traitCollection).image, style: .done, target: self, action: #selector(moonTapped(sender:forEvent:)))
        return
    }

    @objc private func moonTapped(sender: AnyObject, forEvent event: UIEvent) {
        if event.allTouches?.first?.tapCount == 0 {
            // Long press
            SparkleState.setCurrentUserInterfaceStyle(nil, in: view.window)
        } else {
            SparkleState.setCurrentUserInterfaceStyle(SparkleState.currentUserInterfaceStyle(for: traitCollection) == .light ? .dark : .light, in: view.window)
        }
        NotificationCenter.default.post(name: .didChangeUserInterfaceStyle, object: nil)

        if #available(iOS 13.0, *) {
        } else {
            //Need to shutdown the app to make this work before dynamic colors were available
            let alertController = UIAlertController(title: "Restart", message: "This requires a restart of the app", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                exit(0)
            }))
            alertController.addAction(UIAlertAction(title: "Later", style: .cancel, handler: nil))
            present(alertController, animated: true)
        }
    }

    private func updateColors(animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.tableView.sectionIndexColor = .textAction
            self.tableView.backgroundColor = .bgPrimary
            self.selectorTitleView.backgroundColor = .bgPrimary
            self.updateMoonButton()
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    private func evaluateIndexAndValues() {
        firstLetterAndItems.removeAll()

        if let section = sections[safe: SparkleState.lastSelectedSection] {
            let items = section.items.sorted { $0.title < $1.title }
            for item in items {
                var values = [SparkleItem]()
                if let existingValues = firstLetterAndItems[item.title.firstCapitalizedLetter()] {
                    values = existingValues
                }
                values.append(item)
                firstLetterAndItems[item.title.firstCapitalizedLetter()] = values
            }
        }
    }

    private func value(for indexPath: IndexPath) -> SparkleItem? {
        let sectionTitles = Array(firstLetterAndItems.keys.sorted(by: <))
        let section = sectionTitles[indexPath.section]
        let items = firstLetterAndItems[section.firstCapitalizedLetter()]
        return items?[indexPath.row]
    }

    override public func present(_ viewControllerToPresent: UIViewController, animated flag: Bool = true, completion: (() -> Void)? = nil) {
        if viewControllerToPresent.modalPresentationStyle == .pageSheet {
            viewControllerToPresent.modalPresentationStyle = .fullScreen
        }
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

// MARK: - UITableViewDelegate

extension SparkleViewController {
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return firstLetterAndItems.keys.count
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitles = Array(firstLetterAndItems.keys.sorted(by: <))
        if let values = firstLetterAndItems[sectionTitles[section].firstCapitalizedLetter()] {
            return values.count
        } else {
            return 0
        }
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UITableViewCell.self, for: indexPath)
        let item = value(for: indexPath)
        cell.textLabel?.text = item?.title.capitalizingFirstLetter
        cell.textLabel?.font = .bodyRegular
        cell.selectionStyle = .none
        cell.backgroundColor = .clear

        let cellTextColor: UIColor = .textPrimary
        cell.textLabel?.textColor = cellTextColor

        return cell
    }

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        SparkleState.lastSelectedIndexPath = indexPath
        if let item = value(for: indexPath) {
            present(item.viewController, animated: true)
        }
    }

    override public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let sectionTitles = Array(firstLetterAndItems.keys.sorted(by: <))
        return sectionTitles
    }

    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitles = Array(firstLetterAndItems.keys.sorted(by: <))
        return sectionTitles[section]
    }

    override public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .textDisabled //DARK
            headerView.textLabel?.font = UIFont.captionStrong
        }
    }

    override public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
}

extension SparkleViewController: SelectorTitleViewDelegate {
    public func selectorTitleViewDidSelectButton(_ selectorTitleView: SelectorTitleView) {
        let items = sections.map { BasicTableViewItem(title: $0.title.uppercased()) }
        let sectionsTableView = BasicTableView(items: items)
        sectionsTableView.selectedIndexPath = IndexPath(row: SparkleState.lastSelectedSection, section: 0)
        sectionsTableView.delegate = self
        bottomSheet = BottomSheet(view: sectionsTableView, draggableArea: .everything)
        if let controller = bottomSheet {
            present(controller, animated: true)
        }
    }
}

extension SparkleViewController: BasicTableViewDelegate {
    public func basicTableView(_ basicTableView: BasicTableView, didSelectItemAtIndex index: Int) {
        SparkleState.lastSelectedSection = index
        if let section = sections[safe: SparkleState.lastSelectedSection] {
            selectorTitleView.title = section.title.uppercased()
            evaluateIndexAndValues()
            tableView.reloadData()
            bottomSheet?.state = .dismissed
        }
    }
}

extension String {
    func firstCapitalizedLetter() -> String {
        return String(prefix(1)).uppercased()
    }
}
