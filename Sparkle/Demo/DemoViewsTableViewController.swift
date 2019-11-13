//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import SparkleCommon

public class DemoViewsTableViewController: UITableViewController {
    private lazy var selectorTitleView: SelectorTitleView = {
        let titleView = SelectorTitleView(withAutoLayout: true)
        titleView.delegate = self
        return titleView
    }()

    private var bottomSheet: BottomSheet?

    private var indexAndValues = [String: [String]]()

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
            if let section = sections[safe: indexPath.section] {
                if let item = section.items[safe: indexPath.row] {
                    if let bottomSheet = item.viewController as? BottomSheet {
                        present(bottomSheet, animated: true)
                    } else {
                        present(item.viewController, animated: false)
                    }
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
        evaluateIndexAndValues()
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
            let sectionIndexColor: UIColor = .textPrimary
            self.tableView.sectionIndexColor = sectionIndexColor
            self.tableView.backgroundColor = .bgPrimary
            self.updateMoonButton()
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    private func evaluateIndexAndValues() {
        indexAndValues.removeAll()

        if let section = sections[safe: SparkleState.lastSelectedSection] {
            let names = section.items.sorted { $0.title < $1.title }.map { $0.title.capitalizingFirstLetter }
            for name in names {
                var values = [String]()
                if let existingValues = indexAndValues[name.firstCapitalizedLetter] {
                    values = existingValues
                }
                values.append(name)
                indexAndValues[name.firstCapitalizedLetter] = values
            }
        }
    }

    private func value(for indexPath: IndexPath) -> String {
        let realIndexPath = evaluateRealIndexPath(for: indexPath)
        if let section = sections[safe: realIndexPath.section] {
            if let item = section.items[safe: realIndexPath.row] {
                return item.title
            } else {
                return ""
            }
        } else {
            return ""
        }
    }

    private func evaluateRealIndexPath(for indexPath: IndexPath) -> IndexPath {
        var row = 0
        for sectionIndex in 0..<indexPath.section {
            if let section = sections[safe: sectionIndex] {
                let elementsInSection = indexAndValues[section.title.firstCapitalizedLetter]?.count ?? 0
                row += elementsInSection
            }
        }
        row += indexPath.row
        return IndexPath(row: row, section: SparkleState.lastSelectedSection)
    }

    override public func present(_ viewControllerToPresent: UIViewController, animated flag: Bool = true, completion: (() -> Void)? = nil) {
        if viewControllerToPresent.modalPresentationStyle == .pageSheet {
            viewControllerToPresent.modalPresentationStyle = .fullScreen
        }
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

// MARK: - UITableViewDelegate

extension DemoViewsTableViewController {
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return indexAndValues.keys.count
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitles = Array(indexAndValues.keys.sorted(by: <))
        if let values = indexAndValues[sectionTitles[section].firstCapitalizedLetter] {
            return values.count
        } else {
            return 0
        }
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = value(for: indexPath)
        cell.textLabel?.font = .bodyRegular
        cell.selectionStyle = .none
        cell.backgroundColor = .clear

        let cellTextColor: UIColor = .textPrimary
        cell.textLabel?.textColor = cellTextColor

        return cell
    }

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let realIndexPath = evaluateRealIndexPath(for: indexPath)
        SparkleState.lastSelectedIndexPath = realIndexPath
        if let section = sections[safe: SparkleState.lastSelectedSection] {
            if let item = section.items[safe: realIndexPath.row] {
                present(item.viewController, animated: true)
            }
        }
    }

    override public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let sectionTitles = Array(indexAndValues.keys.sorted(by: <))
        return sectionTitles
    }

    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitles = Array(indexAndValues.keys.sorted(by: <))
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

extension DemoViewsTableViewController: SelectorTitleViewDelegate {
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

extension DemoViewsTableViewController: BasicTableViewDelegate {
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
    var firstCapitalizedLetter: String {
        return String(prefix(1)).uppercased()
    }
}
