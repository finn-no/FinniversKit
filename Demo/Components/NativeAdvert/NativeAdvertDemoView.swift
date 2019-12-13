//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

private struct DemoViewModel: NativeAdvertViewModel {
    let title: String
    let mainImageUrl: URL?
    let logoImageUrl: URL?
    let sponsoredBy: String?
    let ribbonText: String
}

class NativeAdvertDemoView: UIView {
    private let advertModel = DemoViewModel(
        title: "Du har skjært avokadoen feil i alle år! 50 tegn!",
        mainImageUrl: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Guacomole.jpg/2560px-Guacomole.jpg"),
        logoImageUrl: URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/1d/Avocado.jpeg"),
        sponsoredBy: "Avokadosentralen",
        ribbonText: "Annonse"
    )

    private let contentModel = DemoViewModel(
        title: "Du har skjært avokadoen feil i alle år! 50 tegn!",
        mainImageUrl: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Guacomole.jpg/2560px-Guacomole.jpg"),
        logoImageUrl: URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/1d/Avocado.jpeg"),
        sponsoredBy: "",
        ribbonText: "ANNONSØRINNHOLD"
    )

    private lazy var nativeAdvertGridView: NativeAdvertGridView = {
        let view = NativeAdvertGridView(withAutoLayout: true)
        view.configure(with: advertModel, andImageDelegate: self)
        view.delegate = self
        return view
    }()

    private lazy var contentAdvertView: NativeContentAdvertView = {
        let view = NativeContentAdvertView(viewModel: contentModel, imageDelegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.backgroundColor = .bgPrimary
        return view
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        addSubview(nativeAdvertGridView)
        addSubview(contentAdvertView)

        let hairlineContentTop = createHairlineView()
        let hairlineContentBottom = createHairlineView()
        addSubview(hairlineContentTop)
        addSubview(hairlineContentBottom)

        NSLayoutConstraint.activate([
            nativeAdvertGridView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            nativeAdvertGridView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nativeAdvertGridView.trailingAnchor.constraint(equalTo: trailingAnchor),

            hairlineContentTop.topAnchor.constraint(equalTo: nativeAdvertGridView.bottomAnchor, constant: .mediumLargeSpacing),
            hairlineContentTop.leadingAnchor.constraint(equalTo: leadingAnchor),
            hairlineContentTop.trailingAnchor.constraint(equalTo: trailingAnchor),

            contentAdvertView.topAnchor.constraint(equalTo: hairlineContentTop.bottomAnchor, constant: .mediumLargeSpacing),
            contentAdvertView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentAdvertView.trailingAnchor.constraint(equalTo: trailingAnchor),

            hairlineContentBottom.topAnchor.constraint(equalTo: contentAdvertView.bottomAnchor, constant: .mediumLargeSpacing),
            hairlineContentBottom.leadingAnchor.constraint(equalTo: leadingAnchor),
            hairlineContentBottom.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    private func createHairlineView() -> UIView {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .lightGray //DARK

        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 0.5)
        ])

        return view
    }
}

extension NativeAdvertDemoView: NativeAdvertViewDelegate, NativeAdvertImageDelegate {
    func nativeAdvertViewDidSelectSettingsButton() {
        var viewController = UIApplication.shared.keyWindow?.rootViewController
        while viewController?.presentedViewController != nil {
            viewController = viewController?.presentedViewController
        }

        let alert = UIAlertController(title: "Settings", message: "You just tapped the settings button", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "I know", style: .default, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }

    func nativeAdvertView(setImageWithURL url: URL, onImageView imageView: UIImageView) {
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data {
                    imageView.image = UIImage(data: data)
                }
            }
        }

        task.resume()
    }
}
