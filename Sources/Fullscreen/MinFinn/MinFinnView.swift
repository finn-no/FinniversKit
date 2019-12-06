//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol MinFinnViewDataSource: AnyObject {
    func numberOfSections(in view: MinFinnView) -> Int
    func minFinnView(_ view: MinFinnView, numberOfRowsInSection section: Int) -> Int
    func minFinnView(_ view: MinFinnView, modelForRowAt indexPath: IndexPath) -> MinFinnCellModel
}

public protocol MinFinnViewDelegate: AnyObject {
    func minFinnView(_ view: MinFinnView, didSelectProfileImageAt indexPath: IndexPath)
    func minFinnView(_ view: MinFinnView, didSelectModelAt indexPath: IndexPath)
    func minFinnVIew(_ view: MinFinnView, loadImageWith url: URL, completion: @escaping (UIImage?) -> Void)
}

public class MinFinnView: UIView {

    // MARK: - Public properties

    public weak var dataSource: MinFinnViewDataSource?
    public weak var delegate: MinFinnViewDelegate?

    // MARK: - Private properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .bgPrimary
        tableView.separatorColor = .tableViewSeparator
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        tableView.register(MinFinnProfileCell.self)
        tableView.register(IconTitleTableViewCell.self)
        tableView.register(BasicTableViewCell.self)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return tableView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITableViewDataSource
extension MinFinnView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        dataSource?.numberOfSections(in: self) ?? 0
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource?.minFinnView(self, numberOfRowsInSection: section) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource?.minFinnView(self, modelForRowAt: indexPath)

        switch model {
        case let profileModel as MinFinnProfileCellModel:
            let cell = tableView.dequeue(MinFinnProfileCell.self, for: indexPath)
            cell.delegate = self
            cell.configure(with: profileModel)
            return cell
        case let iconModel as IconTitleTableViewCellViewModel:
            let cell = tableView.dequeue(IconTitleTableViewCell.self, for: indexPath)
            cell.configure(with: iconModel)
            return cell
        default:
            let cell = tableView.dequeue(BasicTableViewCell.self, for: indexPath)
            cell.configure(with: model)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension MinFinnView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.minFinnView(self, didSelectModelAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSource?.minFinnView(self, modelForRowAt: indexPath) {
        case is MinFinnProfileCellModel:
            return UITableView.automaticDimension
        default:
            return 48
        }
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension MinFinnView: MinFinnProfileCellDelegate {
    func minFinnProfileCellDidSelectProfileImage(_ cell: MinFinnProfileCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        delegate?.minFinnView(self, didSelectProfileImageAt: indexPath)
    }

    func minFinnProfileCell(_ cell: MinFinnProfileCell, loadImageWithUrl url: URL, completionHandler: @escaping (UIImage?) -> Void) {
        delegate?.minFinnVIew(self, loadImageWith: url, completion: completionHandler)
    }
}

// MARK: - Private methods
private extension MinFinnView {
    func setup() {
        addSubview(tableView)
    }
}
