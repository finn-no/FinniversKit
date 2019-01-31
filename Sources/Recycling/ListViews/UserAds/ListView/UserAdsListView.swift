//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol UserAdsListViewDelegate: class {
    func userAdsListView(_ userAdsListView: UserAdsListView, userAdsListHeaderView: UserAdsListHeaderView, didTapSeeMoreButton button: Button)
    func userAdsListView(_ userAdsListView: UserAdsListView, didTapCreateNewAdButton button: Button)
    func userAdsListView(_ userAdsListView: UserAdsListView, didTapSeeAllAdsButton button: Button)
    func userAdsListView(_ userAdsListView: UserAdsListView, didSelectItemAtIndex index: Int)
    func userAdsListView(_ userAdsListView: UserAdsListView, willDisplayItemAtIndex index: Int)
    func userAdsListView(_ userAdsListView: UserAdsListView, didScrollInScrollView scrollView: UIScrollView)
}

public protocol UserAdsListViewDataSource: class {
    func numberOfSections(in userAdsListView: UserAdsListView) -> Int
    func userAdsListView(_ userAdsListView: UserAdsListView, numberOfRowsInSection section: Int) -> Int
    func userAdsListView(_ userAdsListView: UserAdsListView, modelAtIndex section: Int) -> UserAdsListViewHeaderModel
    func userAdsListView(_ userAdsListView: UserAdsListView, modelAtIndex indexPath: IndexPath) -> UserAdsListViewModel
    func userAdsListView(_ userAdsListView: UserAdsListView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    func userAdsListView(_ userAdsListView: UserAdsListView, loadImageForModel model: UserAdsListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func userAdsListView(_ userAdsListView: UserAdsListView, cancelLoadingImageForModel model: UserAdsListViewModel, imageWidth: CGFloat)
}

public class UserAdsListView: UIView {
    public static let firstSectionCellHeight: CGFloat = 80

    public static let secondSectionHeaderHeight: CGFloat = 38
    public static let secondSectionCellHeight: CGFloat = 112

    public static let thirdSectionHeaderHeight: CGFloat = 38
    public static let thirdSectionCellHeight: CGFloat = 66

    public static let fourthSectionCellHeight: CGFloat = 60

    // MARK: - Internal properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .milk
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        return tableView
    }()

    private weak var delegate: UserAdsListViewDelegate?
    private weak var dataSource: UserAdsListViewDataSource?

    // MARK: - Setup

    public init(delegate: UserAdsListViewDelegate, dataSource: UserAdsListViewDataSource) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.dataSource = dataSource
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        tableView.register(UserAdsListViewNewAdCell.self)
        tableView.register(UserAdsListViewActiveCell.self)
        tableView.register(UserAdsListViewSeeAllAdsCell.self)
        addSubview(tableView)
        tableView.fillInSuperview()
    }

    // MARK: - Public

    public func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tableView.insertRows(at: indexPaths, with: animation)
    }

    public func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tableView.deleteRows(at: indexPaths, with: animation)
    }

    public func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tableView.reloadRows(at: indexPaths, with: animation)
    }
}

// MARK: - UITableViewDelegate

extension UserAdsListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.userAdsListView(self, didSelectItemAtIndex: indexPath.row)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.userAdsListView(self, didScrollInScrollView: scrollView)
    }
}

// MARK: - UITableViewDataSource

extension UserAdsListView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 0
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0: return nil
        case 4: return nil
        default:
            let headerView = UserAdsListHeaderView(frame: .zero)
            headerView.delegate = self

            if let model = dataSource?.userAdsListView(self, modelAtIndex: section) {
                headerView.model = model
            }

            return headerView
        }
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1: return UserAdsListView.secondSectionHeaderHeight
        case 2: return UserAdsListView.thirdSectionHeaderHeight
        default: return 0.0
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return UserAdsListView.firstSectionCellHeight
        case 1: return UserAdsListView.secondSectionCellHeight
        case 2: return UserAdsListView.secondSectionCellHeight
        case 3: return UserAdsListView.firstSectionCellHeight
        default: return 0.0
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.userAdsListView(self, numberOfRowsInSection: section) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var activeCell = UserAdsListViewActiveCell()

        let colors: [UIColor] = [.toothPaste, .mint, .banana, .salmon]
        let color = colors[indexPath.row % 4]

        switch indexPath.section {
        case 0:
            let newAdCell = tableView.dequeue(UserAdsListViewNewAdCell.self, for: indexPath)
            newAdCell.delegate = self
            if let model = dataSource?.userAdsListView(self, modelAtIndex: indexPath) {
                newAdCell.model = model
            }
            return newAdCell
        case 1:
            activeCell = tableView.dequeue(UserAdsListViewActiveCell.self, for: indexPath)
            activeCell.loadingColor = color
            activeCell.dataSource = self
            if let model = dataSource?.userAdsListView(self, modelAtIndex: indexPath) {
                activeCell.model = model
            }
            return activeCell
        case 2:
            activeCell = tableView.dequeue(UserAdsListViewActiveCell.self, for: indexPath)
            activeCell.loadingColor = color
            activeCell.dataSource = self
            if let model = dataSource?.userAdsListView(self, modelAtIndex: indexPath) {
                activeCell.model = model
            }
            return activeCell
        case 3:
            let seeAllAdsCell = tableView.dequeue(UserAdsListViewSeeAllAdsCell.self, for: indexPath)
            seeAllAdsCell.delegate = self
            if let model = dataSource?.userAdsListView(self, modelAtIndex: indexPath) {
                seeAllAdsCell.model = model
            }
            return seeAllAdsCell
        default: return UITableViewCell(frame: .zero)
        }
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? UserAdsListViewActiveCell { cell.loadImage() }
        if let cell = cell as? UserAdsListViewInactiveCell { cell.loadImage() }
        delegate?.userAdsListView(self, willDisplayItemAtIndex: indexPath.row)
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataSource?.userAdsListView(self, commit: editingStyle, forRowAt: indexPath)
    }
}

// MARK: - UserAdsListViewNewAdCellDelegate

extension UserAdsListView: UserAdsListViewNewAdCellDelegate {
    public func userAdsListViewNewAdCell(_ userAdsListViewNewAdCell: UserAdsListViewNewAdCell, didTapCreateNewAdButton button: Button) {
        delegate?.userAdsListView(self, didTapCreateNewAdButton: button)
    }
}

// MARK: - UserAdsListHeaderViewDelegate

extension UserAdsListView: UserAdsListHeaderViewDelegate {
    public func userAdsListHeaderView(_ userAdsListHeaderView: UserAdsListHeaderView, didTapSeeMoreButton button: Button) {
        delegate?.userAdsListView(self, userAdsListHeaderView: userAdsListHeaderView, didTapSeeMoreButton: button)
    }
}

// MARK: - UserAdsListViewCellDataSource

extension UserAdsListView: UserAdsListViewActiveCellDataSource {
    public func userAdsListViewActiveCell(_ userAdsListViewActiveCell: UserAdsListViewActiveCell, loadImageForModel model: UserAdsListViewModel,
                                          imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        dataSource?.userAdsListView(self, loadImageForModel: model, imageWidth: imageWidth, completion: completion)
    }

    public func userAdsListViewActiveCell(_ userAdsListViewActiveCell: UserAdsListViewActiveCell, cancelLoadingImageForModel model: UserAdsListViewModel, imageWidth: CGFloat) {
        dataSource?.userAdsListView(self, cancelLoadingImageForModel: model, imageWidth: imageWidth)
    }
}

// MARK: - UserAdsListViewSeeAllAdsCellDelegate

extension UserAdsListView: UserAdsListViewSeeAllAdsCellDelegate {
    public func userAdsListViewSeeAllAdsCell(_ userAdsListViewSeeAllAdsCell: UserAdsListViewSeeAllAdsCell, didTapSeeAllAdsButton button: Button) {
        delegate?.userAdsListView(self, didTapSeeAllAdsButton: button)
    }
}
