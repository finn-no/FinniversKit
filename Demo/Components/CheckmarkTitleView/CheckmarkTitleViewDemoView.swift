import FinniversKit

class CheckmarkTitleViewDemoView: UIView {
    private lazy var checkmarkTitleView = CheckmarkTitleView(title: "Example", withAutoLayout: true)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(checkmarkTitleView)
        checkmarkTitleView.fillInSuperview()
    }
}
