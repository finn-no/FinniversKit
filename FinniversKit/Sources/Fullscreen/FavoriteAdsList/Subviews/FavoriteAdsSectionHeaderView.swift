//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

class FavoriteAdsSectionHeaderView: UITableViewHeaderFooterView {

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .detailStrong
        label.textColor = .textSubtle
        return label
    }()

    private lazy var detailLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .detailStrong
        label.textColor = .text
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
        contentView.backgroundColor = .surfaceSunken
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Warp.Spacing.spacing100),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Warp.Spacing.spacing200),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Warp.Spacing.spacing100),
            titleLabel.trailingAnchor.constraint(equalTo: detailLabel.leadingAnchor, constant: -Warp.Spacing.spacing100),

            detailLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Warp.Spacing.spacing100),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Warp.Spacing.spacing200),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Warp.Spacing.spacing100)
        ])
    }

    // MARK: - Internal methods

    func configure(title: String, detail: String? = nil) {
        titleLabel.text = title.uppercased()
        detailLabel.text = detail?.uppercased()
    }
}
