//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class ReviewProfileImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
    }
}

protocol ReviewProfileCellDelegate: class {
    func reviewProfileCell(_ reviewProfileCell: ReviewProfileCell,
                           loadImageForModel model: ReviewViewProfileModel,
                           imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) -> UIImage?
    func reviewProfileCell(_ reviewProfileCell: ReviewProfileCell,
                           cancelLoadingImageForModel model: ReviewViewProfileModel)
}

class ReviewProfileCell: UITableViewCell {
    static let identifier = "ReviewProfileCell"

    lazy var profileImage: UIImageView = {
        let image = ReviewProfileImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    lazy var name: UILabel = {
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

    lazy var separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ice
        return view
    }()

    var model: ReviewViewProfileModel? {
        didSet {
            guard let model = model else { return }
            name.text = model.name
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
        contentView.addSubview(separator)

        NSLayoutConstraint.activate([
            profileStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
            profileStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: .mediumLargeSpacing),
            profileStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -.mediumLargeSpacing),
            profileStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumSpacing),
            profileImage.heightAnchor.constraint(equalToConstant: 44),
            profileImage.widthAnchor.constraint(equalToConstant: 44),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: .mediumSpacing),
            separator.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -.mediumSpacing),
            separator.heightAnchor.constraint(equalToConstant: 2),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
        name.text = ""
    }

    func loadImage() {
        guard let model = model else { return }
        profileImage.image = delegate?.reviewProfileCell(self,
                                                         loadImageForModel: model,
                                                         imageWidth: 44,
                                                         completion: { [weak self] image in
                                                             if image != nil {
                                                                 self?.profileImage.image = image
                                                             }
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
