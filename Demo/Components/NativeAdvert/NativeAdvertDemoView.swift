//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class NativeAdvertDemoView: UIView {

    private lazy var scrollView = UIScrollView(withAutoLayout: true)

    private lazy var stackView: UIStackView = {
        let view = UIStackView(withAutoLayout: true)
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = .spacingXL
        return view
    }()

    private lazy var nativeAdvertRecommendationStack: UIStackView = {
        let view = UIStackView(withAutoLayout: false)
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = .spacingM
        return view
    }()

    private lazy var nativeAdvertListView: NativeAdvertListView = {
        let view = NativeAdvertListView(withAutoLayout: false)
        view.delegate = self
        view.imageDelegate = self
        view.configure(with: NativeAdvertDefaultData.native)
        return view
    }()

    private lazy var nativeAdvertGridView: NativeAdvertGridView = {
        let view = NativeAdvertGridView(withAutoLayout: false)
        view.delegate = self
        view.imageDelegate = self
        view.configure(with: NativeAdvertDefaultData.native)
        return view
    }()

    private lazy var nativeAdvertContentView: NativeAdvertContentView = {
        let view = NativeAdvertContentView(withAutoLayout: false)
        view.delegate = self
        view.imageDelegate = self
        view.configure(with: NativeAdvertDefaultData.content)
        return view
    }()

    private lazy var nativeAdvertRecommendationViews: [NativeAdvertRecommendationView] = (0...1).map { _ in
        let view = NativeAdvertRecommendationView(withAutoLayout: false)
        view.delegate = self
        view.imageDelegate = self
        view.configure(with: NativeAdvertDefaultData.nativeRecommendation)
        return view
    }

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

        stackView.addArrangedSubview(nativeAdvertRecommendationStack)
        stackView.addArrangedSubview(nativeAdvertListView)
        stackView.addArrangedSubview(nativeAdvertGridView)
        stackView.addArrangedSubview(nativeAdvertContentView)

        nativeAdvertRecommendationViews.forEach { nativeAdvertRecommendationStack.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

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
