//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

public protocol PaymentOptionsListViewCellDelegate: AnyObject {}

public class PaymentOptionsListViewCell: UITableViewCell {
    // MARK: - Public properties

    public weak var delegate: PaymentOptionsListViewCellDelegate?

    // MARK: - Private properties

    private lazy var selectionBox: SelectionboxItem = {
        let animatedImageView = AnimatedRadioButtonView(frame: .zero)
        let selectionBox = SelectionboxItem(index: 0, animatedImageView: animatedImageView)
        selectionBox.translatesAutoresizingMaskIntoConstraints = false
        return selectionBox
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .captionStrong
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .caption
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()

    private lazy var detailLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .title3
        label.textColor = .textPrimary
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 2
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var seperator: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .sardine
        view.isHidden = true
        return view
    }()

    // MARK: - Setup

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    public func configure(with viewModel: PaymentOptionsListViewModel, indexPath: IndexPath, isPreselected: Bool = false) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle

        if let detailText = viewModel.detailText {
            detailLabel.text = detailText
        }

        showSelectionCircle(isPreselected)
        separatorInset = .leadingInset(.mediumLargeSpacing)
    }

    public func showSeperator(_ shouldShow: Bool) {
        seperator.isHidden = !shouldShow
    }

    public func showSelectionCircle(_ shouldShow: Bool) {
        selectionBox.isSelected = shouldShow
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
    }

    // MARK: - Private methods

    private func setup() {
        backgroundColor = .bgPrimary

        contentView.addSubview(selectionBox)
        contentView.addSubview(stackView)
        contentView.addSubview(detailLabel)
        contentView.addSubview(seperator)

        NSLayoutConstraint.activate([
            selectionBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectionBox.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            selectionBox.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            selectionBox.widthAnchor.constraint(lessThanOrEqualToConstant: 24),

            stackView.leadingAnchor.constraint(equalTo: selectionBox.trailingAnchor, constant: .mediumLargeSpacing),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: detailLabel.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: selectionBox.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: selectionBox.bottomAnchor),

            detailLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            detailLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            seperator.heightAnchor.constraint(equalToConstant: 1/UIScreen.main.scale),
            seperator.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            seperator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            seperator.topAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
