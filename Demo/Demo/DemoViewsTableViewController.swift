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

    init() {
        super.init(style: .grouped)

        NotificationCenter.default.addObserver(self, selector: #selector(userInterfaceStyleDidChange(_:)), name: .DidChangeUserInterfaceStyle, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .DidChangeUserInterfaceStyle, object: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        tableView.reloadData()
    }

    private func setup() {
        tableView.register(UITableViewCell.self)
        tableView.delegate = self
        tableView.separatorStyle = .none
        navigationItem.titleView = selectorTitleView
        selectorTitleView.title = Sections.formattedName(for: State.lastSelectedSection).uppercased()
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
        switch State.currentUserInterfaceStyle {
        case .light:
            interfaceBackgroundColor = .milk
        case .dark:
            interfaceBackgroundColor = .midnightBackground
        }
        tableView.backgroundColor = interfaceBackgroundColor
        selectorTitleView.updateColors()
        updateMoonButton()
        setNeedsStatusBarAppearanceUpdate()
    }
}

// MARK: - UITableViewDelegate

extension DemoViewsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Sections.allCases[State.lastSelectedSection]
        return section.numberOfItems
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UITableViewCell.self, for: indexPath)
        let realIndexPath = IndexPath(row: indexPath.row, section: State.lastSelectedSection)
        cell.textLabel?.text = Sections.formattedName(for: realIndexPath)
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
        let realIndexPath = IndexPath(row: indexPath.row, section: State.lastSelectedSection)
        State.lastSelectedIndexPath = realIndexPath
        if let viewController = Sections.viewController(for: realIndexPath) {
            present(viewController, animated: true)
        }
    }
}

extension DemoViewsTableViewController: SelectorTitleViewDelegate {
    func selectorTitleViewDidSelectButton(_ selectorTitleView: SelectorTitleView) {
        let sections = Sections.allCases.map { $0.rawValue.uppercased() }
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
        selectorTitleView.title = Sections.formattedName(for: State.lastSelectedSection).uppercased()
        tableView.reloadData()
    }
}
