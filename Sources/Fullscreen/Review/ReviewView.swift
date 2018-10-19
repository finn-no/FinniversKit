//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol ReviewViewDelegate: class {
    func reviewView(_ reviewView: ReviewView, loadImageForModel model: ReviewViewProfileModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) -> UIImage?
    func reviewView(_ reviewView: ReviewView, cancelLoadingImageForModel model: ReviewViewProfileModel, imageWidth: CGFloat)
    func reviewView(_ reviewView: ReviewView, didSelect profile: ReviewViewProfileModel)
}

public class ReviewView: UIView {
    static let defaultRowHeight: CGFloat = 40
    static let defaultHeaderHeight: CGFloat = 60

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(ReviewTextHeader.self)
        tableView.register(ReviewProfileCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = ReviewView.defaultRowHeight
        tableView.estimatedSectionHeaderHeight = ReviewView.defaultHeaderHeight
        return tableView
    }()

    lazy var selectButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.addTarget(self, action: #selector(didSelectProfile), for: .touchUpInside)
        return button
    }()

    lazy var label: Label = {
        let label = Label(style: Label.Style.detail)
        label.textAlignment = .center
        label.isEnabled = false
        return label
    }()

    lazy var wrapper: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [selectButton, label])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = .mediumSpacing
        return stack
    }()

    public weak var delegate: ReviewViewDelegate?

    public var model: ReviewViewModel? {
        didSet {
            selectButton.setTitle(model?.selectTitle ?? "", for: .normal)
            label.text = model?.confirmationTitle ?? ""
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
        addSubview(wrapper)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: wrapper.topAnchor),
            wrapper.leftAnchor.constraint(equalTo: leftAnchor, constant: .mediumLargeSpacing),
            wrapper.rightAnchor.constraint(equalTo: rightAnchor, constant: -.mediumLargeSpacing),
            wrapper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing)
        ])
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
        header.title.text = model?.title

        return header
    }

    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let row = tableView.indexPathForSelectedRow,
            let cell = tableView.cellForRow(at: row) as? ReviewProfileCell else {
            return indexPath
        }

        cell.isSelected = false

        return indexPath
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ReviewProfileCell,
            let selectedUser = model?.profiles[indexPath.row] else {
            return
        }

        selectButton.setTitle("\(model?.selectTitle ?? "") \(selectedUser.name)", for: .normal)
        selectButton.isEnabled = true
        label.isEnabled = true
        cell.isSelected = true
    }
}

extension ReviewView {
    @objc func didSelectProfile() {
        guard let indexPath = tableView.indexPathForSelectedRow,
            let selectedProfile = model?.profiles[indexPath.row] else {
            return
        }

        delegate?.reviewView(self, didSelect: selectedProfile)
    }
}

extension ReviewView: ReviewProfileCellDelegate {
    func reviewProfileCell(_ reviewProfileCell: ReviewProfileCell, loadImageForModel model: ReviewViewProfileModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) -> UIImage? {
        return delegate?.reviewView(self, loadImageForModel: model, imageWidth: imageWidth, completion: completion)
    }

    func reviewProfileCell(_ reviewProfileCell: ReviewProfileCell, cancelLoadingImageForModel model: ReviewViewProfileModel, imageWidth: CGFloat) {
        delegate?.reviewView(self, cancelLoadingImageForModel: model, imageWidth: imageWidth)
    }
}
