import FinnUI

class RecentSearchData: SearchResultsListViewModel {
    let title = "Siste søk"
    let icon = UIImage(named: .arrowCounterClockwise)
    let showDeleteRowIcons = true
    let buttonTitle: String? = "Fjern all søkehistorikk"
}

class SavedSearchData: SearchResultsListViewModel {
    let title = "Lagrede søk"
    let icon = UIImage(named: .magnifyingGlass)
    let showDeleteRowIcons = false
    let buttonTitle: String? = "Se alle dine lagrede søk"
}
