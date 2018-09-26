//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

/// Branded alternative of SVProgressHUD. It's presented on top of the top-most view.
public class LoadingView: UIView {
    /// Allows the loading view to use a plain UIActivityIndicatorView,
    /// useful for a smooth transition between the old indicator and the new one,
    /// by using this flag we can avoid having multiple styles of showing progress in our app.
    public static let shouldUseOldIndicator: Bool = true

    private let animationDuration: TimeInterval = 0.3
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

    /// Adds a layer on top of the top-most view and starts the animation of the loading indicator.
    public class func show() {
        LoadingView.shared.startAnimating()
    }

    /// Stops the animation of the loading indicator and removes the loading view.
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
        UIView.animate(withDuration: animationDuration) {
            self.alpha = 1
            view.transform = .identity
        }
    }

    private func stopAnimating() {
        if defaultWindow != nil {
            var view: LoadingViewAnimatable = LoadingView.shouldUseOldIndicator ? oldLoadingIndicator : loadingIndicator
            UIView.animate(withDuration: animationDuration, animations: {
                self.alpha = 0
                view.transform = self.loadingIndicatorInitialTransform
            }) { (_) in
                view.stopAnimating()
                self.removeFromSuperview()
            }
        }
    }
}
