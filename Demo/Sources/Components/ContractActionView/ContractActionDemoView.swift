import FinniversKit

class ContractActionDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption]  = [
        TweakingOption(title: "Basic", action: { [weak self] in
            self?.contractActionView.configure(with: .default)
        }),
        TweakingOption(title: "Car contract", action: { [weak self] in
            self?.contractActionView.configure(
                with: .carContract,
                trailingImage: UIImage(named: .carsCircleIllustration),
                paragraphSpacing: 12
            )
        }),
        TweakingOption(title: "Request access to contract", action: { [weak self] in
            self?.contractActionView.configure(
                with: .requestAccessToContract,
                trailingImage: UIImage(named: .contract),
                trailingImageTopConstant: .spacingM,
                trailingImageTrailingConstant: -.spacingM,
                contentSpacing: .spacingM,
                paragraphSpacing: 12
            )
        }),
        TweakingOption(title: "With video link") { [weak self] in
            guard let self = self else { return }
            self.contractActionView.configure(with: .withVideoLink, remoteImageViewDataSource: self)
        }
    ]

    private lazy var contractActionView: ContractActionView = {
        let view = ContractActionView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        tweakingOptions.first?.action?()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(contractActionView)

        NSLayoutConstraint.activate([
            contractActionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            contractActionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            contractActionView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

extension ContractActionDemoView: ContractActionViewDelegate {
    func contractActionView(_ view: ContractActionView, didSelectActionButtonWithUrl url: URL) {
        print("🔥🔥🔥🔥 \(#function)")
    }

    func contractActionView(_ view: ContractActionView, didSelectVideoWithUrl url: URL) {
        print("🔥🔥🔥🔥 \(#function)")
    }
}

// MARK: - RemoteImageTableViewCellDataSource

extension ContractActionDemoView: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        nil
    }

    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping (UIImage?) -> Void) {
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

// MARK: - Private extensions

private extension ContractActionViewModel {
    static let `default`: ContractActionViewModel = ContractActionViewModel(
        identifier: "demo-view",
        strings: [
            "Godkjent kontrakt av Forbrukerrådet",
            "Enkelt og trygt for begge parter",
            "Oversikt over hele prosessen",
            "Mulighet for gratis forsikring i 30 dager til 0 kr"
        ],
        buttonTitle: "Få ferdig utfylt kontrakt",
        buttonUrl: URL(string: "https://www.finn.no/")!
    )

    static let carContract: ContractActionViewModel = ContractActionViewModel(
        title: "Smidig bilhandel?",
        subtitle: "FINN guider deg hele veien.",
        identifier: "demo-view",
        strings: [
            "Godkjent kontrakt av Forbrukerrådet",
            "Enkelt og trygt for begge parter",
            "Oversikt over hele prosessen",
            "Mulighet for gratis forsikring i 30 dager til 0 kr"
        ],
        buttonTitle: "Få ferdig utfylt kontrakt",
        buttonUrl: URL(string: "https://www.finn.no/")!
    )

    static let requestAccessToContract: ContractActionViewModel = ContractActionViewModel(
        title: "Smidig bilhandel",
        subtitle: "FINN guider deg hele veien.",
        description: "Selger har opprettet\nkjøpekontrakt for denne bilen",
        identifier: "demo-view",
        strings: [
            "Godkjent kontrakt av Forbrukerrådet",
            "Enkelt og trygt for begge parter",
            "Oversikt over hele prosessen",
            "Mulighet for gratis forsikring i 30 dager til 0 kr"
        ],
        buttonTitle: "Be selger om tilgang til kontrakten",
        buttonUrl: URL(string: "https://www.finn.no/")!
    )

    static let withVideoLink: ContractActionViewModel = ContractActionViewModel(
        identifier: "demo-view",
        title: "Kjøpekontrakt for bruktbil",
        strings: [
            "Digital signering",
            "Ferdig utfylt kontrakt",
            "1 mnd bilforsikring til kr 0,-"
        ],
        buttonTitle: "Opprett kjøpekontrakt",
        buttonUrl: URL(string: "https://www.finn.no/")!,
        videoLink: ContractActionViewModel.VideoLink(
            title: "Se hvordan smidig bilhandel fungerer",
            videoUrl: URL(string: "https://player.vimeo.com/video/353374268")!,
            thumbnailUrl: URL(string: "https://apps.finn.no/api/image/videothumb/vimeo/529335358")!
        )
    )
}
