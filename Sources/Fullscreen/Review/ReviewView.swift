//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol ReviewViewDelegate: NSObjectProtocol {
    func reviewView(_ reviewView: ReviewView, loadImageForModel model: ReviewViewProfileModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) -> UIImage?
    func reviewView(_ reviewView: ReviewView, cancelLoadingImageForModel model: ReviewViewProfileModel)
    func reviewView(_ reviewView: ReviewView, didClick type: ReviewView.SelectType)
}

public class ReviewView: UIView {
    public enum SelectType {
        case user(ReviewViewProfileModel)
        case skip
        case noneOfThese
    }

    static let defaultRowHeight: CGFloat = 40

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(ReviewTextHeader.self)
        tableView.register(ReviewProfileCell.self)
        tableView.register(ReviewTextFooter.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = ReviewView.defaultRowHeight
        tableView.estimatedSectionHeaderHeight = ReviewView.defaultRowHeight
        tableView.estimatedSectionFooterHeight = ReviewView.defaultRowHeight
        return tableView
    }()

    public weak var delegate: ReviewViewDelegate?

    public var model: ReviewViewModel? {
        didSet {
            tableView.reloadData()
        }
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
        addSubview(tableView)
        tableView.fillInSuperview()
    }
}

extension ReviewView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.profiles.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = model?.profiles[indexPath.row] else {
            return UITableViewCell()
        }

        return reviewProfileCell(tableView: tableView, for: indexPath, model: model)
    }

    private func reviewProfileCell(tableView: UITableView, for indexPath: IndexPath, model: ReviewViewProfileModel) -> UITableViewCell {
        let cell = tableView.dequeue(ReviewProfileCell.self, for: indexPath)
        cell.model = model
        cell.delegate = self
        cell.loadImage()

        return cell
    }
}

extension ReviewView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeue(ReviewTextHeader.self)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.title.text = model?.title
        header.subtitle.text = model?.subtitle

        return header
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeue(ReviewTextFooter.self)
        footer.translatesAutoresizingMaskIntoConstraints = false
        footer.title.setTitle(model?.nonOfTheseTitle, for: .normal)
        footer.title.addTarget(self, action:  #selector(didSelectNonOfThese), for: .touchUpInside)
        footer.subtitle.setTitle(model?.skiptitle, for: .normal)
        footer.subtitle.addTarget(self, action: #selector(didSelectSkip), for: .touchUpInside)

        return footer
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let selectedUser = model?.profiles[indexPath.row] else {
            return
        }

        delegate?.reviewView(self, didClick: .user(selectedUser))
    }
}

extension ReviewView {
    @objc func didSelectNonOfThese() {
        delegate?.reviewView(self, didClick: .noneOfThese)
    }

    @objc func didSelectSkip() {
        delegate?.reviewView(self, didClick: .skip)
    }
}

extension ReviewView: ReviewProfileCellDelegate {
    func reviewProfileCell(_ reviewProfileCell: ReviewProfileCell, loadImageForModel model: ReviewViewProfileModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) -> UIImage? {
        return delegate?.reviewView(self, loadImageForModel: model, imageWidth: imageWidth, completion: completion)
    }

    func reviewProfileCell(_ reviewProfileCell: ReviewProfileCell, cancelLoadingImageForModel model: ReviewViewProfileModel) {
        delegate?.reviewView(self, cancelLoadingImageForModel: model)
    }
}
