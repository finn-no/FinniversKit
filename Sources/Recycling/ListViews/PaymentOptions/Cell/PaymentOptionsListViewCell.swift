//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

public class PaymentOptionsListViewCell: UITableViewCell {
    // MARK: - Private properties

    private lazy var selectionBox: SelectionboxItem = {
        let animatedImageView = AnimatedRadioButtonView(frame: .zero)
        let selectionBox = SelectionboxItem(index: 0, animatedImageView: animatedImageView)
        selectionBox.translatesAutoresizingMaskIntoConstraints = false
        return selectionBox
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .captionStrong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private var detailLabel: Label = Label(style: .title3, withAutoLayout: true)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel])
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

        if let subtitleText = viewModel.subtitle {
            subtitleLabel.text = subtitleText

            guard subtitleLabel.isDescendant(of: stackView) == false else { return }
            stackView.addArrangedSubview(subtitleLabel)
        }

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
            selectionBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumSpacing),
            selectionBox.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
            selectionBox.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumLargeSpacing),
            selectionBox.widthAnchor.constraint(lessThanOrEqualToConstant: 24),

            stackView.leadingAnchor.constraint(equalTo: selectionBox.trailingAnchor, constant: .mediumLargeSpacing),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: detailLabel.leadingAnchor, constant: -.mediumSpacing),
            stackView.topAnchor.constraint(equalTo: selectionBox.topAnchor),

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
