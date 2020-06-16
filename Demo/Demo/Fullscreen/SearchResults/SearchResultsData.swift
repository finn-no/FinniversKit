import FinnUI

class RecentSearchData: SearchResultsListViewModel {
    public let title = "Siste søk"
    public let icon = UIImage(named: .arrowCounterClockwise)
    public let showDeleteRowIcons = true
    public let buttonTitle: String? = "Fjern all søkehistorikk"
}

class SavedSearchData: SearchResultsListViewModel {
    public let title = "Lagrede søk"
    public let icon = UIImage(named: .magnifyingGlass)
    public let showDeleteRowIcons = false
    public let buttonTitle: String? = "Se alle dine lagrede søk"
}
