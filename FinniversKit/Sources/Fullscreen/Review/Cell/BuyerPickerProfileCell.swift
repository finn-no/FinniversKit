//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol BuyerPickerCellDelegate: AnyObject {
    func buyerPickerCell(_ cell: BuyerPickerProfileCell, loadImageForModel model: BuyerPickerProfileModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func buyerPickerCell(_ cell: BuyerPickerProfileCell, cancelLoadingImageForModel model: BuyerPickerProfileModel, imageWidth: CGFloat)
}

class BuyerPickerProfileCell: UITableViewCell {
    static let profileImageSize: CGFloat = 44

    lazy var profileImage: RoundedImageView = {
        let image = RoundedImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    lazy var name: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var hairlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .border
        return view
    }()

    lazy var chevronLabel = Label(style: .detail, withAutoLayout: true)

    var model: BuyerPickerProfileModel? {
        didSet {
            name.text = model?.name ?? ""
            chevronLabel.text = model?.chevronText ?? ""
        }
    }

    weak var delegate: BuyerPickerCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
        name.text = ""

        if let model = model {
            delegate?.buyerPickerCell(self, cancelLoadingImageForModel: model, imageWidth: BuyerPickerProfileCell.profileImageSize)
        }
    }

    private func setup() {
        accessoryType = .disclosureIndicator
        selectionStyle = .none

        let profileStack = UIStackView(arrangedSubviews: [profileImage, name])
        profileStack.alignment = .center
        profileStack.spacing = .spacingS
        profileStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(profileStack)
        contentView.addSubview(chevronLabel)
        contentView.addSubview(hairlineView)

        NSLayoutConstraint.activate([
            profileStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingS),
            profileStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            profileStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),
            profileStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.spacingS),

            profileImage.heightAnchor.constraint(equalToConstant: BuyerPickerProfileCell.profileImageSize),
            profileImage.widthAnchor.constraint(equalToConstant: BuyerPickerProfileCell.profileImageSize),

            chevronLabel.centerYAnchor.constraint(equalTo: profileStack.centerYAnchor),
            chevronLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingS),

            hairlineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            hairlineView.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor, constant: .spacingS),
            hairlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .spacingXL),
            hairlineView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    func loadImage() {
        guard let model = model else { return }
        delegate?.buyerPickerCell(self, loadImageForModel: model, imageWidth: BuyerPickerProfileCell.profileImageSize, completion: { [weak self] image in
            if let image = image {
                self?.profileImage.image = image
            }
        })
    }
}
