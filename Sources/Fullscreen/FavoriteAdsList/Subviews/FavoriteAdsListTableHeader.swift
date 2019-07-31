//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class FavoriteAdsListTableHeader: UIView {

    // MARK: - Internal properties

    weak var delegate: FavoriteAdsListTableHeaderDelegate?

    internal var searchBarPlaceholder: String = "" {
        didSet { searchBar.placeholder = searchBarPlaceholder }
    }

    internal var title: String = "" {
        didSet { titleLabel.text = title }
    }

    internal var subtitle: String = "" {
        didSet { subtitleLabel.text = subtitle }
    }

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .title2
        label.textAlignment = .center
        label.textColor = .licorice
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .caption
        label.textAlignment = .center
        label.textColor = .licorice
        return label
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(withAutoLayout: true)
        searchBar.backgroundColor = .milk
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(searchBar)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .smallSpacing),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            searchBar.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
        ])
    }
}
