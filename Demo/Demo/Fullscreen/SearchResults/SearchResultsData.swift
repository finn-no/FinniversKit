import FinniversKit

class RecentSearchData: SearchResultsViewModel {
    public let title = "Siste søk"
    public let icon = UIImage(named: .republish)
    public let showDeleteRowIcons = true
    public let buttonTitle: String? = "Fjern all søkehistorikk"
}

class SavedSearchData: SearchResultsViewModel {
    public let title = "Lagrede søk"
    public let icon = UIImage(named: .magnifyingGlass)
    public let showDeleteRowIcons = false
    public let buttonTitle: String? = "Se alle dine lagrede søk"
}
