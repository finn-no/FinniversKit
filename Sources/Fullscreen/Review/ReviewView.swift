//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol ReviewViewDelegate: NSObjectProtocol {
    func reviewView(_ reviewView: ReviewView,
                    loadImageForModel model: ReviewViewProfileModel,
                    imageWidth: CGFloat,
                    completion: @escaping ((UIImage?) -> Void)) -> UIImage?
    func reviewView(_ reviewView: ReviewView, cancelLoadingImageForModel model: ReviewViewProfileModel)
    func reviewView(_ reviewView: ReviewView, didSelect user: ReviewViewProfileModel)
}

public class ReviewView: UIView {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(ReviewTextHeader.self, forHeaderFooterViewReuseIdentifier: ReviewTextHeader.identifier)
        tableView.register(ReviewProfileCell.self, forCellReuseIdentifier: ReviewProfileCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        tableView.estimatedSectionHeaderHeight = 40
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

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
}

extension ReviewView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.cells.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = model?.cells[indexPath.row] else {
            return UITableViewCell()
        }

        return reviewProfileCell(tableView: tableView, for: indexPath, model: model)
    }

    private func reviewProfileCell(tableView: UITableView,
                                   for indexPath: IndexPath,
                                   model: ReviewViewProfileModel) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewProfileCell.identifier,
                                                       for: indexPath) as? ReviewProfileCell else {
            return UITableViewCell()
        }

        cell.model = model
        cell.delegate = self
        cell.loadImage()

        return cell
    }
}

extension ReviewView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReviewTextHeader.identifier) as? ReviewTextHeader else {
            return nil
        }

        header.translatesAutoresizingMaskIntoConstraints = false
        header.title.text = model?.title
        header.subTitle.text = model?.subTitle

        return header
    }


    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let user = model?.cells[indexPath.row] else {
            return
        }

        delegate?.reviewView(self, didSelect: user)
    }
}

extension ReviewView: ReviewProfileCellDelegate {
    func reviewProfileCell(_ reviewProfileCell: ReviewProfileCell,
                           loadImageForModel model: ReviewViewProfileModel,
                           imageWidth: CGFloat,
                           completion: @escaping ((UIImage?) -> Void)) -> UIImage? {
        return delegate?.reviewView(self, loadImageForModel: model, imageWidth: imageWidth, completion: completion)
    }

    func reviewProfileCell(_ reviewProfileCell: ReviewProfileCell,
                           cancelLoadingImageForModel model: ReviewViewProfileModel) {
        delegate?.reviewView(self, cancelLoadingImageForModel: model)
    }
}
