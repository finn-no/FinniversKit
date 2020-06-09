import Foundation

protocol SearchResultsListViewDelegate: AnyObject {
    func searchResultsListView(_ searchResultsListView: SearchResultsListView, didSelectSearchAt index: Int)
    func searchResultsListView(_ searchResultsListView: SearchResultsListView, didDeleteRowAt index: Int)
}

public protocol SearchResultsListViewModel {
    var title: String { get }
    var icon: UIImage { get }
    var showDeleteRowIcons: Bool { get }
    var buttonTitle: String? { get }
}

class SearchResultsListView: UIView {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()

    weak var delegate: SearchResultsListViewDelegate?

    let viewModel: SearchResultsListViewModel

    init(viewModel: SearchResultsListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXS),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }

    func configure(with rows: [String]) {
        stackView.removeArrangedSubviews()
        for row in rows {
            let rowView = SearchResultsRowView(viewModel: viewModel)
            rowView.delegate = self
            rowView.configure(with: row)
            stackView.addArrangedSubview(rowView)
        }
    }
}

extension SearchResultsListView: SearchResultsRowViewDelegate {
    func searchResultsRowViewDidSelectButton(_ searchResultsRowView: SearchResultsRowView) {
        guard let index = stackView.arrangedSubviews.firstIndex(of: searchResultsRowView) else { return }
        delegate?.searchResultsListView(self, didSelectSearchAt: index)
    }

    func searchResultsRowViewDidSelectDeleteButton(_ searchResultsRowView: SearchResultsRowView) {
        guard let index = stackView.arrangedSubviews.firstIndex(of: searchResultsRowView) else { return }
        delegate?.searchResultsListView(self, didDeleteRowAt: index)
    }
}
