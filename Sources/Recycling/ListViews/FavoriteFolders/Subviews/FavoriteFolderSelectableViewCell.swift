//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class FavoriteFolderSelectableViewCell: RemoteImageTableViewCell {
    // MARK: - Private properties

    private let titleLabelDefaultFont: UIFont = .body
    private let titleLabelSelectedFont: UIFont = .bodyStrong
    private var previousSeparatorInset: CGFloat = 0

    private lazy var rightCheckmarkView = CheckmarkView(withAutoLayout: true)

    private lazy var leftCheckmarkView: CheckmarkView = {
        let view = CheckmarkView(withAutoLayout: true)
        view.isBordered = true
        return view
    }()

    private lazy var editModeView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .milk
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
        editModeView.backgroundColor = selected ? .defaultCellSelectedBackgroundColor : .milk
        updateCheckmarks()
    }

    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        editModeView.backgroundColor = highlighted ? .defaultCellSelectedBackgroundColor : .milk
        updateCheckmarks()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.font = titleLabelDefaultFont
        hideCheckmarks()
    }

    public override func willTransition(to state: UITableViewCell.StateMask) {
        super.willTransition(to: state)
        bringSubviewToFront(editModeView)
        hideCheckmarks()
    }

    // MARK: - Public

    public func configure(with viewModel: FavoriteFolderViewModel, isEditing: Bool, isEditable: Bool) {
        super.configure(with: viewModel)

        stackViewTrailingAnchorConstraint.isActive = false

        if isEditing {
            separatorInset = UIEdgeInsets.leadingInset((.largeSpacing + .smallSpacing) * 2 + viewModel.imageViewWidth)
        } else if viewModel.isSelected {
            titleLabel.font = titleLabelSelectedFont
        }

        selectCheckmarks(viewModel.isSelected)
        leftCheckmarkView.isHidden = !isEditing || !isEditable
        rightCheckmarkView.isHidden = isEditing

        contentView.alpha = isEditing && !isEditable ? 0.5 : 1
        setNeedsLayout()
    }

    // MARK: - Private methods

    private func setup() {
        contentView.addSubview(rightCheckmarkView)
        addSubview(editModeView)
        editModeView.addSubview(leftCheckmarkView)

        NSLayoutConstraint.activate([
            rightCheckmarkView.heightAnchor.constraint(equalToConstant: .mediumLargeSpacing),
            rightCheckmarkView.widthAnchor.constraint(equalTo: rightCheckmarkView.heightAnchor),
            rightCheckmarkView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            rightCheckmarkView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            stackView.trailingAnchor.constraint(equalTo: rightCheckmarkView.leadingAnchor, constant: -.mediumLargeSpacing),

            editModeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            editModeView.trailingAnchor.constraint(equalTo: contentView.leadingAnchor),
            editModeView.topAnchor.constraint(equalTo: topAnchor),
            editModeView.bottomAnchor.constraint(equalTo: bottomAnchor),

            leftCheckmarkView.heightAnchor.constraint(equalToConstant: 24),
            leftCheckmarkView.widthAnchor.constraint(equalTo: leftCheckmarkView.heightAnchor),
            leftCheckmarkView.centerXAnchor.constraint(equalTo: editModeView.centerXAnchor, constant: .mediumSpacing),
            leftCheckmarkView.centerYAnchor.constraint(equalTo: editModeView.centerYAnchor),
        ])
    }

    private func selectCheckmarks( _ selected: Bool) {
        leftCheckmarkView.isSelected = selected
        rightCheckmarkView.isSelected = selected
    }

    private func hideCheckmarks() {
        leftCheckmarkView.isHidden = true
        rightCheckmarkView.isHidden = true
    }

    private func updateCheckmarks() {
        leftCheckmarkView.updateSelectionStyles()
        rightCheckmarkView.updateSelectionStyles()
    }
}

// MARK: - Private types

private final class CheckmarkView: UIView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .check)
        imageView.tintColor = .milk
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var isBordered: Bool = false {
        didSet {
            layer.borderWidth = isBordered ? 1 : 0
        }
    }

    var isSelected: Bool = false {
        didSet {
            updateSelectionStyles()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.borderColor = .sardine
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }

    func updateSelectionStyles() {
        backgroundColor = isSelected ? .primaryBlue : .clear
        layer.borderWidth = isBordered && !isSelected ? 1 : 0
        imageView.isHidden = !isSelected
    }
}
