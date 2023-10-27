//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class FavoriteFolderSelectableViewCell: RemoteImageTableViewCell {
    private let titleLabelDefaultFont: UIFont = .bodyRegular
    private let titleLabelSelectedFont: UIFont = .bodyStrong
    private var isEditable = true

    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView.checkmarkImageView
        imageView.isHidden = true
        return imageView
    }()

    private lazy var editModeView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .background
        view.isHidden = true
        return view
    }()

    private lazy var stackViewToCheckmarkConstraint = stackView.trailingAnchor.constraint(
        equalTo: checkmarkImageView.leadingAnchor,
        constant: -.spacingM
    )

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
        checkmarkImageView.backgroundColor = .backgroundPrimary
    }

    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        checkmarkImageView.backgroundColor = .backgroundPrimary
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

    // MARK: - Public

    public func configure(with viewModel: FavoriteFolderViewModel, isEditing: Bool, isEditable: Bool) {
        super.configure(with: viewModel)

        self.isEditable = isEditable
        let showDetailLabel = viewModel.detailText != nil

        stackViewToCheckmarkConstraint.isActive = !showDetailLabel
        stackViewTrailingAnchorConstraint.isActive = !stackViewToCheckmarkConstraint.isActive

        if isEditing {
            separatorInset = UIEdgeInsets.leadingInset((.spacingXL + .spacingXS) * 2 + viewModel.imageViewWidth)
        } else if viewModel.isSelected {
            titleLabel.font = titleLabelSelectedFont
        }

        isLoadingEnabled = !viewModel.isXmas

        if viewModel.isXmas {
            fallbackImage = UIImage(named: .favoritesXmasFolder)
        }

        checkmarkImageView.isHidden = !viewModel.isSelected || isEditing || showDetailLabel
        setNeedsLayout()
    }

    // MARK: - Private methods

    private func setup() {
        tintColor = .backgroundPrimary
        subtitleLabel.textColor = .textSubtle

        contentView.addSubview(checkmarkImageView)
        addSubview(editModeView)

        NSLayoutConstraint.activate([
            checkmarkImageView.heightAnchor.constraint(equalToConstant: .spacingM),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: .spacingM),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            stackViewToCheckmarkConstraint,

            editModeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            editModeView.trailingAnchor.constraint(equalTo: contentView.leadingAnchor),
            editModeView.topAnchor.constraint(equalTo: topAnchor),
            editModeView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
