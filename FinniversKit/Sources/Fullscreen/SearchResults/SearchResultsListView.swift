import Foundation

protocol SearchResultsListViewDelegate: AnyObject {
    func searchResultsListView(_ searchResultsListView: SearchResultsListView, didSelectSearchAt index: Int)
}

class SearchResultsListView: UIView {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        return stackView
    }()

    weak var delegate: SearchResultsListViewDelegate?

    let icon: UIImage

    init(icon: UIImage) {
        self.icon = icon
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
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }

    func configure(with rows: [String]) {
        stackView.removeArrangedSubviews()
        for row in rows {
            let rowView = SearchResultsRowView(icon: icon)
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
}
