//
//  Copyright © FINN AS. All rights reserved.
//

import FinniversKit

private struct ViewModel {
    var title: String?
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
        cell.animateSelection(isSelected: model.isSelected)
        cell.textLabel?.text = model.title
        return cell
    }

}
