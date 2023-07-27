import FinniversKit
import DemoKit

class TransactionEntryDemoView: UIView {

    private lazy var transactionEntryView: TransactionEntryView = {
        let view = TransactionEntryView(withAutoLayout: true)
        view.remoteImageViewDataSource = self
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configure(forTweakAt: 0)
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
    }
}

extension TransactionEntryDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case regular
        case withWarning
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .regular:
            transactionEntryView.configure(with: TransactionEntryViewModel())
        case .withWarning:
            transactionEntryView.configure(with: TransactionEntryViewModel(showWarning: true))
        }
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

// MARK: - Demo data

extension TransactionEntryViewModel {
    init(showWarning: Bool = false) {
        self.init(
            title: "Kontrakt",
            text: "Kjøper har signert, nå mangler bare din signatur.",
            imageUrl: "https://finn-content-hub.imgix.net/bilder/Motor/Toma%CC%8Aterbil_Toppbilde.jpg?auto=compress&crop=focalpoint&domain=finn-content-hub.imgix.net&fit=crop&fm=jpg&fp-x=0.5&fp-y=0.5&h=900&ixlib=php-3.3.0&w=1600",
            showWarningIcon: showWarning,
            fallbackImage: UIImage(named: .transactionJourneyCar),
            accessibilityLabel: "Åpne salgsprosessen."
        )
    }
}
