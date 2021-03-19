import FinniversKit

class PromoLinkDemoView: UIView {

    private lazy var promoLinkView: PromoLinkView = {
        let view = PromoLinkView(delegate: self)
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
        addSubview(promoLinkView)
        NSLayoutConstraint.activate([
            promoLinkView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            promoLinkView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            promoLinkView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        promoLinkView.configure(with: PromoViewModel())
    }
}

extension PromoLinkDemoView: PromoLinkViewDelegate {
    func promoLinkViewWasTapped(_ promoLinkView: PromoLinkView) {
        print("Tapped promo link!")
    }
}

private class PromoViewModel: PromoLinkViewModel {
    var title: String = "Smidig bilhandel? Prøv FINNs nye prosess!"
    var image: UIImage = UIImage(named: .transactionJourneyCar)
}
