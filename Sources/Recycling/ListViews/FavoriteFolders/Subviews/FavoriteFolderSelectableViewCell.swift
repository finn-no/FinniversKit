//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class FavoriteFolderSelectableViewCell: RemoteImageTableViewCell {
    private let titleLabelDefaultFont: UIFont = .body
    private let titleLabelSelectedFont: UIFont = .bodyStrong
    private var previousSeparatorInset: CGFloat = 0
    private var isEditable = true

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

    private lazy var editModeView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .milk
        view.isHidden = true
        return view
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

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkmarkImageView.backgroundColor = .primaryBlue
    }

    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        checkmarkImageView.backgroundColor = .primaryBlue
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.font = titleLabelDefaultFont
        checkmarkImageView.isHidden = true
    }

    public override func willTransition(to state: UITableViewCell.StateMask) {
        super.willTransition(to: state)
        bringSubviewToFront(editModeView)

        contentView.alpha = state == .showingEditControl && !isEditable ? 0.5 : 1
        editModeView.isHidden = isEditable
        titleLabel.font = titleLabelDefaultFont
        checkmarkImageView.isHidden = true
    }

    public override func didTransition(to state: UITableViewCell.StateMask) {
        super.didTransition(to: state)
    }

    // MARK: - Public

    public func configure(with viewModel: FavoriteFolderViewModel, isEditing: Bool, isEditable: Bool) {
        super.configure(with: viewModel)

        self.isEditable = isEditable
        stackViewTrailingAnchorConstraint.isActive = false

        if isEditing {
            separatorInset = UIEdgeInsets.leadingInset((.largeSpacing + .smallSpacing) * 2 + viewModel.imageViewWidth)
        } else if viewModel.isSelected {
            titleLabel.font = titleLabelSelectedFont
        }

        checkmarkImageView.isHidden = !viewModel.isSelected || isEditing
        setNeedsLayout()
    }

    // MARK: - Private methods

    private func setup() {
        tintColor = .primaryBlue

        contentView.addSubview(checkmarkImageView)
        addSubview(editModeView)

        NSLayoutConstraint.activate([
            checkmarkImageView.heightAnchor.constraint(equalToConstant: .mediumLargeSpacing),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: .mediumLargeSpacing),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            stackView.trailingAnchor.constraint(equalTo: checkmarkImageView.leadingAnchor, constant: -.mediumLargeSpacing),

            editModeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            editModeView.trailingAnchor.constraint(equalTo: contentView.leadingAnchor),
            editModeView.topAnchor.constraint(equalTo: topAnchor),
            editModeView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
