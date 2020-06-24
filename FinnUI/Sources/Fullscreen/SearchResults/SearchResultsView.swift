import Foundation

public protocol SearchResultsViewDataSource: AnyObject {
    func numberOfSegments(in view: SearchResultsView) -> Int
    func searchResultsView(_ view: SearchResultsView, numberOfRowsInSegment segment: Int) -> Int
    func searchResultsView(_ view: SearchResultsView, segment: Int, textForRow row: Int) -> String
    func searchResultsView(_ view: SearchResultsView, viewModelFor segment: Int) -> SearchResultsListViewModel
}

public protocol SearchResultsViewDelegate: AnyObject {
    func searchResultsView(_ view: SearchResultsView, segment: Int, didSelectSearchAt index: Int)
    func searchResultsView(_ view: SearchResultsView, segment: Int, didDeleteSearchAt index: Int)
    func searchResultsView(_ view: SearchResultsView, didTapButtonForSegment segment: Int)
    func searchResultsView(_ view: SearchResultsView, didSelectSegment segment: Int)
}

public class SearchResultsView: UIView {

    // MARK: - Public properties

    public weak var delegate: SearchResultsViewDelegate?
    public weak var dataSource: SearchResultsViewDataSource? {
        didSet {
            setupSegmentedControl()
        }
    }

    public var selectedSegment: Int = 0 {
        didSet { segmentedControl.selectedSegmentIndex = selectedSegment }
    }

    // MARK: - Private properties

    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(withAutoLayout: true)
        segmentedControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return segmentedControl
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.isPagingEnabled = true
        scrollView.clipsToBounds = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()

    private var segmentViews = [SearchResultsListView]()
    private let segmentSpacing: CGFloat = .spacingS

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(segmentedControl)
        addSubview(scrollView)

        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            segmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            scrollView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: .spacingM),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: segmentSpacing),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupSegmentedControl() {
        guard let dataSource = dataSource else { return }
        segmentViews.removeAll()

        var spacings: [CGFloat] = [0, segmentSpacing].reversed()
        var insertAnchor = scrollView.leadingAnchor

        for segment in 0 ..< dataSource.numberOfSegments(in: self) {
            let viewModel = dataSource.searchResultsView(self, viewModelFor: segment)
            segmentedControl.insertSegment(withTitle: viewModel.title, at: segment, animated: false)

            let view = SearchResultsListView(viewModel: viewModel)
            view.delegate = self
            segmentViews.append(view)
            scrollView.addSubview(view)

            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: insertAnchor, constant: spacings.popLast() ?? 0),
                view.topAnchor.constraint(equalTo: scrollView.topAnchor),
                view.widthAnchor.constraint(equalTo: widthAnchor),
                view.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            ])

            insertAnchor = view.trailingAnchor
        }

        scrollView.trailingAnchor.constraint(equalTo: insertAnchor, constant: segmentSpacing).isActive = true
        segmentedControl.selectedSegmentIndex = selectedSegment

        scrollView.layoutIfNeeded()
    }

    // MARK: - Public methods

    public func loadData(for segment: Int) {
        guard let dataSource = dataSource else { return }
        var rows = [String]()
        for row in 0 ..< dataSource.searchResultsView(self, numberOfRowsInSegment: segment) {
            rows.append(dataSource.searchResultsView(self, segment: segment, textForRow: row))
        }
        segmentViews[segment].configure(with: rows)
    }

    // MARK: - Private methods

    private func scrollToView(at index: Int) {
        guard segmentViews.indices.contains(index) else { return }
        let view = segmentViews[index]
        scrollView.setContentOffset(view.frame.origin, animated: true)
    }

    // MARK: - Actions

    @objc func handleSegmentChange() {
        selectedSegment = segmentedControl.selectedSegmentIndex
        scrollToView(at: selectedSegment)
        delegate?.searchResultsView(self, didSelectSegment: selectedSegment)
    }
}

// MARK: - UIScrollViewDelegate

extension SearchResultsView: UIScrollViewDelegate {

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == self.scrollView else { return }
        let previousSegment = selectedSegment
        selectedSegment = Int(targetContentOffset.pointee.x / scrollView.bounds.width)
        if previousSegment != selectedSegment {
            delegate?.searchResultsView(self, didSelectSegment: selectedSegment)
        }
    }
}

// MARK: - SearchResultsListViewDelegate

extension SearchResultsView: SearchResultsListViewDelegate {
    func searchResultsListView(_ searchResultsListView: SearchResultsListView, didSelectSearchAt index: Int) {
        guard let segment = segmentViews.firstIndex(of: searchResultsListView) else { return }
        delegate?.searchResultsView(self, segment: segment, didSelectSearchAt: index)
    }

    func searchResultsListView(_ searchResultsListView: SearchResultsListView, didDeleteSearchAt index: Int) {
        guard let segment = segmentViews.firstIndex(of: searchResultsListView) else { return }
        delegate?.searchResultsView(self, segment: segment, didDeleteSearchAt: index)
    }

    func searchResultsListViewDidTapButton(_ searchResultsListView: SearchResultsListView) {
        guard let segment = segmentViews.firstIndex(of: searchResultsListView) else { return }
        delegate?.searchResultsView(self, didTapButtonForSegment: segment)
    }
}
