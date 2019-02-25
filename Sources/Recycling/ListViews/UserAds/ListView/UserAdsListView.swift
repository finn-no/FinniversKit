//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol UserAdsListViewDelegate: class {
    func userAdsListView(_ userAdsListView: UserAdsListView, userAdsListHeaderView: UserAdsListHeaderView, didTapSeeMoreButton button: Button)
    func userAdsListView(_ userAdsListView: UserAdsListView, didTapCreateNewAdButton button: Button)
    func userAdsListView(_ userAdsListView: UserAdsListView, didTapSeeAllAdsButton button: Button)
    func userAdsListView(_ userAdsListView: UserAdsListView, didSelectItemAtIndex indexPath: IndexPath)
    func userAdsListView(_ userAdsListView: UserAdsListView, willDisplayItemAtIndex indexPath: IndexPath)
    func userAdsListView(_ userAdsListView: UserAdsListView, didScrollInScrollView scrollView: UIScrollView)
}

public protocol UserAdsListViewDataSource: class {
    func numberOfSections(in userAdsListView: UserAdsListView) -> Int
    func userAdsListView(_ userAdsListView: UserAdsListView, shouldDisplayInactiveSectionAt indexPath: IndexPath) -> Bool
    func userAdsListView(_ userAdsListView: UserAdsListView, numberOfRowsInSection section: Int) -> Int
    func userAdsListView(_ userAdsListView: UserAdsListView, modelAtIndex section: Int) -> UserAdsListHeaderViewModel
    func userAdsListView(_ userAdsListView: UserAdsListView, modelAtIndex indexPath: IndexPath) -> UserAdsListViewModel
    func userAdsListView(_ userAdsListView: UserAdsListView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    func userAdsListView(_ userAdsListView: UserAdsListView, loadImageForModel model: UserAdsListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func userAdsListView(_ userAdsListView: UserAdsListView, cancelLoadingImageForModel model: UserAdsListViewModel, imageWidth: CGFloat)
}

public class UserAdsListView: UIView {
    public static let sectionHeaderHeight: CGFloat = 38

    public static let buttonCellHeight: CGFloat = 80
    public static let activeCellHeight: CGFloat = 112
    public static let inactiveCellHeight: CGFloat = 66

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

    private var firstSection = 0
    private lazy var lastSection: Int = {
        return (dataSource?.numberOfSections(in: self) ?? 1) - 1
    }()

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
        tableView.register(UserAdsListViewCell.self)
        tableView.register(UserAdsListViewSeeAllAdsCell.self)
        addSubview(tableView)
        tableView.fillInSuperview()
    }

    // MARK: - Public

    public func reloadData() {
        tableView.reloadData()
    }

    public func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tableView.insertRows(at: indexPaths, with: animation)
    }

    public func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tableView.deleteRows(at: indexPaths, with: animation)
    }

    public func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tableView.reloadRows(at: indexPaths, with: animation)
    }

    public func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        tableView.deleteSections(sections, with: animation)
    }

    public func scrollToTop() {
        if #available(iOS 11.0, *) {
            tableView.setContentOffset(CGPoint(x: 0, y: -tableView.adjustedContentInset.top), animated: true)
        } else {
            tableView.setContentOffset(CGPoint(x: 0, y: -tableView.contentInset.top), animated: true)
        }
    }
}

// MARK: - UITableViewDelegate

extension UserAdsListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.userAdsListView(self, didSelectItemAtIndex: indexPath)
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
        case firstSection, lastSection: return nil
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
        case firstSection, lastSection: return 0.1 // Return 0.1 so we dont show a seperator if there's no section/ads to show.
        default: return UserAdsListView.sectionHeaderHeight
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isInactiveSection = dataSource?.userAdsListView(self, shouldDisplayInactiveSectionAt: indexPath) ?? false

        switch indexPath.section {
        case firstSection, lastSection: return UserAdsListView.buttonCellHeight
        default: return isInactiveSection ? UserAdsListView.inactiveCellHeight : UserAdsListView.activeCellHeight
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.userAdsListView(self, numberOfRowsInSection: section) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UserAdsListViewCell()

        let colors: [UIColor] = [.toothPaste, .mint, .banana, .salmon]
        let color = colors[indexPath.row % 4]

        switch indexPath.section {
        case firstSection:
            let newAdCell = tableView.dequeue(UserAdsListViewNewAdCell.self, for: indexPath)
            newAdCell.delegate = self
            if let model = dataSource?.userAdsListView(self, modelAtIndex: indexPath) {
                newAdCell.model = model
            }
            return newAdCell
        case lastSection:
            let seeAllAdsCell = tableView.dequeue(UserAdsListViewSeeAllAdsCell.self, for: indexPath)
            seeAllAdsCell.delegate = self
            if let model = dataSource?.userAdsListView(self, modelAtIndex: indexPath) {
                seeAllAdsCell.model = model
            }
            return seeAllAdsCell
        default:
            cell = tableView.dequeue(UserAdsListViewCell.self, for: indexPath)
            cell.loadingColor = color
            cell.dataSource = self
            if let model = dataSource?.userAdsListView(self, modelAtIndex: indexPath) {
                cell.model = model
            }
            return cell
        }
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? UserAdsListViewCell { cell.loadImage() }
        delegate?.userAdsListView(self, willDisplayItemAtIndex: indexPath)
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case firstSection, lastSection: return false
        default: return true
        }
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

extension UserAdsListView: UserAdsListViewCellDataSource {
    public func userAdsListViewCellShouldDisplayAsInactive(_ userAdsListViewCell: UserAdsListViewCell) -> Bool {
        guard let indexPath = tableView.indexPathForRow(at: userAdsListViewCell.center) else { return  false}
        return dataSource?.userAdsListView(self, shouldDisplayInactiveSectionAt: indexPath) ?? false
    }

    public func userAdsListViewCell(_ userAdsListViewCell: UserAdsListViewCell, loadImageForModel model: UserAdsListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        dataSource?.userAdsListView(self, loadImageForModel: model, imageWidth: imageWidth, completion: completion)
    }

    public func userAdsListViewCell(_ userAdsListViewCell: UserAdsListViewCell, cancelLoadingImageForModel model: UserAdsListViewModel, imageWidth: CGFloat) {
        dataSource?.userAdsListView(self, cancelLoadingImageForModel: model, imageWidth: imageWidth)
    }
}

// MARK: - UserAdsListViewSeeAllAdsCellDelegate

extension UserAdsListView: UserAdsListViewSeeAllAdsCellDelegate {
    public func userAdsListViewSeeAllAdsCell(_ userAdsListViewSeeAllAdsCell: UserAdsListViewSeeAllAdsCell, didTapSeeAllAdsButton button: Button) {
        delegate?.userAdsListView(self, didTapSeeAllAdsButton: button)
    }
}
