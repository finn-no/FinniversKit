//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class FavoriteAdsSectionHeaderView: UITableViewHeaderFooterView {

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .detailStrong
        label.textColor = .stone
        return label
    }()

    private lazy var detailLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .detailStrong
        label.textColor = .licorice
        label.textAlignment = .right
        return label
    }()

    // MARK: - Init

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Overrides

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        detailLabel.text = nil
    }

    // MARK: - Setup

    private func setup() {
        contentView.backgroundColor = .bgTertiary
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: detailLabel.leadingAnchor, constant: -.mediumSpacing),

            detailLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumSpacing)
        ])
    }

    // MARK: - Internal methods

    func configure(title: String, detail: String? = nil) {
        titleLabel.text = title.uppercased()
        detailLabel.text = detail?.uppercased()
    }
}
