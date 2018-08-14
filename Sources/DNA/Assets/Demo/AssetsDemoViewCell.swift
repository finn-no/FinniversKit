import UIKit
import FinniversKit

class AssetsDemoViewCell: UITableViewCell {
    static let size: CGFloat = 70

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    lazy var iconImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()

    lazy var nameLabel: Label = {
        let label = Label(style: .body(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func setup() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumSpacing),
            iconImageView.widthAnchor.constraint(equalToConstant: AssetsDemoViewCell.size),
            iconImageView.heightAnchor.constraint(equalToConstant: AssetsDemoViewCell.size - 20),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .mediumSpacing),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ])
    }
}
