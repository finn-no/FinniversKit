import FinnUI

final class SearchResultsDemoView: UIView {

    private lazy var searchResultsView: SearchResultsView = {
        let view = SearchResultsView(withAutoLayout: true)
        view.dataSource = self
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(searchResultsView)
        searchResultsView.fillInSuperview()
        searchResultsView.loadData(for: 0)
        searchResultsView.loadData(for: 1)
    }

    private let lastSearches = [
        "Adidas sneakers",
        "Fjellräven sekk",
        "Studentbolig",
        "Nike sneakers",
        "Munnbind",
    ]

    private let savedSearches = [
        "90-talls klær, Oslo",
        "Studentbolig, Bergen",
        "Fila klær, Oslo",
        "Studentbolig, Trondheim",
        "Studentbolig, Grünerløkka",
        "Drømmebolig, Grünerløkka",
    ]
}

extension SearchResultsDemoView: SearchResultsViewDataSource {
    func numberOfSegments(in view: SearchResultsView) -> Int {
        2
    }

    func searchResultsView(_ view: SearchResultsView, numberOfRowsInSegment segment: Int) -> Int {
        segment == 0 ? lastSearches.count : savedSearches.count
    }

    func searchResultsView(_ view: SearchResultsView, segment: Int, textForRow row: Int) -> String {
        segment == 0 ? lastSearches[row] : savedSearches[row]
    }

    func searchResultsView(_ view: SearchResultsView, viewModelFor segment: Int) -> SearchResultsListViewModel {
        segment == 0 ? RecentSearchData() : SavedSearchData()
    }
}
