//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class FavoriteAdsSectionHeaderView: UITableViewHeaderFooterView {

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .detailStrong
        label.textColor = .textSecondary
        return label
    }()

    private lazy var detailLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .detailStrong
        label.textColor = .textPrimary
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
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingS),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.spacingS),
            titleLabel.trailingAnchor.constraint(equalTo: detailLabel.leadingAnchor, constant: -.spacingS),

            detailLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingS),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.spacingS)
        ])
    }

    // MARK: - Internal methods

    func configure(title: String, detail: String? = nil) {
        titleLabel.text = title.uppercased()
        detailLabel.text = detail?.uppercased()
    }
}
