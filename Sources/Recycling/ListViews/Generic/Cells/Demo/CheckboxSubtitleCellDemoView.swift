//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

private struct ViewModel: CheckboxSubtitleTableViewCellViewModel {
    var title: String
    var subtitle: String?
    var isSelected: Bool
}

class CheckboxSubtitleCellDemoView: UIView {
    fileprivate var viewModels = [
        ViewModel(title: "Hagemøbler", subtitle: "For deg som liker noe godt å sitte i når du gjør deg flid med grillen", isSelected: false),
        ViewModel(title: "Kattepuser", subtitle: "Fin-fine kattunger", isSelected: true),
        ViewModel(title: "Mac Mini Pro", subtitle: "En noe kraftigere Mac Mini", isSelected: true),
        ViewModel(title: "Mac Pro Mini", subtitle: "En noe svakere Mac Pro", isSelected: false),
        ViewModel(title: "Mac Pro Max", subtitle: "Gir deg stødige 140fps i Minecraft", isSelected: false)
        ]

    lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 48
        tableView.register(CheckboxSubtitleTableViewCell.self)
        tableView.separatorInset = .leadingInset(frame.width)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
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

        guard let cell = tableView.cellForRow(at: indexPath) as? CheckboxSubtitleTableViewCell else { return }
        var viewModel = viewModels[indexPath.row]
        viewModel.isSelected = !viewModel.isSelected
        viewModels[indexPath.row] = viewModel
        cell.animateSelection(isSelected: viewModel.isSelected)
        
        print("Checkbox cells w/subtitle selected:", viewModels.filter { $0.isSelected }.map { $0.title })
    }
}

extension CheckboxSubtitleCellDemoView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(CheckboxSubtitleTableViewCell.self, for: indexPath)
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
}
