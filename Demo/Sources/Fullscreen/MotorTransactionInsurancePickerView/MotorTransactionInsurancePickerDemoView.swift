import FinnUI
import FinniversKit

class MotorTransactionInsurancePickerDemoView: UIView {

    private lazy var view = MotorTransactionInsurancePickerView(
        viewModel: InsurancePickerViewModel(),
        remoteImageViewDataSource: self,
        delegate: self,
        withAutoLayout: true
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

extension MotorTransactionInsurancePickerDemoView: MotorTransactionInsurancePickerViewDelegate {
    func motorTransactionInsurancePickerView(_ view: MotorTransactionInsurancePickerView, didSelectInsuranceAtIndex index: Int) {
        print("Did select insurance at index \(index)")
    }
}

extension MotorTransactionInsurancePickerDemoView: RemoteImageViewDataSource {
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

private struct InsurancePickerViewModel: MotorTransactionInsurancePickerViewModel {
    let title = "Disse selskapene tilbyr deg gratis oppstartsperiode"
    let bodyText = "Du vil bli kontaktet av forsikringsselskapet i løpet av gratisperioden med et tilbud om fortsettelse av forsikringen."

    let insurances: [MotorTransactionInsuranceViewModel] = [
        InsuranceViewModel(
            logoImageUrl: "https://ocast-media-image.s3.amazonaws.com/6VGiGiXU7ODcMC1Z_400x400.jpg",
            companyName: "Forsikring AS",
            bodyTexts: [
                "Kasko med leiebil ● 30 dager til 0 kr ● Egenandel: 4 000 kr",
                "Gjelder for de over 24 år"
            ],
            accessibilityLabel: "Prøv Forsikring AS gratis i 30 dager."
        ),
        InsuranceViewModel(
            logoImageUrl: "https://upload.wikimedia.org/wikipedia/commons/1/1d/Avocado.jpeg",
            companyName: "Grønn forsikring",
            bodyTexts: [
                "Super ● 30 dager til 0 kr ● Egenandel: 4 000 kr",
                "Gjelder for de over 23 år"
            ],
            accessibilityLabel: "Prøv grønn forsikring gratis i 30 dager."
        )
    ]
}

private struct InsuranceViewModel: MotorTransactionInsuranceViewModel {
    let logoImageUrl: String?
    let companyName: String
    let bodyTexts: [String]
    let accessibilityLabel: String

    init(logoImageUrl: String?, companyName: String, bodyTexts: [String], accessibilityLabel: String) {
        self.logoImageUrl = logoImageUrl
        self.companyName = companyName
        self.bodyTexts = bodyTexts
        self.accessibilityLabel = accessibilityLabel
    }
}
