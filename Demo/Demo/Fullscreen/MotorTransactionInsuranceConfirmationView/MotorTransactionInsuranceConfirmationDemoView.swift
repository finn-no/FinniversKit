import FinnUI
import FinniversKit

// swiftlint:disable:next type_name
class MotorTransactionInsuranceConfirmationDemoView: UIView {

    private lazy var view = MotorTransactionInsuranceConfirmationView(
        viewModel: InsuranceConfirmationViewModel(),
        remoteImageViewDataSource: self
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
}
