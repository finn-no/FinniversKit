//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

private struct ViewModel: SelectableTableViewCellViewModel {
    let title: String
    let subtitle: String?
    let detailText: String? = nil
    let hasChevron: Bool = false
    var isSelected: Bool
}

class CheckboxSubtitleCellDemoView: UIView {
    private var viewModels = [
        ViewModel(title: "Hagemøbler", subtitle: "For deg som liker noe godt å sitte i når du gjør deg flid med grillen", isSelected: false),
        ViewModel(title: "Kattepuser", subtitle: "Fin-fine kattunger", isSelected: true),
        ViewModel(title: "Mac Mini Pro", subtitle: "En noe kraftigere Mac Mini", isSelected: true),
        ViewModel(title: "Mac Pro Mini", subtitle: "En noe svakere Mac Pro", isSelected: false),
        ViewModel(title: "Mac Pro Max", subtitle: "Gir deg stødige 140fps i Minecraft", isSelected: false)
        ]

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 48
        tableView.register(CheckboxTableViewCell.self)
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

extension CheckboxSubtitleCellDemoView: UITableViewDelegate {
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

        guard let cell = tableView.cellForRow(at: indexPath) as? CheckboxTableViewCell else { return }
        var viewModel = viewModels[indexPath.row]
        viewModel.isSelected = !viewModel.isSelected
        viewModels[indexPath.row] = viewModel
        cell.animateSelection(isSelected: viewModel.isSelected)
    }
}

extension CheckboxSubtitleCellDemoView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(CheckboxTableViewCell.self, for: indexPath)
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
}
