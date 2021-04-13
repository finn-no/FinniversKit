import FinniversKit

class TransactionEntryDemoView: UIView, Tweakable {

    private lazy var transactionEntryView: TransactionEntryView = {
        let view = TransactionEntryView(withAutoLayout: true)
        view.remoteImageViewDataSource = self
        view.delegate = self
        return view
    }()

    lazy var tweakingOptions: [TweakingOption] = {
        [
            TweakingOption(title: "Regular", action: { [weak self] in
                self?.configure(with: RegularViewModel())
            }),
            TweakingOption(title: "With warning", action: { [weak self] in
                self?.configure(with: ViewModelWithWarning())
            })
        ]
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(transactionEntryView)

        NSLayoutConstraint.activate([
            transactionEntryView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            transactionEntryView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            transactionEntryView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        transactionEntryView.configure(with: RegularViewModel())
    }

    func configure(with viewModel: TransactionEntryViewModel) {
        transactionEntryView.configure(with: viewModel)
    }
}

extension TransactionEntryDemoView: TransactionEntryViewDelegate {
    func transactionEntryViewWasTapped(_ transactionEntryView: TransactionEntryView) {
        print("Tapped transaction entry!")
    }
}

extension TransactionEntryDemoView: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        nil
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

private class RegularViewModel: TransactionEntryViewModel {
    var title: String = "Kontrakt"
    var text: String = "Kjøper har signert, nå mangler bare din signatur."
    var imageUrl: String? = "https://finn-content-hub.imgix.net/bilder/Motor/Toma%CC%8Aterbil_Toppbilde.jpg?auto=compress&crop=focalpoint&domain=finn-content-hub.imgix.net&fit=crop&fm=jpg&fp-x=0.5&fp-y=0.5&h=900&ixlib=php-3.3.0&w=1600"
    var showWarningIcon: Bool = false
    var fallbackImage: UIImage = UIImage(named: .transactionJourneyCar)
}

private class ViewModelWithWarning: TransactionEntryViewModel {
    var title: String = "Betaling"
    var text: String = "Betalingen gikk ikke gjennom. Åpne salgsprosessen for å prøve på nytt."
    var imageUrl: String?
    var showWarningIcon: Bool = true
    var fallbackImage: UIImage = UIImage(named: .transactionJourneyCar)
}
