import UIKit
import Warp

public extension UIViewController {

    enum NavigationItemBarAppearance {
        case transparent // liquid glass on iOS 26, on older iOS it is noShadowDefaultBackground
        case opaque
        case noShadowDefaultBackground
        case noShadowWithCustomBackground(UIColor)
    }

    // MARK: - Large Title Configuration

    /// Configures whether the navigation bar uses large titles.
    /// - Parameter enabled: Set to true for large title, false for inline title.
    func configureLargeTitle(enabled: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = enabled
        navigationItem.largeTitleDisplayMode = enabled ? .always : .never
    }

    // MARK: - Shadow Configuration

    /// Configures the navigation bar shadow (separator line) visibility.
    /// - Parameter hidden: Set to true to hide the shadow, false to show it.
    func configureNavigationBarShadow(hidden: Bool) {
        guard let navBar = navigationController?.navigationBar else { return }
        let appearance = navBar.standardAppearance.copy()
        appearance.shadowColor = hidden ? .clear : UIColor.separator
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
    }

    // MARK: - Search Bar Configuration

    /// Configures a search bar in the navigation bar.
    /// - Parameter placeholder: The placeholder text for the search bar. Pass nil to remove the search bar.
    func configureNavigationSearchBar(placeholder: String?) {
        if let placeholder = placeholder {
            let searchController = UISearchController(searchResultsController: nil)
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = placeholder
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            navigationItem.searchController = nil
        }
    }

    // MARK: - Right Bar Button Items Configuration

    /// Configures the right bar button items.
    /// - Parameters:
    ///   - items: The bar button items to display. Pass nil or empty array to clear.
    ///   - includeSearchIcon: If true, appends a search icon that calls `didTapSearchIcon` when tapped.
    func configureRightBarButtonItems(_ items: [UIBarButtonItem]?, includeSearchIcon: Bool = false) {
        var rightButtons: [UIBarButtonItem] = items ?? []
        if includeSearchIcon {
            let searchIcon = UIBarButtonItem(
                image: UIImage(systemName: "magnifyingglass"),
                style: .plain,
                target: self,
                action: #selector(didTapSearchIcon)
            )
            rightButtons.append(searchIcon)
        }
        navigationItem.rightBarButtonItems = rightButtons.isEmpty ? nil : rightButtons
    }

    /// Override this in your VC if you use `includeSearchIcon = true` in `configureRightBarButtonItems`.
    @objc func didTapSearchIcon() {
        // Present your search UI here.
    }

    // MARK: - Convenience Method

    /// Convenience method to configure multiple navigation bar aspects at once.
    /// - Parameters:
    ///   - prefersLargeTitle: Set to true for large title, false for inline, or nil to skip.
    ///   - hideShadow: Set to true to hide shadow, false to show, or nil to skip.
    ///   - searchBarPlaceholder: Placeholder for search bar, or nil to remove/skip.
    ///   - showsSearchIcon: If true, adds a search icon to right bar buttons.
    ///   - rightBarButtonItems: Additional right bar buttons to show.
    func configureNavigationBar(
        prefersLargeTitle: Bool? = nil,
        hideShadow: Bool? = nil,
        searchBarPlaceholder: String? = nil,
        showsSearchIcon: Bool = false,
        rightBarButtonItems: [UIBarButtonItem]? = nil
    ) {
        if let prefersLargeTitle = prefersLargeTitle {
            configureLargeTitle(enabled: prefersLargeTitle)
        }

        if let hideShadow = hideShadow {
            configureNavigationBarShadow(hidden: hideShadow)
        }

        configureNavigationSearchBar(placeholder: searchBarPlaceholder)
        configureRightBarButtonItems(rightBarButtonItems, includeSearchIcon: showsSearchIcon)
    }

    /// Configures navigation item appearance for the current view controller.
    func configureNavigationItemAppearance(_ appearance: NavigationItemBarAppearance) {
        switch appearance {
        case .transparent:
            // Only run iOS 26 code on Xcode 26, atm our CI still run on Xcode 16
            #if compiler(>=6.2)
            // Liquid Glass on iOS 26
            if #available(iOS 26, *) {
                navigationItem.configureWithTransparentAppearance()
                extendedLayoutIncludesOpaqueBars = true
            } else {
                navigationItem.configureWithNoShadowAppearance()
            }
            #else
            navigationItem.configureWithNoShadowAppearance()
            #endif
        case .opaque:
            navigationItem.configureWithOpaqueAppearance()
        case .noShadowDefaultBackground:
            navigationItem.configureWithNoShadowAppearance()
        case .noShadowWithCustomBackground(let noShadowBackgroundColor):
            navigationItem.configureWithNoShadowAppearance(backgroundColor: noShadowBackgroundColor)
        }
    }
}
