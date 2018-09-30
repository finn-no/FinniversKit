//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

/// Branded alternative of SVProgressHUD. It's presented on top of the top-most view.
@objc public class LoadingView: UIView {
    /// Allows the loading view to use a plain UIActivityIndicatorView,
    /// useful for a smooth transition between the old indicator and the new one,
    /// by using this flag we can avoid having multiple styles of showing progress in our app.
    @objc public static let shouldUseOldIndicator: Bool = false

    private let animationDuration: TimeInterval = 0.3
    private let loadingIndicatorSize: CGFloat = 40
    private let loadingIndicatorInitialTransform: CGAffineTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    private static let shared = LoadingView()

    private lazy var newLoadingIndicator: LoadingIndicatorView = {
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

    private lazy var messageLabel: UILabel = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = . center
        label.numberOfLines = 0
        return label
    }()

    private lazy var successImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: .checkmarkBig).withRenderingMode(.alwaysTemplate)
        view.tintColor = LoadingView.shouldUseOldIndicator ? .primaryBlue : .secondaryBlue
        view.alpha = 0
        view.transform = loadingIndicatorInitialTransform
        return view
    }()

    private var defaultWindow: UIWindow?

    init(window: UIWindow? = UIApplication.shared.keyWindow) {
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
    ///
    /// - Parameter message: The message to be displayed (optional)
    @objc public class func show(withMessage message: String? = nil) {
        LoadingView.shared.startAnimating(withMessage: message)
    }

    /// Adds a layer on top of the top-most view and starts the animation of the loading indicator.
    ///
    /// - Parameter message: The message to be displayed (optional)
    @objc public class func showSuccess(withMessage message: String? = nil) {
        LoadingView.shared.showSuccess(withMessage: message)
    }

    /// Stops the animation of the loading indicator and removes the loading view.
    @objc public class func hide() {
        LoadingView.shared.stopAnimating()
    }
}

// MARK: - Private methods

private extension LoadingView {
    private func setup() {
        backgroundColor = UIColor.milk.withAlphaComponent(0.8)

        let loadingIndicator = LoadingView.shouldUseOldIndicator ? oldLoadingIndicator : newLoadingIndicator
        addSubview(loadingIndicator)
        addSubview(messageLabel)
        addSubview(successImageView)
        NSLayoutConstraint.activate([
            successImageView.widthAnchor.constraint(equalToConstant: loadingIndicatorSize),
            successImageView.heightAnchor.constraint(equalToConstant: loadingIndicatorSize),
            successImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            successImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -.mediumSpacing),

            loadingIndicator.widthAnchor.constraint(equalToConstant: loadingIndicatorSize),
            loadingIndicator.heightAnchor.constraint(equalToConstant: loadingIndicatorSize),
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -.mediumSpacing),

            messageLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: .mediumLargeSpacing),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .veryLargeSpacing),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.veryLargeSpacing)
            ])
    }

    private func startAnimating(withMessage message: String? = nil) {
        if superview == nil {
            defaultWindow?.addSubview(self)
            fillInSuperview()
        }

        var loadingIndicator: LoadingViewAnimatable = LoadingView.shouldUseOldIndicator ? oldLoadingIndicator : newLoadingIndicator
        loadingIndicator.startAnimating()
        messageLabel.text = message
        successImageView.alpha = 0
        UIView.animate(withDuration: animationDuration) {
            self.alpha = 1
            loadingIndicator.alpha = 1
            loadingIndicator.transform = .identity
        }
    }

    private func showSuccess(withMessage message: String? = nil) {
        if superview == nil {
            defaultWindow?.addSubview(self)
            fillInSuperview()
        }

        var loadingIndicator: LoadingViewAnimatable = LoadingView.shouldUseOldIndicator ? oldLoadingIndicator : newLoadingIndicator
        loadingIndicator.alpha = 0
        messageLabel.text = message
        UIView.animate(withDuration: animationDuration) {
            self.alpha = 1
            self.successImageView.alpha = 1
            self.successImageView.transform = .identity
        }
    }

    private func stopAnimating() {
        if defaultWindow != nil {
            var loadingIndicator: LoadingViewAnimatable = LoadingView.shouldUseOldIndicator ? oldLoadingIndicator : newLoadingIndicator
            UIView.animate(withDuration: animationDuration, animations: {
                self.alpha = 0
                loadingIndicator.transform = self.loadingIndicatorInitialTransform
                self.successImageView.transform = self.loadingIndicatorInitialTransform
            }) { (_) in
                self.messageLabel.text = nil
                loadingIndicator.stopAnimating()
                self.removeFromSuperview()
            }
        }
    }
}
