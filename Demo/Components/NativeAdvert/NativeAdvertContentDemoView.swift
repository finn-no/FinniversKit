//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class NativeAdvertContentDemoView: UIView {

    private lazy var defaultData = NativeAdvertContentDefaultData()

    private lazy var nativeAdvertContentView: NativeAdvertContentView = {
        let view = NativeAdvertContentView(withAutoLayout: true)
        view.delegate = self
        view.imageDelegate = self
        view.configure(with: defaultData)
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
        addSubview(nativeAdvertContentView)

        NSLayoutConstraint.activate([
            nativeAdvertContentView.topAnchor.constraint(equalTo: topAnchor),
            nativeAdvertContentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nativeAdvertContentView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

}

extension NativeAdvertContentDemoView: NativeAdvertViewDelegate, NativeAdvertImageDelegate {

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
