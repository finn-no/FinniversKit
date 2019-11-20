//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol BuyerPickerViewDelegate: AnyObject {
    func buyerPickerView(_ buyerPickerView: BuyerPickerView, loadImageForModel model: BuyerPickerProfileModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) -> UIImage?
    func buyerPickerView(_ buyerPickerView: BuyerPickerView, cancelLoadingImageForModel model: BuyerPickerProfileModel, imageWidth: CGFloat)
    func buyerPickerView(_ buyerPickerView: BuyerPickerView, didSelect profile: BuyerPickerProfileModel)
}

public class BuyerPickerView: UIView {

    // MARK: - Public properties

    public weak var delegate: BuyerPickerViewDelegate?
    public var model: BuyerPickerViewModel? {
        didSet {
            selectButton.setTitle(model?.selectTitle ?? "", for: .normal)
            label.text = model?.confirmationTitle ?? ""
            tableView.reloadData()
        }
    }

    // MARK: - Private properties

    private static let defaultRowHeight: CGFloat = 40
    private static let defaultHeaderHeight: CGFloat = 60

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .bgPrimary
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(BuyerPickerTextHeader.self)
        tableView.register(BuyerPickerProfileCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = BuyerPickerView.defaultRowHeight
        tableView.estimatedSectionHeaderHeight = BuyerPickerView.defaultHeaderHeight
        return tableView
    }()

    private lazy var selectButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.addTarget(self, action: #selector(didSelectProfile), for: .touchUpInside)
        return button
    }()

    private lazy var label: Label = {
        let label = Label(style: Label.Style.caption)
        label.textAlignment = .center
        label.isEnabled = false
        return label
    }()

    private lazy var wrapper: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [selectButton, label])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = .mediumSpacing
        return stack
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

    // MARK: - Public methods

    public func setSelectButtonEnabled(_ isEnabled: Bool) {
        selectButton.isEnabled = isEnabled
    }

    // MARK: - Private methods

    @objc private func didSelectProfile() {
        guard let indexPath = tableView.indexPathForSelectedRow,
            let selectedProfile = model?.profiles[indexPath.row] else {
                return
        }

        delegate?.buyerPickerView(self, didSelect: selectedProfile)
    }
}

// MARK: - UITableViewDataSource

extension BuyerPickerView: UITableViewDataSource {
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

        let cell = tableView.dequeue(BuyerPickerProfileCell.self, for: indexPath)
        cell.model = model
        cell.delegate = self
        cell.loadImage()

        return cell
    }
}

// MARK: - UITableViewDelegate

extension BuyerPickerView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeue(BuyerPickerTextHeader.self)
        header.title.text = model?.title

        return header
    }

    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let row = tableView.indexPathForSelectedRow,
            let cell = tableView.cellForRow(at: row) as? BuyerPickerProfileCell else {
            return indexPath
        }

        cell.isSelected = false

        return indexPath
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? BuyerPickerProfileCell,
            let selectedUser = model?.profiles[indexPath.row] else {
            return
        }

        selectButton.setTitle("\(model?.selectTitle ?? "") \(selectedUser.name)", for: .normal)
        selectButton.isEnabled = true
        label.isEnabled = true
        cell.isSelected = true
    }
}

// MARK: - ReviewProfileCellDelegate

extension BuyerPickerView: BuyerPickerCellDelegate {
    func buyerPickerCell(_ reviewProfileCell: BuyerPickerProfileCell, loadImageForModel model: BuyerPickerProfileModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) -> UIImage? {
        return delegate?.buyerPickerView(self, loadImageForModel: model, imageWidth: imageWidth, completion: completion)
    }

    func buyerPickerCell(_ reviewProfileCell: BuyerPickerProfileCell, cancelLoadingImageForModel model: BuyerPickerProfileModel, imageWidth: CGFloat) {
        delegate?.buyerPickerView(self, cancelLoadingImageForModel: model, imageWidth: imageWidth)
    }
}
