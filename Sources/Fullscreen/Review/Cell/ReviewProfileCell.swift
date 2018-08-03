//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol ReviewProfileCellDelegate: class {
    func reviewProfileCell(_ reviewProfileCell: ReviewProfileCell, loadImageForModel model: ReviewViewProfileModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) -> UIImage?
    func reviewProfileCell(_ reviewProfileCell: ReviewProfileCell, cancelLoadingImageForModel model: ReviewViewProfileModel)
}

class ReviewProfileCell: UITableViewCell {
    static let profileImageSize: CGFloat = 44

    lazy var profileImage: RoundedImageView = {
        let image = RoundedImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    lazy var name: Label = {
        let label = Label(style: .body(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var selectIndicator: UIImageView = {
        let selectIndicator = UIImageView()
        selectIndicator.image = UIImage(named: .arrowRight)
        selectIndicator.translatesAutoresizingMaskIntoConstraints = false
        return selectIndicator
    }()

    lazy var hairlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ice
        return view
    }()

    var model: ReviewViewProfileModel? {
        didSet {
            name.text = model?.name ?? ""
        }
    }

    weak var delegate: ReviewProfileCellDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let profileStack = UIStackView(arrangedSubviews: [profileImage, name, selectIndicator])
        profileStack.alignment = .center
        profileStack.spacing = .mediumSpacing
        profileStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(profileStack)
        contentView.addSubview(hairlineView)

        NSLayoutConstraint.activate([
            profileStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
            profileStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            profileStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            profileStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumSpacing),

            profileImage.heightAnchor.constraint(equalToConstant: ReviewProfileCell.profileImageSize),
            profileImage.widthAnchor.constraint(equalToConstant: ReviewProfileCell.profileImageSize),

            hairlineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            hairlineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumSpacing),
            hairlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumSpacing),
            hairlineView.heightAnchor.constraint(equalToConstant: 2),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
        name.text = ""
    }

    func loadImage() {
        guard let model = model else { return }
        profileImage.image = delegate?.reviewProfileCell(self, loadImageForModel: model, imageWidth: ReviewProfileCell.profileImageSize, completion: { [weak self] image in
            self?.profileImage.image = image
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
