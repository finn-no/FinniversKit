import FinniversKit

protocol SearchResultsListViewDelegate: AnyObject {
    func searchResultsListView(_ searchResultsListView: SearchResultsListView, didSelectSearchAt index: Int)
    func searchResultsListView(_ searchResultsListView: SearchResultsListView, didDeleteSearchAt index: Int)
    func searchResultsListViewDidTapButton(_ searchResultsListView: SearchResultsListView)
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

    private lazy var button: Button = {
        let button = Button(style: .flat, withAutoLayout: true)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    weak var delegate: SearchResultsListViewDelegate?

    private let viewModel: SearchResultsListViewModel

    // MARK: - Init

    init(viewModel: SearchResultsListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        addSubview(button)

        if let buttonTitle = viewModel.buttonTitle {
            button.setTitle(buttonTitle, for: .normal)
        } else {
            button.isHidden = true
        }

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXS),
            stackView.topAnchor.constraint(equalTo: topAnchor),

            button.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: .spacingM),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }

    // MARK: - Internal methods

    func configure(with rows: [String]) {
        stackView.removeArrangedSubviews()
        for row in rows {
            let rowView = SearchResultsRowView(viewModel: viewModel)
            rowView.delegate = self
            rowView.configure(with: row)
            stackView.addArrangedSubview(rowView)
        }
    }

    // MARK: - Actions

    @objc func buttonTapped() {
        delegate?.searchResultsListViewDidTapButton(self)
    }
}

// MARK: - SearchResultsRowViewDelegate

extension SearchResultsListView: SearchResultsRowViewDelegate {
    func searchResultsRowViewDidSelectButton(_ searchResultsRowView: SearchResultsRowView) {
        guard let index = stackView.arrangedSubviews.firstIndex(of: searchResultsRowView) else { return }
        delegate?.searchResultsListView(self, didSelectSearchAt: index)
    }

    func searchResultsRowViewDidSelectDeleteButton(_ searchResultsRowView: SearchResultsRowView) {
        guard let index = stackView.arrangedSubviews.firstIndex(of: searchResultsRowView) else { return }
        delegate?.searchResultsListView(self, didDeleteSearchAt: index)
    }
}
