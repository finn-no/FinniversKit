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

    var isSearchBarHidden = false {
        didSet {
            searchBar.isHidden = isSearchBarHidden
        }
    }

    var searchBarPlaceholder: String = "" {
        didSet { searchBar.placeholder = searchBarPlaceholder }
    }

    var searchBarText: String {
        get { return searchBar.text ?? "" }
        set { searchBar.text = newValue }
    }

    var title: String = "" {
        didSet { titleLabel.text = title }
    }

    var subtitle: String = "" {
        didSet { subtitleLabel.text = subtitle }
    }

    var sortingTitle: String = "" {
        didSet { sortingView.title = sortingTitle }
    }

    var titleLabelFrame: CGRect {
        return CGRect(origin: contentStackView.frame.origin, size: titleLabel.frame.size)
    }

    // MARK: - Private properties

    private lazy var tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleViewTap))

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, searchBar, sortingView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.setCustomSpacing(.smallSpacing, after: titleLabel)
        stackView.setCustomSpacing(24, after: subtitleLabel)
        stackView.setCustomSpacing(37, after: searchBar)
        return stackView
    }()

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

    var isSortingViewHidden: Bool {
        get { return sortingView.isHidden }
        set { sortingView.isHidden = newValue }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addGestureRecognizer(tapRecognizer)

        addSubview(contentStackView)

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing),

            searchBar.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    @objc private func handleSortingViewTap() {
        searchBar.resignFirstResponder()
        delegate?.favoriteAdsListTableHeaderDidSelectSortingView(self)
    }

    @objc private func handleViewTap() {
        searchBar.resignFirstResponder()
    }
}
