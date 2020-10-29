//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol BuyerPickerViewDelegate: AnyObject {
    func buyerPickerView(_ buyerPickerView: BuyerPickerView, loadImageForModel model: BuyerPickerProfileModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func buyerPickerView(_ buyerPickerView: BuyerPickerView, cancelLoadingImageForModel model: BuyerPickerProfileModel, imageWidth: CGFloat)
    func buyerPickerView(_ buyerPickerView: BuyerPickerView, didSelect profile: BuyerPickerProfileModel, forRowAt indexPath: IndexPath)
    func buyerPickerViewDidSelectFallbackCell(_ buyerPickerView: BuyerPickerView)
    func buyerPickerViewCenterTitleInHeaderView(_ buyerPickerView: BuyerPickerView, viewForHeaderInSection section: Int) -> Bool
}

public class BuyerPickerView: UIView {

    // MARK: - Public properties

    public weak var delegate: BuyerPickerViewDelegate?
    public var model: BuyerPickerViewModel? { didSet { tableView.reloadData() } }

    // MARK: - Private properties

    private static let defaultRowHeight: CGFloat = 40
    private static let defaultHeaderHeight: CGFloat = 60

    private lazy var fallbackCellIndex: Int = {
        guard let model = model else { return 1 }
        return model.profiles.count
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .bgPrimary
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(BuyerPickerTextHeader.self)
        tableView.register(BuyerPickerProfileCell.self)
        tableView.register(BuyerPickerFallbackCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = BuyerPickerView.defaultRowHeight
        tableView.estimatedSectionHeaderHeight = BuyerPickerView.defaultHeaderHeight
        return tableView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }

    // MARK: - Private methods

    @objc private func didSelectProfile() {
        guard let indexPath = tableView.indexPathForSelectedRow,
            let selectedProfile = model?.profiles[indexPath.row] else {
                return
        }

        delegate?.buyerPickerView(self, didSelect: selectedProfile, forRowAt: indexPath)
    }
}

// MARK: - UITableViewDataSource

extension BuyerPickerView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = model else { return 1 }
        let numberOfRowsIncludingFallbackCell = model.profiles.count + 1
        return numberOfRowsIncludingFallbackCell
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case fallbackCellIndex:
            let cell = tableView.dequeue(BuyerPickerFallbackCell.self, for: indexPath)
            cell.model = model?.fallbackCell
            return cell
        default:
            guard let viewModel = model?.profiles[safe: indexPath.row] else { return UITableViewCell() }
            let cell = tableView.dequeue(BuyerPickerProfileCell.self, for: indexPath)
            cell.model = viewModel
            cell.delegate = self
            cell.loadImage()
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension BuyerPickerView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeue(BuyerPickerTextHeader.self)
        header.title.text = model?.title
        if delegate?.buyerPickerViewCenterTitleInHeaderView(self, viewForHeaderInSection: section) == true {
            header.centerTitle()
        }
        return header
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case fallbackCellIndex:
            delegate?.buyerPickerViewDidSelectFallbackCell(self)
        default:
            guard let selectedUser = model?.profiles[safe: indexPath.row] else { return }
            delegate?.buyerPickerView(self, didSelect: selectedUser, forRowAt: indexPath)
        }
    }
}

// MARK: - ReviewProfileCellDelegate

extension BuyerPickerView: BuyerPickerCellDelegate {
    func buyerPickerCell(_ reviewProfileCell: BuyerPickerProfileCell, loadImageForModel model: BuyerPickerProfileModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        delegate?.buyerPickerView(self, loadImageForModel: model, imageWidth: imageWidth, completion: completion)
    }

    func buyerPickerCell(_ reviewProfileCell: BuyerPickerProfileCell, cancelLoadingImageForModel model: BuyerPickerProfileModel, imageWidth: CGFloat) {
        delegate?.buyerPickerView(self, cancelLoadingImageForModel: model, imageWidth: imageWidth)
    }
}
