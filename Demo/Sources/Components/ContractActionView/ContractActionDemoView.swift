import FinniversKit
import DemoKit

class ContractActionDemoView: UIView {
    private lazy var contractActionView: ContractActionView = {
        let view = ContractActionView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configure(forTweakAt: 0)
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

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

extension ContractActionDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case basic
        case carContract
        case requestAccessToContract
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .basic:
            contractActionView.configure(with: .default)
        case .carContract:
            contractActionView.configure(
                with: .carContract,
                topIcon: UIImage(named: .car),
                paragraphSpacing: 12
            )
        case .requestAccessToContract:
            contractActionView.configure(
                with: .requestAccessToContract,
                topIcon: UIImage(named: .contract),
                trailingImageTopConstant: .spacingM,
                trailingImageTrailingConstant: -.spacingM,
                contentSpacing: .spacingM,
                paragraphSpacing: 12
            )
        }
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
        buttonTitle: "Få ferdig utfylt kontrakt",
        buttonUrl: URL(string: "https://www.finn.no/")! // swiftlint:disable:this force_unwrapping
    )

    static let carContract: ContractActionViewModel = ContractActionViewModel(
        identifier: "demo-view",
        title: "Kjøp bilen med Smidig bilhandel",
        subtitle: "Vi hjelper deg ghennom alle stegene i kjøpet. Enkelt, trygt og helt gratis.",
        buttonTitle: "Jeg vil bruke Smidig bilhandel",
        buttonUrl: URL(string: "https://www.finn.no/")! // swiftlint:disable:this force_unwrapping
    )

    static let requestAccessToContract: ContractActionViewModel = ContractActionViewModel(
        identifier: "demo-view",
        title: "Smidig bilhandel",
        subtitle: "FINN guider deg hele veien.",
        strings: ["a", "b", "c"],
        buttonTitle: "Be selger om tilgang til kontrakten",
        buttonUrl: URL(string: "https://www.finn.no/")! // swiftlint:disable:this force_unwrapping
    )
}
