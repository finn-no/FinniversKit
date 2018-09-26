//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class LoadingView: UIView {
    private let loadingIndicatorSize: CGFloat = 40
    private let loadingIndicatorInitialTransform: CGAffineTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    private static let shared = LoadingView()

    private lazy var loadingIndicator: LoadingIndicatorView = {
        let view = LoadingIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.transform = self.loadingIndicatorInitialTransform
        return view
    }()

    private var defaultWindow: UIWindow?

    public init(window: UIWindow? = UIApplication.shared.keyWindow) {
        super.init(frame: .zero)
        self.defaultWindow = window
        self.alpha = 0
        self.translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public class func show() {
        LoadingView.shared.startAnimating()
    }

    public class func hide() {
        LoadingView.shared.stopAnimating()
    }
}

// MARK: - Private methods

extension LoadingView {
    private func setup() {
        backgroundColor = UIColor.milk.withAlphaComponent(0.8)
        addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.widthAnchor.constraint(equalToConstant: 40),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 40),
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

    private func startAnimating() {
        if superview == nil {
            defaultWindow?.addSubview(self)
            self.fillInSuperview()
        }

        loadingIndicator.startAnimating()

        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.loadingIndicator.transform = .identity
        }
    }

    private func stopAnimating() {
        if defaultWindow != nil {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
                self.loadingIndicator.transform = self.loadingIndicatorInitialTransform
            }) { (_) in
                self.loadingIndicator.stopAnimating()
                self.removeFromSuperview()
            }
        }
    }
}
