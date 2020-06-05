import Foundation

public protocol SearchResultsViewDataSource: AnyObject {
    func numberOfSegments(in view: SearchResultsView) -> Int
    func searchResultsView(_ view: SearchResultsView, titleForSegment: Int) -> String
    func searchResultsView(_ view: SearchResultsView, iconForSegment: Int) -> UIImage
    func searchResultsView(_ view: SearchResultsView, numberOfRowsInSegment: Int) -> Int
    func searchResultsView(_ view: SearchResultsView, segment: Int, textForRow: Int) -> String
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

    private lazy var containerView = UIView(withAutoLayout: true)

    private let segments = [SearchResultsListView]()

    private lazy var recentSearchesList: SearchResultsListView = {
        let view = SearchResultsListView(title: "Siste søk")
        return view
    }()

    private lazy var savedSearchesList: SearchResultsListView = {
        let view = SearchResultsListView(title: "Lagrede søk")
        return view
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

    private func setup() {
        addSubview(segmentedControl)
        addSubview(separatorLine)
        addSubview(containerView)

        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            segmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: .spacingM),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),

            containerView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: .spacingM),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc func handleSegmentChange() {
        selectedSegment = segmentedControl.selectedSegmentIndex
    }
}
