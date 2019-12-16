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

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView(withAutoLayout: true)
        return view
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(withAutoLayout: true)
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = .mediumLargeSpacing
        return view
    }()

    private lazy var nativeAdvertListView: NativeAdvertListView = {
        let view = NativeAdvertListView(withAutoLayout: false)
        view.configure(with: advertModel, andImageDelegate: self)
        view.delegate = self
        return view
    }()

    private lazy var nativeAdvertGridView: NativeAdvertGridView = {
        let view = NativeAdvertGridView(withAutoLayout: false)
        view.configure(with: advertModel, andImageDelegate: self)
        view.delegate = self
        return view
    }()

    private lazy var contentAdvertView: NativeContentAdvertView = {
        let view = NativeContentAdvertView(viewModel: contentModel, imageDelegate: self)
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
        addSubview(scrollView)
        scrollView.fillInSuperview()

        scrollView.addSubview(stackView)
        stackView.fillInSuperview()

        stackView.addArrangedSubview(createHairlineView(labelText: "Native Advert (List)"))
        stackView.addArrangedSubview(nativeAdvertListView)
        stackView.addArrangedSubview(createHairlineView(labelText: "Native Advert (Grid)"))
        stackView.addArrangedSubview(nativeAdvertGridView)
        stackView.addArrangedSubview(createHairlineView(labelText: "Native Advert Content"))
        stackView.addArrangedSubview(contentAdvertView)

        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }

    private func createHairlineView(labelText: String) -> UIView {
        let container = UIView(withAutoLayout: false)
        let line = UIView(withAutoLayout: true)
        let label = Label(style: .captionStrong, withAutoLayout: true)

        container.addSubview(label)
        container.addSubview(line)

        line.backgroundColor = .lightGray
        label.text = labelText

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: .mediumSpacing),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: .mediumSpacing),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: .mediumSpacing),
            line.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: .mediumSpacing),
            line.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -.mediumSpacing),
            line.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            line.heightAnchor.constraint(equalToConstant: 0.5)
        ])

        return container
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
