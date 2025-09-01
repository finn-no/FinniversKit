//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

protocol FavoriteAdsListTableHeaderDelegate: AnyObject {
    func favoriteAdsListTableHeader(_ tableHeader: FavoriteAdsListTableHeader, didSelectSortingView view: UIView)
    func favoriteAdsListTableHeader(_ tableHeader: FavoriteAdsListTableHeader, didSelectShareButton button: UIButton)
}

class FavoriteAdsListTableHeader: UIView {

    // MARK: - Internal properties

    var viewModel: FavoriteAdsListViewModel?
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
    private lazy var contentStackView = UIStackView(axis: .vertical, withAutoLayout: true)
    private lazy var messagesStackView = UIStackView(axis: .vertical, spacing: Warp.Spacing.spacing100, withAutoLayout: true)
    private lazy var sortingContainerView = UIView()

    private lazy var titleLabel: Label = {
        let label = Label(
            style: .title2,
            numberOfLines: 0,
            withAutoLayout: true
        )
        label.textAlignment = .center
        return label
    }()

    private lazy var subtitleView: SubtitleView = {
        let view = SubtitleView()
        view.delegate = self
        return view
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(withAutoLayout: true)
        searchBar.backgroundColor = .background
        searchBar.searchBarStyle = .minimal
        searchBar.maximumContentSizeCategory = .extraExtraLarge
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
        sortingContainerView.addSubview(sortingView)

        contentStackView.addArrangedSubviews([titleLabel, subtitleView, messagesStackView, searchBar, sortingContainerView])
        contentStackView.setCustomSpacing(Warp.Spacing.spacing50, after: titleLabel)
        contentStackView.setCustomSpacing(Warp.Spacing.spacing300, after: subtitleView)
        contentStackView.setCustomSpacing(Warp.Spacing.spacing200, after: messagesStackView)
        contentStackView.setCustomSpacing(Warp.Spacing.spacing300 + Warp.Spacing.spacing50, after: searchBar)

        addSubview(contentStackView)

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing200),
            contentStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Warp.Spacing.spacing200),
            contentStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Warp.Spacing.spacing200),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            sortingView.leadingAnchor.constraint(equalTo: sortingContainerView.leadingAnchor),
            sortingView.topAnchor.constraint(equalTo: sortingContainerView.topAnchor),
            sortingView.bottomAnchor.constraint(equalTo: sortingContainerView.bottomAnchor),
            sortingView.trailingAnchor.constraint(lessThanOrEqualTo: sortingContainerView.trailingAnchor),

            searchBar.heightAnchor.constraint(equalToConstant: 36),
        ])
    }

    // MARK: - Internal methods

    func configure(infoMessages: [FavoriteAdsListMessageKind]) {
        messagesStackView.removeArrangedSubviews()
        messagesStackView.isHidden = infoMessages.isEmpty

        let messageViews = infoMessages.map { $0.createView() }
        messagesStackView.addArrangedSubviews(messageViews)

        layoutIfNeeded()
    }

    // MARK: - Private methods

    private func updateSubtitle() {
        subtitleView.configure(withText: subtitle, buttonTitle: shareButtonTitle)
    }

    // MARK: - Actions

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

// MARK: - Private extensions

private extension FavoriteAdsListMessageKind {
    func createView() -> UIView {
        switch self {
        case let .message(message, backgroundColor):
            return createPanel(message: message, backgroundColor: backgroundColor)
        case let .infobox(title, message, style):
            return createInfobox(title: title, message: message, style: style)
        }
    }

    private func createPanel(message: String, backgroundColor: UIColor) -> Panel {
        let panel = Panel(style: .tips, withAutoLayout: true)
        panel.configure(with: PanelViewModel(text: message))
        panel.backgroundColor = backgroundColor
        return panel
    }

    private func createInfobox(title: String, message: String, style: InfoboxView.Style) -> InfoboxView {
        let infobox = InfoboxView(style: style, withAutoLayout: true)
        infobox.model = FavoriteInfoboxMessage(title: title, message: message)
        return infobox
    }

    private struct FavoriteInfoboxMessage: InfoboxViewModel {
        let title: String
        let detail: String
        let primaryButtonTitle: String = ""
        let secondaryButtonTitle: String = ""

        init(title: String, message: String) {
            self.title = title
            self.detail = message
        }
    }
}
