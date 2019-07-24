//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class FavoriteFolderSelectableViewCell: RemoteImageTableViewCell {
    public enum Style {
        case regular
        case edit
        case disabled
    }

    // MARK: - Private properties

    private let titleLabelDefaultFont: UIFont = .body
    private let titleLabelSelectedFont: UIFont = .bodyStrong
    private var previousSeparatorInset: CGFloat = 0

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

        let selectedBackgroundView = UIView()
        self.selectedBackgroundView = selectedBackgroundView

        if self.isEditing {
            selectedBackgroundView.backgroundColor = .clear
        } else {
            selectedBackgroundView.backgroundColor = .defaultCellSelectedBackgroundColor
        }
    }

    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        checkmarkImageView.backgroundColor = .primaryBlue
    }

    // MARK: - Public

    public func configure(with viewModel: FavoriteFolderViewModel, style: Style) {
        super.configure(with: viewModel)
        stackViewTrailingAnchorConstraint.isActive = false

        let editSeparateInset = UIEdgeInsets.leadingInset((.largeSpacing + .smallSpacing) * 2 + viewModel.imageViewWidth)

        switch style {
        case .regular:
            contentView.alpha = 1
            separatorInset = .leadingInset(.mediumLargeSpacing * 2 + viewModel.imageViewWidth)
            remoteImageLeadingConstraint.constant = .mediumLargeSpacing

            if viewModel.isSelected {
                titleLabel.font = titleLabelSelectedFont
                checkmarkImageView.isHidden = false
            }
        case .edit:
            contentView.alpha = 1
            separatorInset = editSeparateInset
            remoteImageLeadingConstraint.constant = .mediumLargeSpacing
            checkmarkImageView.isHidden = true
        case .disabled:
            contentView.alpha = 0.5
            separatorInset = editSeparateInset
            remoteImageLeadingConstraint.constant = 54
            checkmarkImageView.isHidden = true
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
