//
//  Copyright © FINN AS. All rights reserved.
//

import FinniversKit

private struct ViewModel: SelectableTableViewCellViewModel {

    init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
    var title: String
    var subtitle: String?
    var detailText: String?
    var hasChevron: Bool = false
    var isSelected: Bool
}

class RadioButtonCellDemoView: UIView {
    private var viewModels = [
        ViewModel(title: "NRK1", isSelected: true),
        ViewModel(title: "NRK2", isSelected: false),
        ViewModel(title: "NRK3", isSelected: false),
        ViewModel(title: "Radio Hedmark og Oppland", isSelected: false)
    ]

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.register(RadioButtonTableViewCell.self)
        tableView.rowHeight = 48
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
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

extension RadioButtonCellDemoView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RadioButtonTableViewCell.self, for: indexPath)
        let model = viewModels[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}

extension RadioButtonCellDemoView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentIndex = indexPath.row

        for (index, model) in viewModels.enumerated() {
            var updatedModel = model
            updatedModel.isSelected = index == currentIndex && !model.isSelected
            let indexPath = IndexPath(row: index, section: indexPath.section)
            if let cell = tableView.cellForRow(at: indexPath) as? RadioButtonTableViewCell, updatedModel.isSelected != model.isSelected {
                cell.animateSelection(isSelected: updatedModel.isSelected)
                viewModels[index] = updatedModel
            }
        }
    }
}
