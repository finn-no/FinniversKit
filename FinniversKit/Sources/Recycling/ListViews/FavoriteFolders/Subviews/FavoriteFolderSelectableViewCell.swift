//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

public class FavoriteFolderSelectableViewCell: RemoteImageTableViewCell {
    private let titleLabelDefaultFont: UIFont = .body
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

    private lazy var swipeHighlightBackgroundView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .clear
        view.layer.cornerRadius = Warp.Spacing.spacing300
        view.layer.cornerCurve = .continuous
        return view
    }()

    private var normalSeparatorInset: UIEdgeInsets?

    private lazy var stackViewToCheckmarkConstraint = stackView.trailingAnchor.constraint(
        equalTo: checkmarkImageView.leadingAnchor,
        constant: -Warp.Spacing.spacing200
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
        if let normalSeparatorInset {
            separatorInset = normalSeparatorInset
        }
        normalSeparatorInset = nil
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

    public override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        swipeHighlightBackgroundView.backgroundColor = state.isSwiped ? Warp.UIToken.backgroundSubtle : .clear
        updateSeparator(for: state)
    }

    // MARK: - Public

    public func configure(with viewModel: FavoriteFolderViewModel, isEditing: Bool, isEditable: Bool) {
        super.configure(with: viewModel)

        self.isEditable = isEditable
        let showDetailLabel = viewModel.detailText != nil

        stackViewToCheckmarkConstraint.isActive = !showDetailLabel
        stackViewTrailingAnchorConstraint.isActive = !stackViewToCheckmarkConstraint.isActive

        if isEditing {
            separatorInset = UIEdgeInsets.leadingInset((Warp.Spacing.spacing400 + Warp.Spacing.spacing50) * 2 + viewModel.imageViewWidth)
        } else if viewModel.isSelected {
            titleLabel.font = titleLabelSelectedFont
        }

        normalSeparatorInset = separatorInset
        updateSeparator(for: configurationState)

        checkmarkImageView.isHidden = !viewModel.isSelected || isEditing || showDetailLabel
        setNeedsLayout()
    }

    // MARK: - Private methods

    private func setup() {
        tintColor = .backgroundPrimary
        subtitleLabel.textColor = .textSubtle

        contentView.insertSubview(swipeHighlightBackgroundView, at: 0)
        contentView.addSubview(checkmarkImageView)
        addSubview(editModeView)

        NSLayoutConstraint.activate([
            swipeHighlightBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            swipeHighlightBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            swipeHighlightBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            swipeHighlightBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: FavoriteFoldersListView.minimumRowHeight),

            checkmarkImageView.heightAnchor.constraint(equalToConstant: Warp.Spacing.spacing200),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: Warp.Spacing.spacing200),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Warp.Spacing.spacing200),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            stackViewToCheckmarkConstraint,

            editModeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            editModeView.trailingAnchor.constraint(equalTo: contentView.leadingAnchor),
            editModeView.topAnchor.constraint(equalTo: topAnchor),
            editModeView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func updateSeparator(for state: UICellConfigurationState) {
        guard let normalSeparatorInset else { return }
        separatorInset = state.isSwiped ? .leadingInset(.greatestFiniteMagnitude) : normalSeparatorInset
    }

}
