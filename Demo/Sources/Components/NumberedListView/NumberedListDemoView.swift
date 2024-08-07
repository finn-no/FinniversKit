import FinniversKit
import DemoKit
import Warp

class NumberedListDemoView: UIView {

    // MARK: - Private properties

    private let items = NumberedDemoListItem.demoItems
    private lazy var scrollView = UIScrollView(withAutoLayout: true)

    private lazy var numberedListView: NumberedListView = {
        let view = NumberedListView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configure(forTweakAt: 0)
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        directionalLayoutMargins = NSDirectionalEdgeInsets(all: Warp.Spacing.spacing100)

        addSubview(scrollView)
        scrollView.fillInSuperviewLayoutMargins()
        scrollView.alwaysBounceVertical = true

        scrollView.addSubview(numberedListView)
        numberedListView.fillInSuperview(margin: Warp.Spacing.spacing200)
        numberedListView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -Warp.Spacing.spacing400).isActive = true
    }
}

extension NumberedListDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case itemsWithTitleBodyAndButtons
        case itemsWithTitleAndBody
        case itemsWithOnlyBody
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .itemsWithTitleBodyAndButtons:
            numberedListView.configure(with: items)
        case .itemsWithTitleAndBody:
            let itemsWithoutButtons = items.map { NumberedDemoListItem(title: $0.heading, body: $0.body) }
            numberedListView.configure(with: itemsWithoutButtons)
        case .itemsWithOnlyBody:
            let itemsWithoutBodyOrButtons = items.map { NumberedDemoListItem(body: $0.body) }
            numberedListView.configure(with: itemsWithoutBodyOrButtons)
        }
    }
}

// MARK: - NumberedListViewDelegate

extension NumberedListDemoView: NumberedListViewDelegate {
    public func numberedListView(_ view: NumberedListView, didSelectActionButtonForItemAt itemIndex: Int) {
        print("✅ Did select button at index: \(itemIndex)")
    }
}

// MARK: - Private extensions

private struct NumberedDemoListItem: NumberedListItem {
    let heading: String?
    let body: String
    let actionButtonTitle: String?

    init(title: String? = nil, body: String, actionButtonTitle: String? = nil) {
        self.heading = title
        self.body = body
        self.actionButtonTitle = actionButtonTitle
    }

    static var demoItems: [NumberedDemoListItem] {
        [
            NumberedDemoListItem(
                title: "Leverage agile frameworks",
                body: "Iterative approaches to corporate strategy foster collaborative thinking to further the overall value proposition. Organically grow the holistic world view of disruptive innovation via workplace diversity and empowerment.",
                actionButtonTitle: "Some action"
            ),
            NumberedDemoListItem(
                title: "Bring win-win survival strategies to the table",
                body: "At the end of the day, going forward, a new normal that has evolved from generation X is on the runway heading towards a streamlined cloud solution. User generated content in real-time will have multiple touchpoints for offshoring."
            ),
            NumberedDemoListItem(
                title: "Capitalize on low hanging fruit",
                body: "Override the digital divide with additional clickthroughs from DevOps. Nanotechnology immersion along the information highway will close the loop on focusing solely on the bottom line.",
                actionButtonTitle: "Some other action"
            ),
            NumberedDemoListItem(
                title: "Use workflows to establish a framework",
                body: "Taking seamless key performance indicators offline to maximise the long tail. Keeping your eye on the ball while performing a deep dive on the start-up mentality to derive convergence on cross-platform integration."
            ),
            NumberedDemoListItem(
                title: "Collaboratively administrate empowered networks",
                body: "Dynamically procrastinate B2C users after installed base benefits. Dramatically visualize customer directed convergence without revolutionary ROI.",
                actionButtonTitle: "Yet another action"
            ),
            NumberedDemoListItem(
                title: "Efficiently unleash cross-media information",
                body: "Quickly maximize timely deliverables for real-time schemas. Dramatically maintain clicks-and-mortar solutions without functional solutions."
            )
        ]
    }
}
