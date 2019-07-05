//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class FavoriteFoldersSearchBar: UIView {
    weak var delegate: UISearchBarDelegate? {
        didSet {
            searchBar.delegate = delegate
        }
    }

    private let maxShadowRadius: CGFloat = 3

    private(set) lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(withAutoLayout: true)
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .milk
        return searchBar
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        let rect = CGRect(x: 0, y: bounds.maxY - maxShadowRadius, width: bounds.width, height: maxShadowRadius)
        layer.shadowPath = UIBezierPath(rect: rect).cgPath
    }

    // MARK: - Setup

    func configure(withPlaceholder placeholder: String) {
        searchBar.placeholder = placeholder
    }

    func updateShadow(using scrollView: UIScrollView) {
        let contentFrame = CGRect(
            x: -scrollView.contentOffset.x,
            y: scrollView.frame.minY - scrollView.contentOffset.y - scrollView.contentInset.top,
            width: scrollView.contentSize.width,
            height: scrollView.contentSize.height + scrollView.contentInset.top
        )

        let intersection = contentFrame.intersection(frame)
        layer.shadowRadius = min(intersection.height * 0.2, maxShadowRadius)
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .white
        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 0
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor

        addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
