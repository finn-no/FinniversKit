import FinniversKit

public class CollapseDemoView: UIView {
    private lazy var orderSummaryView = OrderSummaryView(model: OrderSummaryViewDefaultData(), withAutoLayout: true)

    private lazy var collapseView: CollapseView = {
        let view = CollapseView(collapsedTitle: "Vis oppsummering", expandedTitle: "Skjul oppsummering",
                                contentViewHeight: orderSummaryView.height, withAutoLayout: true)
        view.delegate = self
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(collapseView)
        NSLayoutConstraint.activate([
            collapseView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collapseView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collapseView.topAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

extension CollapseDemoView: CollapseViewDelegate {
    public func showViewInExpandedState(_ view: CollapseView) -> UIView? {
        return orderSummaryView
    }

    public func willExpand(_ view: CollapseView) {}
    public func willCollapse(_ view: CollapseView) {}
}
