import FinniversKit

public class CollapseDemoView: UIView {
    let regular = OrderSummaryView(model: OrderSummaryViewRegularDefaultData(), withAutoLayout: true)
    let car = OrderSummaryView(model: OrderSummaryViewCarDefaultData(), withAutoLayout: true)

    private lazy var collapseView: CollapseView = {
        let view = CollapseView(collapsedTitle: "Vis oppsummering", expandedTitle: "Skjul oppsummering",
                                     presentViewInExpandedState: regular, heightOfView: regular.height, withAutoLayout: true)
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
            collapseView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.largeSpacing),
        ])
    }
}

extension CollapseDemoView: CollapseViewDelegate {
    public func didExpand(_ view: CollapseView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.collapseView.presentViewInExpandedState(self.car, heightOfView: self.car.height)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.collapseView.presentViewInExpandedState(self.regular, heightOfView: self.regular.height)
            })
        })
    }

    public func didCollapse(_ view: CollapseView) {}
}
