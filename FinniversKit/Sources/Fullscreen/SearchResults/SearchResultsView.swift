import Foundation

public protocol SearchResultsViewDataSource: AnyObject {
    func numberOfSegments(in view: SearchResultsView) -> Int
    func searchResultsView(_ view: SearchResultsView, titleForSegment segment: Int) -> String
    func searchResultsView(_ view: SearchResultsView, iconForSegment segment: Int) -> UIImage
    func searchResultsView(_ view: SearchResultsView, numberOfRowsInSegment segment: Int) -> Int
    func searchResultsView(_ view: SearchResultsView, segment: Int, textForRow row: Int) -> String
}

public class SearchResultsView: UIView {

    // MARK: - Public properties

    public weak var dataSource: SearchResultsViewDataSource?

    public var selectedSegment: Int = 0 {
        didSet { segmentedControl.selectedSegmentIndex = selectedSegment }
    }

    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(withAutoLayout: true)
        segmentedControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return segmentedControl
    }()

    private lazy var separatorLine: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .tableViewSeparator
        return view
    }()

    private var segmentViews = [SearchResultsListView]()
    private var segmentTitles: [String]?

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.isPagingEnabled = true
        scrollView.clipsToBounds = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()

    private lazy var listView = SearchResultsListView(icon: UIImage(named: .magnifyingGlass))

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

    // MARK: - Public methods

    public func reloadData() {
        if segmentViews.isEmpty {
            setupSegmentedControl()
        }
    }

    public func loadData(for segment: Int) {
        guard let dataSource = dataSource else { return }
        var rows = [String]()
        for row in 0 ..< dataSource.searchResultsView(self, numberOfRowsInSegment: segment) {
            rows.append(dataSource.searchResultsView(self, segment: segment, textForRow: row))
        }
        segmentViews[segment].configure(with: rows)
        layoutIfNeeded()
    }

    private func setup() {
        addSubview(segmentedControl)
        addSubview(separatorLine)
        addSubview(scrollView)

        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            segmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: .spacingM),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),

            scrollView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: segmentSpacing),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupSegmentedControl() {
        guard let dataSource = dataSource else {
            return
        }

        segmentTitles = []

        var spacings: [CGFloat] = [0, segmentSpacing].reversed()
        var insertAnchor = scrollView.leadingAnchor

        for segment in 0 ..< dataSource.numberOfSegments(in: self) {
            let title = dataSource.searchResultsView(self, titleForSegment: segment)
            let icon = dataSource.searchResultsView(self, iconForSegment: segment)
            segmentedControl.insertSegment(withTitle: title, at: segment, animated: false)
            segmentTitles?.append(title)

            let view = SearchResultsListView(icon: icon)
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

    @objc func handleSegmentChange() {
        selectedSegment = segmentedControl.selectedSegmentIndex
        scrollToView(at: selectedSegment)
    }

    func scrollToView(at index: Int) {
        guard let view = segmentViews[safe: index] else { return }
        scrollView.setContentOffset(view.frame.origin, animated: true)
    }
}

extension SearchResultsView: UIScrollViewDelegate {

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == self.scrollView else { return }
        selectedSegment = Int(targetContentOffset.pointee.x / scrollView.bounds.width)
    }
}
