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

        let promoSlide = TransactionEntrySlideView(
            title: "Du har en oppdatering i den\nsiste salgsprosessen",
            transactionEntryViewModel: MotorTransactionEntryViewModel(),
            transactionEntryViewDelegate: self,
            remoteImageViewDataSource: self
        )

        let promoSlide2 = BasicPromoSlideView()
        promoSlide2.configure(
            with: "Smidig bilhandel? Prøv\nFINNs nye prosess!",
            buttonTitle: "Se hvordan det virker",
            image: UIImage(named: .carPromo)
        )
        promoSlide2.delegate = self

        let promoSlide3 = BasicPromoSlideView()
        promoSlide3.configure(
            with: "Ønsker du å fortsette søket i Fritid, hobby og underholdning?",
            buttonTitle: "Fortsett søket",
            image: UIImage(named: .hobbyIllustration),
            scaleImageToFit: true
        )
        promoSlide3.delegate = self

        promoSlidesView.configure(withSlides: [promoSlide, promoSlide2, promoSlide3])
    }
}

extension PromoSlidesDemoView: BasicPromoSlideViewDelegate {
    func basicPromoSlideViewDidTapButton(_ basicPromoSlideView: BasicPromoSlideView) {
        print("Did tap button!")
    }
}

extension PromoSlidesDemoView: TransactionEntryViewDelegate {
    func transactionEntryViewWasTapped(_ transactionEntryView: TransactionEntryView) {
        print("Did tap transaction entry!")
    }
}

extension PromoSlidesDemoView: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        return nil
    }

    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            usleep(50_000)
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }

        task.resume()
    }

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}
