import FinniversKit

class SelectorTitleViewDemoView: UIView {
    lazy var selectorTitleView: SelectorTitleView = {
        let selectorTitleView = SelectorTitleView()
        return selectorTitleView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        selectorTitleView.title = "Hei!"
        selectorTitleView.delegate = self

        addSubview(selectorTitleView)
        NSLayoutConstraint.activate([
            selectorTitleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectorTitleView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectorTitleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectorTitleView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension SelectorTitleViewDemoView: SelectorTitleViewDelegate {
    func selectorTitleViewDidSelectButton(_ selectorTitleView: SelectorTitleView) {
        print(":D")
    }
}
