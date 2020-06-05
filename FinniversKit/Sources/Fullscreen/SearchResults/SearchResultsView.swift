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

    private lazy var recentSearchesList: SearchResultsListView = {
        let view = SearchResultsListView(title: "Siste søk")
        return view
    }()

    private lazy var savedSearchesList: SearchResultsListView = {
        let view = SearchResultsListView(title: "Lagrede søk")
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.isPagingEnabled = true
        scrollView.clipsToBounds = false
        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.delegate = self
        return scrollView
    }()

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
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: .spacingM),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupSegmentedControl() {
        guard let dataSource = dataSource else {
            return
        }

        segmentTitles = []

        var insertAnchor = scrollView.leadingAnchor

        for segment in 0 ..< dataSource.numberOfSegments(in: self) {
            let title = dataSource.searchResultsView(self, titleForSegment: segment)
            segmentedControl.insertSegment(withTitle: title, at: segment, animated: false)
            segmentTitles?.append(title)

            let view = SearchResultsListView(title: "xx")
            view.translatesAutoresizingMaskIntoConstraints = false
            segmentViews.append(view)
            scrollView.addSubview(view)
            view.backgroundColor = segment == 0 ? .red : .blue

            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: insertAnchor),
                view.topAnchor.constraint(equalTo: scrollView.topAnchor),
                view.widthAnchor.constraint(equalTo: widthAnchor),
                view.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            ])

            insertAnchor = view.trailingAnchor
        }

        scrollView.trailingAnchor.constraint(equalTo: insertAnchor).isActive = true
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
