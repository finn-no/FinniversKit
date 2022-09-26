import FinniversKit

final public class BadgeDemoView: UIView {

    // MARK: - Internal properties

    private lazy var view = BadgeView()

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup() {
        addSubview(view)
        view.centerInSuperview()

        let viewModel = BadgeViewModel(
            title: "Fiks ferdig",
            icon: UIImage(named: .bapShippable)
        )

        view.configure(with: viewModel)
    }
}
