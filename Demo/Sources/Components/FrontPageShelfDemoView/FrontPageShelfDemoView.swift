import FinniversKit

class FrontPageShelfDemoView: UIView {
    private lazy var shelfView: FrontPageShelfView = {
        let view = FrontPageShelfView(withAutoLayout: true)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(shelfView)
        shelfView.fillInSuperview()
    }
}
