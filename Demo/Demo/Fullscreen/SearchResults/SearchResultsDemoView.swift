import FinniversKit

final class SearchResultsDemoView: UIView {

    private lazy var searchResultsView: SearchResultsView = {
        let view = SearchResultsView()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(searchResultsView)
        searchResultsView.fillInSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
