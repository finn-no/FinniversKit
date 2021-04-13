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

        promoSlidesView.configure(withSlides: [promoSlide, promoSlide2])
    }
}

extension PromoSlidesDemoView: BasicPromoSlideViewDelegate {
    func basicPromoSlideViewDidTapButton(_ basicPromoSlideView: BasicPromoSlideView) {
        print("Did tap promo button!")
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

private class MotorTransactionEntryViewModel: TransactionEntryViewModel {
    var title: String = "Kontrakt"
    var text: String = "Kjøper har signert, nå mangler bare din signatur."
    var imageUrl: String? = "https://finn-content-hub.imgix.net/bilder/Motor/Toma%CC%8Aterbil_Toppbilde.jpg?auto=compress&crop=focalpoint&domain=finn-content-hub.imgix.net&fit=crop&fm=jpg&fp-x=0.5&fp-y=0.5&h=900&ixlib=php-3.3.0&w=1600"
    var showWarningIcon: Bool = false
    var fallbackImage: UIImage = UIImage(named: .transactionJourneyCar)
}
