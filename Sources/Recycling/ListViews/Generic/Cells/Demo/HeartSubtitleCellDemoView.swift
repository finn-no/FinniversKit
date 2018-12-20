//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

private struct ViewModel: SelectableTableViewCellViewModel {
    let title: String
    let subtitle: String?
    let hasChevron: Bool = false
    var isSelected: Bool
}

class HeartSubtitleCellDemoView: UIView {
    private var viewModels = [
        ViewModel(title: "Mine funn", subtitle: "Ingen annonser", isSelected: false),
        ViewModel(title: "Brettspill", subtitle: "2 annonser", isSelected: true),
        ViewModel(title: "#likebrabrukt", subtitle: "16 annonser", isSelected: true),
        ViewModel(title: "Verktøy", subtitle: "6 annonser", isSelected: false),
        ViewModel(title: "Kattunger", subtitle: "Ingen annonser", isSelected: false)
    ]

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 48
        tableView.register(HeartTableViewCell.self)
        tableView.separatorInset = .leadingInset(frame.width)
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HeartSubtitleCellDemoView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == (viewModels.count - 1)
        if isLastCell {
            cell.separatorInset = .leadingInset(frame.width)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if #available(iOS 10.0, *) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }

        guard let cell = tableView.cellForRow(at: indexPath) as? HeartTableViewCell else { return }
        var viewModel = viewModels[indexPath.row]
        viewModel.isSelected = !viewModel.isSelected
        viewModels[indexPath.row] = viewModel
        cell.animateSelection(isSelected: viewModel.isSelected)
    }
}

extension HeartSubtitleCellDemoView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(HeartTableViewCell.self, for: indexPath)
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
}
