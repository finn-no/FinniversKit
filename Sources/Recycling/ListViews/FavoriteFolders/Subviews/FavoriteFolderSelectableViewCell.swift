//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class FavoriteFolderSelectableViewCell: RemoteImageTableViewCell {

    // MARK: - Private properties

    private let titleLabelDefaultFont: UIFont = .body
    private let titleLabelSelectedFont: UIFont = .bodyStrong

    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .primaryBlue
        imageView.image = UIImage(named: .check)
        imageView.tintColor = .milk
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()

    // MARK: - Init

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.font = titleLabelDefaultFont
        checkmarkImageView.isHidden = true
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkmarkImageView.backgroundColor = .primaryBlue
    }

    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        checkmarkImageView.backgroundColor = .primaryBlue
    }

    // MARK: - Public

    public func configure(with viewModel: FavoriteFolderViewModel) {
        super.configure(with: viewModel)
        stackViewTrailingAnchorConstraint.isActive = false

        if viewModel.isSelected {
            titleLabel.font = titleLabelSelectedFont
            checkmarkImageView.isHidden = false
        }
        setNeedsLayout()
    }

    // MARK: - Private methods

    private func setup() {
        contentView.addSubview(checkmarkImageView)

        NSLayoutConstraint.activate([
            checkmarkImageView.heightAnchor.constraint(equalToConstant: .mediumLargeSpacing),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: .mediumLargeSpacing),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            stackView.trailingAnchor.constraint(equalTo: checkmarkImageView.leadingAnchor, constant: -.mediumLargeSpacing)
        ])
    }
}
