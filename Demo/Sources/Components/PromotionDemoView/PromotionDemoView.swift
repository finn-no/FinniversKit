import UIKit
import FinniversKit
import DemoKit

class PromotionDemoView: UIView, Demoable {
    private lazy var viewModels: [PromotionViewModel] = [christmasPromoViewModel, hjerteromPromoViewModel]

    private let christmasPromoViewModel = PromotionViewModel(
        title: "Hjelp til jul hos FINN",
        image: UIImage(named: .christmasPromotion),
        imageAlignment: .trailing,
        primaryButtonTitle: "Be om eller tilby hjelp",
        secondaryButtonTitle: "Se annonsene"
    )

    private let hjerteromPromoViewModel = PromotionViewModel(
        title: "Hjerterom - hjelp til flyktninger",
        text: "Under Hjerterom kan du finne informasjon om hvordan du kan hjelpe flyktninger som kommer til Norge.",
        image: UIImage(named: .hjerterom),
        imageAlignment: .fullWidth,
        imageBackgroundColor: .btnAction,
        primaryButtonTitle: "Gå til Hjerterom"
    )

    private let transactionViewModel = FrontPageTransactionViewModel(
        id: "tjt",
        headerTitle: "Dine handler på torget",
        title: "Flotte lamper med gull greier",
        subtitle: "Velg en kjøper",
        imageUrl: "https://images.finncdn.no/dynamic/960w/2021/4/vertical-0/11/5/214/625/615_1292134726.jpg",
        adId: 1234,
        transactionId: nil
    )

    private lazy var transaction: FrontPageTransactionView = {
        let view = FrontPageTransactionView(withAutoLayout: true)
        view.delegate = self
        view.configure(with: transactionViewModel, andImageDatasource: self)
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingL, withAutoLayout: true)
        stackView.distribution = .fill
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        for viewModel in viewModels {
            let view = PromotionView(viewModel: viewModel)
            view.delegate = self
            stackView.addArrangedSubview(view)
        }

        stackView.addArrangedSubview(transaction)
    }
}

extension PromotionDemoView: PromotionViewDelegate {
    func promotionViewTapped(_ promotionView: PromotionView) {
        print("Promo tapped")
    }

    func promotionView(_ promotionView: PromotionView, didSelect action: PromotionView.Action) {
        print("Selected : \(action)")
    }
}

extension PromotionDemoView: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        nil
    }

    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        loadImage(imagePath: imagePath, completion: completion)
    }

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {
    }

    private func loadImage(imagePath: String, completion: @escaping((UIImage?) -> Void)) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

        // Demo Code
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
}

extension PromotionDemoView: FrontPageTransactionViewDelegate {
    func transactionViewTapped(_ transactionView: FrontPageTransactionView) {
        print("TransactionView tapped")
    }
}
