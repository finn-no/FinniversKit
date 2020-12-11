import FinnUI
import FinniversKit

// swiftlint:disable:next type_name
class MotorTransactionInsuranceConfirmationDemoView: UIView {

    private lazy var view = MotorTransactionInsuranceConfirmationView(
        viewModel: InsuranceConfirmationViewModel(),
        remoteImageViewDataSource: self,
        delegate: self
    )

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(view)
        view.fillInSuperview()
    }
}

extension MotorTransactionInsuranceConfirmationDemoView: MotorTransactionInsuranceConfirmationViewDelegate {
    func motorTransactionInsuranceConfirmationViewDidTapButton(_ view: MotorTransactionInsuranceConfirmationView) {
        print("Button tapped!")
    }
}

extension MotorTransactionInsuranceConfirmationDemoView: RemoteImageViewDataSource {
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

private struct InsuranceConfirmationViewModel: MotorTransactionInsuranceConfirmationViewModel {
    let logoImageUrl: String? = "https://ocast-media-image.s3.amazonaws.com/6VGiGiXU7ODcMC1Z_400x400.jpg"
    let companyName = "Forsikring AS"
    let bodyText = "Ved å aktivere forsikringen, samtykker du til at vi sender infoen under til forsikringselskapet, og at de gjør en kredittsjekk av deg."
    let caption = "Kredittsjekken skjer i det du klikker på knappen. Blir den godkjent, vil du få en bekreftelse på at bilen er forsikret når du går videre."
    let buttonTitle = "Aktiver forsikring"

    let confirmationDetails: [KeyValuePair] = [
        KeyValuePair(title: "Navn", value: "Harry Potter"),
        KeyValuePair(title: "Telefonnummer", value: "123 45 678"),
        KeyValuePair(title: "E-post", value: "potter@harry.com"),
        KeyValuePair(title: "Adresse", value: "Veien 4, 0012 Svalbard"),
        KeyValuePair(title: "Personnummer", value: "123456 *****")
    ]
}
