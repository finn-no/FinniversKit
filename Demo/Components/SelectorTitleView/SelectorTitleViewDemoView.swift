import FinniversKit
import Bootstrap

class SelectorTitleViewDemoView: UIView {
    lazy var selectorTitleView = SelectorTitleView(heading: "Tap to change")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .red
        selectorTitleView.title = "Arrow is down"
        selectorTitleView.delegate = self

        addSubview(selectorTitleView)
        NSLayoutConstraint.activate([
            selectorTitleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectorTitleView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectorTitleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectorTitleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }
}

extension SelectorTitleViewDemoView: SelectorTitleViewDelegate {
    func selectorTitleViewDidSelectButton(_ selectorTitleView: SelectorTitleView) {
        let arrowIsUp = selectorTitleView.arrowDirection == .up
        selectorTitleView.arrowDirection = arrowIsUp ? .down : .up
        selectorTitleView.title = arrowIsUp ? "Arrow is down" : "Arrow is up"
    }
}
