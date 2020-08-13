//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol SearchFilterTagCellDelegate: AnyObject {
    func searchFilterTagCellDidSelectRemove(_ cell: SearchFilterTagCell)
}

public protocol SearchFilterTagCellViewModel {
    var title: String { get }
    var titleAccessibilityLabel: String { get }
    var removeButtonAccessibilityLabel: String { get }
    var isValid: Bool { get }
}

final class SearchFilterTagCell: UICollectionViewCell {
    weak var delegate: SearchFilterTagCellDelegate?

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = SearchFilterTagsView.font
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .textTertiary
        label.textAlignment = .center
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

        let leading = SearchFilterTagCell.titleLeading
        let buttonWidth = SearchFilterTagCell.removeButtonWidth

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leading),
            titleLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            removeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            removeButton.widthAnchor.constraint(equalToConstant: buttonWidth),
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
    private static let removeButtonEdgeInsets = UIEdgeInsets(leading: .spacingS, trailing: .spacingS)

    private static var removeButtonWidth: CGFloat {
        return 14 + removeButtonEdgeInsets.leading + removeButtonEdgeInsets.trailing
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
