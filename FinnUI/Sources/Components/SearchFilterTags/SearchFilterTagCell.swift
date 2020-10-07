//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol SearchFilterTagCellDelegate: AnyObject {
    func searchFilterTagCellDidSelectRemove(_ cell: SearchFilterTagCell)
    func searchFilterTagCellWasSelected(_ cell: SearchFilterTagCell)
}

final class SearchFilterTagCell: UICollectionViewCell {
    weak var delegate: SearchFilterTagCellDelegate?

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = {
        let label = InsetLabel(withAutoLayout: true)
        label.font = SearchFilterTagsView.font
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .textTertiary
        label.textAlignment = .center

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleFilterLabelTap))
        label.addGestureRecognizer(tapGestureRecognizer)
        label.isUserInteractionEnabled = true

        return label
    }()

    private lazy var removeButton: UIButton = {
        let button = RemoveButton(withAutoLayout: true)
        button.adjustsImageWhenHighlighted = false
        button.imageEdgeInsets = SearchFilterTagCell.removeButtonEdgeInsets
        button.addTarget(self, action: #selector(handleRemoveButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Overrides

    override var backgroundColor: UIColor? {
        didSet {
            if let backgroundColor = backgroundColor, backgroundColor.cgColor.alpha == 0 {
                self.backgroundColor = oldValue
            }
        }
    }

    // MARK: - Setup

    private func setup() {
        layer.cornerRadius = 8
        backgroundColor = .btnPrimary

        contentView.addSubview(titleLabel)
        contentView.addSubview(removeButton)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SearchFilterTagCell.titleLeading),
            titleLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            removeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            removeButton.widthAnchor.constraint(equalToConstant: SearchFilterTagCell.removeButtonWidth),
            removeButton.heightAnchor.constraint(equalTo: removeButton.widthAnchor),
        ])
    }

    // MARK: - Internal methods

    func configure(with viewModel: SearchFilterTagCellViewModel, icon: UIImage) {
        backgroundColor = viewModel.isValid ? .btnPrimary : .btnCritical

        titleLabel.text = viewModel.title
        titleLabel.accessibilityLabel = viewModel.titleAccessibilityLabel
        removeButton.accessibilityLabel = viewModel.removeButtonAccessibilityLabel
        removeButton.setImage(icon, for: .normal)
    }

    // MARK: - Actions

    @objc private func handleRemoveButtonTap() {
        delegate?.searchFilterTagCellDidSelectRemove(self)
    }

    @objc private func handleFilterLabelTap() {
        delegate?.searchFilterTagCellWasSelected(self)
    }
}

// MARK: - Size calculations

extension SearchFilterTagCell {
    static let height: CGFloat = 32
    static let minWidth: CGFloat = 56

    static func width(for title: String) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = title.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: SearchFilterTagsView.font],
            context: nil
        )

        return ceil(boundingBox.width) + titleLeading + removeButtonWidth
    }

    private static let titleLeading: CGFloat = .spacingS
    private static let removeButtonEdgeInsets = UIEdgeInsets(vertical: 0, horizontal: .spacingS)

    private static var removeButtonWidth: CGFloat {
        return 16 + removeButtonEdgeInsets.leading + removeButtonEdgeInsets.trailing
    }
}

// MARK: - Private types

private final class RemoveButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            updateAlpha(opaque: !isHighlighted)
        }
    }

    override var isSelected: Bool {
        didSet {
            updateAlpha(opaque: !isSelected)
        }
    }

    private func updateAlpha(opaque: Bool) {
        alpha = opaque ? 1 : 0.7
    }
}

// MARK: - Private classes

private class InsetLabel: UILabel {
    private static let verticalInset: CGFloat = .spacingS

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(vertical: InsetLabel.verticalInset, horizontal: 0)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width,
            height: size.height + 2 * InsetLabel.verticalInset
        )
    }
}
