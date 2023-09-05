import UIKit
import FinniversKit
import DemoKit

class BrazePromotionDemoView: UIView, Demoable {
    private lazy var viewModels: [BrazePromotionViewModel] = [titleTextImageButton, titleTextButton, titleText]

    private let titleTextImageButton = BrazePromotionViewModel(
        title: "Hjerterom - hjelp til flyktninger",
        text: "Under Hjerterom kan du finne informasjon om hvordan du kan hjelpe flyktninger som kommer til Norge.",
        image: "https://images.finncdn.no/dynamic/1600w/2022/11/vertical-0/18/7/277/904/107_1208691254.jpg",
        primaryButtonTitle: "Gå til Hjerterom"
    )

    private let titleTextButton = BrazePromotionViewModel(
        title: "Hjerterom - hjelp til flyktninger",
        text: "Under Hjerterom kan du finne informasjon om hvordan du kan hjelpe flyktninger som kommer til Norge.",
        primaryButtonTitle: "Gå til Hjerterom",
        dismissible: false
    )

    private let titleText = BrazePromotionViewModel(
        title: "Hjerterom - hjelp til flyktninger",
        text: "Under Hjerterom kan du finne informasjon om hvordan du kan hjelpe flyktninger som kommer til Norge."
    )

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
            let view = BrazePromotionView(viewModel: viewModel, imageDatasource: self)
            view.delegate = self
            stackView.addArrangedSubview(view)
        }
    }
}

extension BrazePromotionDemoView: BrazePromotionViewDelegate {
    func brazePromotionViewTapped(_ brazePromotionView: BrazePromotionView) {
        print("Promo tapped")
    }

    func brazePromotionView(_ brazePromotionView: BrazePromotionView, didSelect action: BrazePromotionView.Action) {
        print("Selected : \(action)")
    }
}

extension BrazePromotionDemoView: RemoteImageViewDataSource {
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

extension BrazePromotionDemoView: FrontPageTransactionViewDelegate {
    func transactionViewTapped(_ transactionView: FrontPageTransactionView) {
        print("TransactionView tapped")
    }
}
