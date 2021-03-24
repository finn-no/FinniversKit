import FinniversKit

class PromoSlidesDemoView: UIView {

    private lazy var promoSlidesView: PromoSlidesView = {
        let view = PromoSlidesView()
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
        addSubview(promoSlidesView)

        NSLayoutConstraint.activate([
            promoSlidesView.leadingAnchor.constraint(equalTo: leadingAnchor),
            promoSlidesView.trailingAnchor.constraint(equalTo: trailingAnchor),
            promoSlidesView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        let promoSlide = BasicPromoSlideView()
        promoSlide.configure(
            with: "Smidig bilhandel? Prøv\nFINNs nye prosess!",
            buttonTitle: "Se hvordan det virker",
            image: UIImage(named: .carPromo)
        )
        promoSlide.delegate = self

        let promoSlide2 = BasicPromoSlideView()
        promoSlide2.configure(
            with: "Some other promo!",
            buttonTitle: "Try",
            image: UIImage(named: .carPromo)
        )
        promoSlide2.delegate = self

        promoSlidesView.configure(withSlides: [promoSlide, promoSlide2])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension PromoSlidesDemoView: BasicPromoSlideViewDelegate {
    func basicPromoSlideViewDidTapButton(_ basicPromoSlideView: BasicPromoSlideView) {
        print("Did tap button!")
    }
}
