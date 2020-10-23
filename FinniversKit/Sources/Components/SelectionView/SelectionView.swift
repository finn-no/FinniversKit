//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol SelectionViewDelegate: AnyObject {
    func selectionView(_ view: SelectionView, didSelectOptionWithIdentifier selectedIdentifier: String)
}

public final class SelectionView: UIView {
    public static let rowHeight: CGFloat = 48.0

    // MARK: - Public properties

    public weak var delegate: SelectionViewDelegate?

    // MARK: - Private properties

    private let options: [SelectionOptionModel]
    private var selectedOptionIdentifier: String

    private lazy var tableView: UITableView = {
        let tableView = ContentSizedTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .bgPrimary
        tableView.rowHeight = SelectionView.rowHeight
        tableView.estimatedRowHeight = SelectionView.rowHeight
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.separatorColor = .clear
        tableView.register(SelectionOptionCell.self)
        return tableView
    }()

    // MARK: - Init

    public init(
        options: [SelectionOptionModel],
        selectedOptionIdentifier: String
    ) {
        self.options = options
        self.selectedOptionIdentifier = selectedOptionIdentifier
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }
}

// MARK: - UITableViewDataSource

extension SelectionView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = options[indexPath.row]
        let cell = tableView.dequeue(SelectionOptionCell.self, for: indexPath)

        cell.configure(withTitle: option.title, icon: option.icon)

        cell.isCheckmarkHidden = option.identifier != selectedOptionIdentifier

        return cell
    }
}

// MARK: - UITableViewDelegate

extension SelectionView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOptionIdentifier = options[indexPath.row].identifier

        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        delegate?.selectionView(self, didSelectOptionWithIdentifier: selectedOptionIdentifier)
    }
}
