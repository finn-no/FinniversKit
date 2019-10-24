//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol PrimingViewDelegate: AnyObject {
    func primingViewDidSelectButton(_ view: PrimingView)
}

public final class PrimingView: UIView {
    // MARK: - Public properties

    public weak var delegate: PrimingViewDelegate?

    // MARK: - Private properties

    private var rows = [PrimingViewModel.Row]()

    private lazy var headerView = PrimingHeaderView(withAutoLayout: true)

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .bgPrimary
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        tableView.register(PrimingTableViewCell.self)
        return tableView
    }()

    private lazy var footerView: PrimingFooterView = {
        let view = PrimingFooterView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    public func configure(with viewModel: PrimingViewModel) {
        rows = viewModel.rows
        headerView.heading = viewModel.heading
        footerView.buttonTitle = viewModel.buttonTitle
        tableView.reloadData()
    }

    private func setup() {
        backgroundColor = .bgPrimary

        addSubview(tableView)
        addSubview(headerView)
        addSubview(footerView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor, constant: .largeSpacing),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),

            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),

            footerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - PrimingFooterViewDelegate

extension PrimingView: PrimingFooterViewDelegate {
    func primingFooterViewDidSelectButton(_ view: PrimingFooterView) {
        delegate?.primingViewDidSelectButton(self)
    }
}

// MARK: - UITableViewDataSource

extension PrimingView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PrimingTableViewCell.self, for: indexPath)
        let row = rows[indexPath.row]
        cell.configure(withIcon: row.icon, title: row.title, detailText: row.detailText)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PrimingView: UITableViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.updateShadow(using: scrollView)
        footerView.updateShadow(using: scrollView)
    }
}
