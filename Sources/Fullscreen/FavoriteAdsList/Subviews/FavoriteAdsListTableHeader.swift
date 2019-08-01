//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol FavoriteAdsListTableHeaderDelegate: AnyObject {
    func favoriteAdsListTableHeaderDidSelectSortingView(_ tableHeader: FavoriteAdsListTableHeader)
}

class FavoriteAdsListTableHeader: UIView {

    // MARK: - Internal properties

    weak var delegate: FavoriteAdsListTableHeaderDelegate?
    weak var searchBarDelegate: UISearchBarDelegate? {
        didSet { searchBar.delegate = searchBarDelegate }
    }

    internal var searchBarPlaceholder: String = "" {
        didSet { searchBar.placeholder = searchBarPlaceholder }
    }

    internal var title: String = "" {
        didSet { titleLabel.text = title }
    }

    internal var subtitle: String = "" {
        didSet { subtitleLabel.text = subtitle }
    }

    internal var sortingTitle: String = "" {
        didSet { sortingView.title = sortingTitle }
    }

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = UIFont(name: FontType.bold.rawValue, size: 28)?.scaledFont(forTextStyle: .title2)
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

    private lazy var sortingView: FavoriteAdsSortingView = {
        let sortingView = FavoriteAdsSortingView(withAutoLayout: true)
        sortingView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSortingViewTap))
        sortingView.addGestureRecognizer(tapGestureRecognizer)
        return sortingView
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
        addSubview(sortingView)

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

            sortingView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 37),
            sortingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            sortingView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing),
        ])
    }

    @objc private func handleSortingViewTap() {
        delegate?.favoriteAdsListTableHeaderDidSelectSortingView(self)
    }
}
