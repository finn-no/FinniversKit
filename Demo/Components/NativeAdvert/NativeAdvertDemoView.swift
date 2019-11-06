//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

private struct DemoViewModel: NativeAdvertViewModel {
    let title: String?
    let mainImageURL: URL?
    let iconImageURL: URL?
    let sponsoredText: String?
}

class NativeAdvertDemoView: UIView {
    private let advertModel = DemoViewModel(
        title: "Kan være inntil 50 tegn, og denne er faktisk på 50",
        mainImageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/2b/Jupiter_and_its_shrunken_Great_Red_Spot.jpg"),
        iconImageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Five-pointed_star.svg/1920px-Five-pointed_star.svg.png"),
        sponsoredText: "Sponset av Den LengsteMuligeAnnonsør"
    )

    private let contentModel = DemoViewModel(
        title: "Du har skjært avocadoen feil i alle år!",
        mainImageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Guacomole.jpg/2560px-Guacomole.jpg"),
        iconImageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/1d/Avocado.jpeg"),
        sponsoredText: "ANNONSØRINNHOLD"
    )

    private lazy var advertView: NativeAdvertView = {
        let view = NativeAdvertView(viewModel: advertModel, imageDelegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.backgroundColor = .bgPrimary
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
        
        addSubview(advertView)
        addSubview(contentAdvertView)

        let hairlineContentTop = createHairlineView()
        let hairlineContentBottom = createHairlineView()
        addSubview(hairlineContentTop)
        addSubview(hairlineContentBottom)

        NSLayoutConstraint.activate([
            advertView.leadingAnchor.constraint(equalTo: leadingAnchor),
            advertView.topAnchor.constraint(equalTo: topAnchor),
            advertView.trailingAnchor.constraint(equalTo: trailingAnchor),

            hairlineContentTop.leadingAnchor.constraint(equalTo: leadingAnchor),
            hairlineContentTop.trailingAnchor.constraint(equalTo: trailingAnchor),
            hairlineContentTop.bottomAnchor.constraint(equalTo: advertView.bottomAnchor, constant: .mediumLargeSpacing),

            contentAdvertView.topAnchor.constraint(equalTo: hairlineContentTop.bottomAnchor, constant: .mediumLargeSpacing),
            contentAdvertView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentAdvertView.trailingAnchor.constraint(equalTo: trailingAnchor),

            hairlineContentBottom.leadingAnchor.constraint(equalTo: leadingAnchor),
            hairlineContentBottom.trailingAnchor.constraint(equalTo: trailingAnchor),
            hairlineContentBottom.topAnchor.constraint(equalTo: contentAdvertView.bottomAnchor, constant: .mediumLargeSpacing),
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
