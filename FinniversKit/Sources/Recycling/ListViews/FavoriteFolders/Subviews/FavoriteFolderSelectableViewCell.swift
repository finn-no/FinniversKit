//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

public class FavoriteFolderSelectableViewCell: RemoteImageTableViewCell {
    // Keep UIKit separators offscreen without overflowing CoreGraphics calculations.
    private static let hiddenSeparatorInset: CGFloat = 10_000
    private let titleLabelDefaultFont: UIFont = .body
    private let titleLabelStrongFont: UIFont = .bodyStrong
    private var isEditable = true
    private var shouldUseStrongTitleFont = false

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

    private lazy var separatorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .border
        view.isUserInteractionEnabled = false
        return view
    }()

    private var normalSeparatorInset: UIEdgeInsets?
    private lazy var separatorTrailingConstraint = separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    private lazy var minimumRowHeightConstraint = contentView.heightAnchor.constraint(
        greaterThanOrEqualToConstant: FavoriteFoldersListView.minimumRowHeight
    )

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
        if #available(iOS 26, *) {
            separatorView.isHidden = false
            separatorTrailingConstraint.constant = 0
        }
        shouldUseStrongTitleFont = false
        minimumRowHeightConstraint.constant = FavoriteFoldersListView.minimumRowHeight
        titleLabel.font = titleLabelDefaultFont
        checkmarkImageView.isHidden = true
    }

    public override func willTransition(to state: UITableViewCell.StateMask) {
        super.willTransition(to: state)
        bringSubviewToFront(editModeView)

        contentView.alpha = state == .showingEditControl && !isEditable ? 0.5 : 1
        editModeView.isHidden = isEditable
        titleLabel.font = shouldUseStrongTitleFont && !state.contains(.showingEditControl)
            ? titleLabelStrongFont
            : titleLabelDefaultFont
        checkmarkImageView.isHidden = true
    }

    public override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        swipeHighlightBackgroundView.backgroundColor = state.isSwiped ? Warp.UIToken.backgroundSubtle : .clear
        updateSeparator(for: state)
    }

    // MARK: - Public

    public func configure(
        with viewModel: FavoriteFolderViewModel,
        isEditing: Bool,
        isEditable: Bool,
        usesCompactPickerRows: Bool = false
    ) {
        super.configure(with: viewModel)

        self.isEditable = isEditable
        let showDetailLabel = viewModel.detailText != nil

        stackViewToCheckmarkConstraint.isActive = !showDetailLabel
        stackViewTrailingAnchorConstraint.isActive = !stackViewToCheckmarkConstraint.isActive

        if #available(iOS 26, *) {
            // Use a divider tied to the title; UIKit's separator offset changes as rows are reused.
            separatorInset = .leadingInset(Self.hiddenSeparatorInset)
        } else {
            let separatorLeadingInset = isEditing
                ? (Warp.Spacing.spacing400 + Warp.Spacing.spacing50) * 2 + viewModel.imageViewWidth
                : Warp.Spacing.spacing200 * 2 + viewModel.imageViewWidth
            separatorInset = .leadingInset(separatorLeadingInset)
        }
        let usesPickerLayout: Bool
        if #available(iOS 26, *) {
            usesPickerLayout = usesCompactPickerRows
            separatorTrailingConstraint.constant = usesPickerLayout ? -Warp.Spacing.screenMargin : 0
        } else {
            usesPickerLayout = false
        }
        minimumRowHeightConstraint.constant = usesPickerLayout
            ? FavoriteFoldersListView.pickerMinimumRowHeight
            : FavoriteFoldersListView.minimumRowHeight
        shouldUseStrongTitleFont = usesPickerLayout || (!isEditing && viewModel.isSelected)
        titleLabel.font = shouldUseStrongTitleFont ? titleLabelStrongFont : titleLabelDefaultFont

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
        if #available(iOS 26, *) {
            contentView.addSubview(separatorView)
        }
        addSubview(editModeView)

        if #available(iOS 26, *) {
            stackViewTopAnchorConstraint.isActive = false
            stackViewBottomAnchorConstraint.isActive = false
            NSLayoutConstraint.activate([
                stackView.centerYAnchor.constraint(equalTo: remoteImageView.centerYAnchor),
                stackView.topAnchor.constraint(
                    greaterThanOrEqualTo: contentView.topAnchor,
                    constant: stackViewTopAnchorConstraint.constant
                ),
                stackView.bottomAnchor.constraint(
                    lessThanOrEqualTo: contentView.bottomAnchor,
                    constant: stackViewBottomAnchorConstraint.constant
                )
            ])
        }

        NSLayoutConstraint.activate([
            swipeHighlightBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            swipeHighlightBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            swipeHighlightBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            swipeHighlightBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            minimumRowHeightConstraint,

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

        if #available(iOS 26, *) {
            NSLayoutConstraint.activate([
                separatorView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                separatorTrailingConstraint,
                separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                separatorView.heightAnchor.constraint(equalToConstant: Warp.Border.borderWidth12)
            ])
        }
    }

    private func updateSeparator(for state: UICellConfigurationState) {
        guard let normalSeparatorInset else { return }
        separatorInset = state.isSwiped ? .leadingInset(Self.hiddenSeparatorInset) : normalSeparatorInset
        if #available(iOS 26, *) {
            separatorView.isHidden = state.isSwiped
        }
    }

}
