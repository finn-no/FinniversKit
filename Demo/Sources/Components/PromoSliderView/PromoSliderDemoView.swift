import FinniversKit

class PromoSliderDemoView: UIView {

    private lazy var promoSliderView: PromoSliderView = {
        let view = PromoSliderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(promoSliderView)

        NSLayoutConstraint.activate([
            promoSliderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            promoSliderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            promoSliderView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        let motorTransactionPromoSlide = MotorTransactionPromoSlideView()
        motorTransactionPromoSlide.configure(
            with: "Smidig bilhandel? Prøv\nFINNs nye prosess!",
            buttonTitle: "Se hvordan det virker",
            image: UIImage(named: .carPromo)
        )

        promoSliderView.configure(withSlides: [motorTransactionPromoSlide])
    }
}
