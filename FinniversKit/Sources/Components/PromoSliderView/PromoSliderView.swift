import Foundation

public class PromoSliderView: UIView {

    private lazy var slideView: UIView = {
        let view = UIView(withAutoLayout: true)
        return view
    }()

    public init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .primaryBlue

        addSubview(slideView)
        slideView.fillInSuperview()
    }

    public func configure(withSlides slides: [UIView]) {
        let firstView = slides.first!

        slideView.addSubview(firstView)
        firstView.fillInSuperview()
    }
}
