import FinniversKit

final class SearchResultsDemoView: UIView {

    private lazy var searchResultsView: SearchResultsView = {
        let view = SearchResultsView()
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

    func setup() {
        searchResultsView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchResultsView)
        searchResultsView.fillInSuperview()
        searchResultsView.reloadData()
        searchResultsView.loadData(for: 0)
        searchResultsView.loadData(for: 1)
    }

    let lastSearches = [
        "Adidas sneakers",
        "Fjellräven sekk",
        "Studentbolig",
        "Nike sneakers",
        "Munnbind",
    ]

    let savedSearches = [
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

    func searchResultsView(_ view: SearchResultsView, titleForSegment segment: Int) -> String {
        return segment == 0 ? "Siste søk" : "Lagrede søk"
    }

    func searchResultsView(_ view: SearchResultsView, iconForSegment segment: Int) -> UIImage {
        return segment == 0 ? UIImage(named: .republish) : UIImage(named: .magnifyingGlass)
    }

    func searchResultsView(_ view: SearchResultsView, numberOfRowsInSegment segment: Int) -> Int {
        return segment == 0 ? lastSearches.count : savedSearches.count
    }

    func searchResultsView(_ view: SearchResultsView, segment: Int, textForRow row: Int) -> String {
        return segment == 0 ? lastSearches[row] : savedSearches[row]
    }
}
