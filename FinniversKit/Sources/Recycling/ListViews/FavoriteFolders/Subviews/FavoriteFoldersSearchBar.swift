//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class FavoriteFoldersSearchBar: BottomShadowView {
    weak var delegate: UISearchBarDelegate? {
        didSet {
            searchBar.delegate = delegate
        }
    }

    private(set) lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(withAutoLayout: true)
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .background
        return searchBar
    }()

    var text: String? {
        get { return searchBar.text }
        set {
            searchBar.text = newValue
            delegate?.searchBar?(searchBar, textDidChange: newValue ?? "")
        }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    func configure(withPlaceholder placeholder: String?) {
        searchBar.placeholder = placeholder
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .background
        addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingS)
        ])
    }
}
