//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class LoadingView: UIView {
    lazy var loadingIndicator: LoadingIndicatorView = {
        let view = LoadingIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var defaultWindow: UIWindow?

    public init(window: UIWindow? = UIApplication.shared.keyWindow) {
        super.init(frame: .zero)
        self.defaultWindow = window
        self.alpha = 0
        self.translatesAutoresizingMaskIntoConstraints = false
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func setup() {
        backgroundColor = UIColor.milk.withAlphaComponent(0.8)
        addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.widthAnchor.constraint(equalToConstant: 40),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 40),
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

    public class func show() {
        let loadingView = LoadingView()
        loadingView.startAnimating()
    }

    public class func hide() {
        let loadingView = LoadingView()
        loadingView.stopAnimating()
    }

    func startAnimating() {
        if superview == nil {
            defaultWindow?.addSubview(self)
            self.fillInSuperview()
        }

        loadingIndicator.startAnimating()

        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.transform = .identity
        }
    }

    func stopAnimating() {
        if defaultWindow != nil {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { (_) in
                self.loadingIndicator.stopAnimating()
                self.removeFromSuperview()
            }
        }
    }
}
