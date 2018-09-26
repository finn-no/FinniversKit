//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class LoadingView: UIView {
    public static let shouldUseOldIndicator: Bool = true

    private let loadingIndicatorSize: CGFloat = 40
    private let loadingIndicatorInitialTransform: CGAffineTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    private static let shared = LoadingView()

    private lazy var loadingIndicator: LoadingIndicatorView = {
        let view = LoadingIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.transform = loadingIndicatorInitialTransform
        return view
    }()

    private lazy var oldLoadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.transform = loadingIndicatorInitialTransform
        view.color = .primaryBlue
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

        let view = LoadingView.shouldUseOldIndicator ? oldLoadingIndicator : loadingIndicator
        addSubview(view)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: loadingIndicatorSize),
            view.heightAnchor.constraint(equalToConstant: loadingIndicatorSize),
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

    private func startAnimating() {
        if superview == nil {
            defaultWindow?.addSubview(self)
            fillInSuperview()
        }

        var view: LoadingViewAnimatable = LoadingView.shouldUseOldIndicator ? oldLoadingIndicator : loadingIndicator
        view.startAnimating()
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            view.transform = .identity
        }
    }

    private func stopAnimating() {
        if defaultWindow != nil {
            var view: LoadingViewAnimatable = LoadingView.shouldUseOldIndicator ? oldLoadingIndicator : loadingIndicator
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
                view.transform = self.loadingIndicatorInitialTransform
            }) { (_) in
                view.stopAnimating()
                self.removeFromSuperview()
            }
        }
    }
}
