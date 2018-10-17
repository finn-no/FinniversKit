//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class FavoriteFoldersListViewCell: UITableViewCell {
    // MARK: - Internal properties

    private lazy var titleLabel: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.numberOfLines = 2
        return label
    }()

    private lazy var detailLabel: Label = {
        let label = Label(style: .detail)
        label.textColor = .stone
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()

    @objc lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.addArrangedSubview(self.titleLabel)
        view.addArrangedSubview(self.detailLabel)

        return view
    }()

    private lazy var arrowImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .center
        view.image = UIImage(named: FinniversImageAsset.arrowRight)

        return view
    }()

    // MARK: - Setup

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        isAccessibilityElement = true

        contentView.addSubview(stackView)
        contentView.addSubview(arrowImageView)

        let arrowSize: CGFloat = 20
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumSpacing),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            stackView.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -.mediumLargeSpacing),

            arrowImageView.widthAnchor.constraint(equalToConstant: arrowSize),
            arrowImageView.heightAnchor.constraint(equalToConstant: arrowSize),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            // We use "greaterThanOrEqualTo" instead of "equalTo" because otherwise we get an AutoLayout error
            arrowImageView.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing)
            ])
    }

    // MARK: - Superclass Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        detailLabel.text = nil
        accessibilityLabel = ""
    }

    // MARK: - Dependency injection

    /// The model contains data used to populate the view.
    public var model: FavoriteFoldersListViewModel? {
        didSet {
            if let model = model {
                titleLabel.text = model.title
                detailLabel.text = model.detail
                accessibilityLabel = model.accessibilityLabel
            }
        }
    }
}
