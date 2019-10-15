//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

/// Branded alternative of SVProgressHUD. It's presented on top of the top-most view.
@objc public class LoadingView: UIView {
    private enum State {
        case hidden
        case message
        case success
    }

    /// Decides whether the loading view displays as a full screen overlay or as a translucent HUD.
    ///
    /// - fullscreen: Covers the entire screen with an overlaying blocking UI elements from being accessed.
    /// - boxed: Displays a translucent HUD that will keep things selectable beneath.
    @objc public enum DisplayType: Int, CaseIterable {
        case fullscreen
        case boxed
    }

    /// Allows the loading view to use a plain UIActivityIndicatorView,
    /// useful for a smooth transition between the old indicator and the new one,
    /// by using this flag we can avoid having multiple styles of showing progress in our app.
    @objc public static var shouldUseOldIndicator: Bool = false

    private let animationDuration: TimeInterval = 0.3
    private let loadingIndicatorSize: CGFloat = 40
    private let boxedSize: CGFloat = 120

    /// Used for throttling
    private var state: State = .hidden
    private let loadingIndicatorInitialTransform: CGAffineTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    private static let shared = LoadingView()

    private var successImageViewCenterY: NSLayoutConstraint?
    private var loadingIndicatorCenterY: NSLayoutConstraint?

    private lazy var loadingIndicator: LoadingIndicatorView = {
        let view = LoadingIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.transform = loadingIndicatorInitialTransform
        return view
    }()

    private lazy var messageLabel: UILabel = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var successImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: .checkmarkBig).withRenderingMode(.alwaysTemplate)
        view.tintColor = LoadingView.shouldUseOldIndicator ? .btnPrimary : .secondaryBlue
        view.alpha = 0
        view.transform = loadingIndicatorInitialTransform
        return view
    }()

    private var defaultWindow: UIWindow?

    init(window: UIWindow? = UIApplication.shared.keyWindow) {
        super.init(frame: .zero)
        defaultWindow = window
        alpha = 0
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    /// Adds a layer on top of the top-most view and starts the animation of the loading indicator.
    ///
    /// - Parameter message: The message to be displayed (optional)
    /// - Parameter afterDelay: The delay time (in seconds) before the loading view will be shown (optional, defaults to 0.5s)
    @objc public class func show(withMessage message: String? = nil, afterDelay delay: Double = 0.5, displayType: DisplayType = .fullscreen) {
        LoadingView.shared.state = .message

        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            if LoadingView.shared.state == .message {
                LoadingView.shared.startAnimating(withMessage: message, displayType: displayType)
            }
        })
    }

    /// Adds a layer on top of the top-most view and starts the animation of the loading indicator.
    ///
    /// - Parameter message: The message to be displayed (optional)
    /// - Parameter afterDelay: The delay time (in seconds) before the success view will be shown (optional, defaults to 0.5s)
    @objc public class func showSuccess(withMessage message: String? = nil, afterDelay delay: Double = 0.5, displayType: DisplayType = .fullscreen) {
        LoadingView.shared.state = .success

        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            if LoadingView.shared.state == .success {
                LoadingView.shared.showSuccess(withMessage: message, displayType: displayType)
            }
        })
    }

    /// Stops the animation of the loading indicator and removes the loading view.
    /// - Note: Must be called from the main thread
    @objc public class func hide() {
        LoadingView.shared.state = .hidden
        LoadingView.shared.stopAnimating()
    }

    /// After a delay, stops the animation of the loading indicator and removes the loading view.
    /// - Note: Can be called from a background thread.
    @objc public class func hide(afterDelay delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            hide()
        })
    }
}

// MARK: - Private methods

private extension LoadingView {
    private func setup() {
        addSubview(successImageView)
        addSubview(loadingIndicator)
        addSubview(messageLabel)

        NSLayoutConstraint.activate([
            successImageView.widthAnchor.constraint(equalToConstant: loadingIndicatorSize),
            successImageView.heightAnchor.constraint(equalToConstant: loadingIndicatorSize),
            successImageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            loadingIndicator.widthAnchor.constraint(equalToConstant: loadingIndicatorSize),
            loadingIndicator.heightAnchor.constraint(equalToConstant: loadingIndicatorSize),
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),

            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .smallSpacing),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.smallSpacing),
            messageLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: .mediumSpacing)
        ])
    }

    private func addHUD(displayType: DisplayType) {
        if superview == nil {
            guard let window = defaultWindow else { return }
            window.addSubview(self)

            switch displayType {
            case .fullscreen:
                successImageView.tintColor = .secondaryBlue
                messagelabel.textColor = .textPrimary
                backgroundColor = UIColor.white.withAlphaComponent(0.8)
                layer.cornerRadius = 0
                fillInSuperview()
            case .boxed:
                successImageView.tintColor = .bgPrimary
                messageLabel.textColor = .bgPrimary
                backgroundColor = UIColor.black.withAlphaComponent(0.8)
                layer.cornerRadius = 16

                NSLayoutConstraint.activate([
                    heightAnchor.constraint(equalToConstant: boxedSize),
                    widthAnchor.constraint(equalToConstant: boxedSize),
                    centerXAnchor.constraint(equalTo: window.centerXAnchor),
                    centerYAnchor.constraint(equalTo: window.centerYAnchor)
                ])
            }
        }
    }

    func setupForMessage(message: String?) {
        if let message = message, message.count > 0 {
            messageLabel.text = message
            successImageViewCenterY?.isActive = false
            successImageViewCenterY = successImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -.mediumSpacing)
            successImageViewCenterY?.isActive = true

            loadingIndicatorCenterY?.isActive = false
            loadingIndicatorCenterY = loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -.mediumSpacing)
            loadingIndicatorCenterY?.isActive = true
        } else {
            successImageViewCenterY?.isActive = false
            successImageViewCenterY = successImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
            successImageViewCenterY?.isActive = true

            loadingIndicatorCenterY?.isActive = false
            loadingIndicatorCenterY = loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
            loadingIndicatorCenterY?.isActive = true
        }
    }

    private func startAnimating(withMessage message: String? = nil, displayType: DisplayType) {
        addHUD(displayType: displayType)
        messageLabel.text = message
        setupForMessage(message: message)
        successImageView.alpha = 0
        loadingIndicator.startAnimating()

        UIView.animate(withDuration: animationDuration) {
            self.alpha = 1
            self.loadingIndicator.alpha = 1
            self.loadingIndicator.transform = .identity
        }
    }

    private func showSuccess(withMessage message: String? = nil, displayType: DisplayType) {
        addHUD(displayType: displayType)
        loadingIndicator.alpha = 0
        messageLabel.text = message
        setupForMessage(message: message)

        UIView.animate(withDuration: animationDuration) {
            self.alpha = 1
            self.successImageView.alpha = 1
            self.successImageView.transform = .identity
        }
    }

    private func stopAnimating() {
        if defaultWindow != nil {
            UIView.animate(withDuration: animationDuration, animations: {
                self.alpha = 0
                self.loadingIndicator.transform = self.loadingIndicatorInitialTransform
                self.successImageView.transform = self.loadingIndicatorInitialTransform
            }, completion: { _ in
                self.messageLabel.text = nil
                self.loadingIndicator.stopAnimating()
                self.removeFromSuperview()
            })
        }
    }
}
