//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

public protocol PaymentOptionsListViewDelegate: AnyObject {
    func paymentOptionsListView(_ view: PaymentOptionsListView, didSelectRowAt indexPath: IndexPath)
    func paymentOptionsListView(_ view: PaymentOptionsListView, didSelectButton button: UIButton)
}

public class PaymentOptionsListView: UIView {

    // MARK: Private properties

    private lazy var footerButtonView: FooterButtonView = {
        let view = FooterButtonView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private var totalSumView: OrderTotalSumView
    private var collapseView: CollapseView

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.register(PaymentOptionsListViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .bgPrimary
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 120
        return tableView
    }()

    private var items: [PaymentOptionsListViewModel]
    private var selectedIndexPath: IndexPath?

    // MARK: Public properties

    public weak var delegate: PaymentOptionsListViewDelegate?

    // MARK: Public functions

    public init(items: [PaymentOptionsListViewModel], totalSumViewTitle: String, collapseViewTitle: String, collapseViewExpandedTitle: String) {
        self.items = items
        self.totalSumView = OrderTotalSumView(title: totalSumViewTitle, totalSum: "", withAutoLayout: true)
        self.collapseView = CollapseView(collapsedTitle: collapseViewTitle, expandedTitle: collapseViewExpandedTitle,
                                         viewToPresentInExpandedState: nil, heightOfView: 0, withAutoLayout: true)
        super.init(frame: .zero)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    public func reloadData() {
        tableView.reloadData()
    }

    public func collapseViewReplacePresentedView(_ newView: UIView, _ height: CGFloat) {
        collapseView.replacePresentedView(newView, heightOfView: height)
    }

    public func updateTotalSumValue(_ newString: String) {
        totalSumView.totalSum = newString
    }

    public func updateFooterButtonTitle(_ newString: String) {
        footerButtonView.buttonTitle = newString
    }
}

// MARK: Private extension

private extension PaymentOptionsListView {
    func setup() {
        backgroundColor = .bgPrimary

        addSubview(footerButtonView)
        addSubview(totalSumView)
        addSubview(collapseView)
        addSubview(tableView)

        NSLayoutConstraint.activate([
            footerButtonView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            footerButtonView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            footerButtonView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            totalSumView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            totalSumView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            totalSumView.bottomAnchor.constraint(equalTo: footerButtonView.topAnchor, constant: -.largeSpacing),

            collapseView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collapseView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collapseView.bottomAnchor.constraint(equalTo: totalSumView.topAnchor, constant: -.largeSpacing),

            tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: collapseView.topAnchor),
        ])
    }
}

// MARK: UITableViewDataSource conformance

extension PaymentOptionsListView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = items[safe: indexPath.row] else { return UITableViewCell() }
        let cell = tableView.dequeue(PaymentOptionsListViewCell.self, for: indexPath)
        cell.selectionStyle = .none

        if indexPath.row == 0 {
            selectedIndexPath = indexPath
            cell.configure(with: item, indexPath: indexPath, isPreselected: true)
        } else {
            cell.configure(with: item, indexPath: indexPath)
        }

        if indexPath.row != (items.count - 1) {
            cell.showSeperator(true)
        }

        return cell
    }
}

// MARK: UITableViewDataSource conformance

extension PaymentOptionsListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.paymentOptionsListView(self, didSelectRowAt: indexPath)

        guard selectedIndexPath != nil else {
            selectedIndexPath = indexPath
            guard let cell = tableView.cellForRow(at: indexPath) as? PaymentOptionsListViewCell else { return }
            cell.showSelectionCircle(true)
            return
        }

        guard
            let previouslySelectedIndexPath = selectedIndexPath,
            let previouslySelectedCell = tableView.cellForRow(at: previouslySelectedIndexPath) as? PaymentOptionsListViewCell,
            let currentlySelectedCell = tableView.cellForRow(at: indexPath) as? PaymentOptionsListViewCell
        else { return }

        selectedIndexPath = indexPath
        previouslySelectedCell.showSelectionCircle(false)
        currentlySelectedCell.showSelectionCircle(true)
    }
}

// MARK: FooterButtonViewDelegate conformance

extension PaymentOptionsListView: FooterButtonViewDelegate {
    public func footerButtonView(_ view: FooterButtonView, didSelectButton button: UIButton) {
        delegate?.paymentOptionsListView(self, didSelectButton: button)
    }
}
