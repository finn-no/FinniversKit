//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol FavoriteAdsListTableHeaderDelegate: AnyObject {
    func favoriteAdsListTableHeader(_ tableHeader: FavoriteAdsListTableHeader, didSelectSortingView view: UIView)
    func favoriteAdsListTableHeader(_ tableHeader: FavoriteAdsListTableHeader, didSelectShareButton button: UIButton)
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

    var title = "" {
        didSet { titleLabel.text = title }
    }

    var subtitle = "" {
        didSet { updateSubtitle() }
    }

    var shareButtonTitle = "" {
        didSet { updateSubtitle() }
    }

    var sortingTitle = "" {
        didSet { sortingView.title = sortingTitle }
    }

    var titleLabelFrame: CGRect {
        return CGRect(origin: contentStackView.frame.origin, size: titleLabel.frame.size)
    }

    // MARK: - Private properties

    private lazy var tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleViewTap))

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleView, searchBar, sortingContainerView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.setCustomSpacing(.smallSpacing, after: titleLabel)
        stackView.setCustomSpacing(24, after: subtitleView)
        stackView.setCustomSpacing(28, after: searchBar)
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = UIFont(name: FontType.bold.rawValue, size: 28)?.scaledFont(forTextStyle: .title2)
        label.textAlignment = .center
        label.textColor = .textPrimary
        label.numberOfLines = 3
        return label
    }()

    private lazy var subtitleView: SubtitleView = {
        let view = SubtitleView()
        view.delegate = self
        return view
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(withAutoLayout: true)
        searchBar.backgroundColor = .bgPrimary
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

    private lazy var sortingContainerView = UIView()

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
        sortingContainerView.addSubview(sortingView)

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            sortingView.leadingAnchor.constraint(equalTo: sortingContainerView.leadingAnchor),
            sortingView.topAnchor.constraint(equalTo: sortingContainerView.topAnchor),
            sortingView.bottomAnchor.constraint(equalTo: sortingContainerView.bottomAnchor),

            searchBar.heightAnchor.constraint(equalToConstant: 36),
        ])
    }

    private func updateSubtitle() {
        subtitleView.configure(withText: subtitle, buttonTitle: shareButtonTitle)
    }

    @objc private func handleSortingViewTap() {
        searchBar.resignFirstResponder()
        delegate?.favoriteAdsListTableHeader(self, didSelectSortingView: sortingView)
    }

    @objc private func handleViewTap() {
        searchBar.resignFirstResponder()
    }
}

// MARK: - SubtitleViewDelegate

extension FavoriteAdsListTableHeader: SubtitleViewDelegate {
    func subtitleView(_ view: SubtitleView, didSelectButton button: UIButton) {
        delegate?.favoriteAdsListTableHeader(self, didSelectShareButton: button)
    }
}
