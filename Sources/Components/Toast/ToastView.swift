//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class ToastAction: NSObject {
    public private(set) var title: String
    public private(set) var action: (() -> Void)

    public init(title: String, action: @escaping (() -> Void)) {
        self.title = title
        self.action = action
    }
}

public class ToastView: UIView {

    public enum ButtonStyle {
        case normal
        case promoted
    }

    // MARK: - Internal properties

    private let animationDuration: Double = 0.3
    private let imageSizeAllowedMin = CGSize(width: 16, height: 16)
    private let imageSizeAllowedMax = CGSize(width: 26, height: 26)
    private let buttonStyle: ButtonStyle

    private lazy var messageTitle: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .textToast
        return label
    }()

    private lazy var actionButton: ToastButton = {
        let button = ToastButton(toastStyle: style, buttonStyle: buttonStyle)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var safeAreaCoverView: UIView?

    // MARK: - External properties / Dependency injection

    public let style: Style
    public var text: String = "" {
        didSet {
            messageTitle.text = text
            accessibilityLabel = text
        }
    }

    public var attributedText: NSAttributedString? {
        didSet {
            messageTitle.attributedText = attributedText
            accessibilityLabel = attributedText?.string ?? ""
        }
    }

    public var image: UIImage? {
        get {
            guard let image = imageView.image else {
                switch style {
                case .error, .errorButton: return UIImage(named: .minusCircleFilledMini)
                case .sucesssWithImage: return UIImage(named: .noImage)
                default: return UIImage(named: .checkCircleFilledMini)
                }
            }
            return image
        }
        set {
            if style == .sucesssWithImage {
                imageView.image = newValue
            }
        }
    }

    public var action: ToastAction? {
        didSet {
            actionButton.setTitle(action?.title, for: .normal)
            accessibilityHint = action?.title
        }
    }

    // MARK: - Setup

    public init(style: Style, buttonStyle: ButtonStyle = .normal) {
        self.style = style
        self.buttonStyle = buttonStyle
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(style: .success)
    }

    private func setup() {
        isAccessibilityElement = true

        backgroundColor = style.color
        imageView.backgroundColor = style.imageBackgroundColor
        imageView.image = image

        addSubview(imageView)
        addSubview(messageTitle)
        addSubview(actionButton)

        directionalLayoutMargins = NSDirectionalEdgeInsets(all: .mediumLargeSpacing)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: messageTitle.centerYAnchor),
            imageView.widthAnchor.constraint(lessThanOrEqualToConstant: imageSizeAllowedMax.width),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: imageSizeAllowedMax.height),
            imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: imageSizeAllowedMin.width),
            imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: imageSizeAllowedMin.height),

            messageTitle.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: .mediumLargeSpacing),
            messageTitle.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            messageTitle.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])

        if style == .successButton || style == .errorButton {
            actionButton.isHidden = false

            NSLayoutConstraint.activate([
                messageTitle.trailingAnchor.constraint(lessThanOrEqualTo: actionButton.leadingAnchor, constant: -.mediumLargeSpacing),
                actionButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
                actionButton.centerYAnchor.constraint(equalTo: messageTitle.centerYAnchor)
            ])
        } else {
            actionButton.isHidden = true
            messageTitle.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        }
    }

    // MARK: - Actions

    @objc private func swipeAction() {
        dismissToast()
    }

    @objc private func buttonAction() {
        action?.action()
        dismissToast()
    }

    // MARK: - Public methods

    /// Presents toast from the safe area top
    ///
    /// - Parameters:
    ///   - view: the container for the toast view
    ///   - animateOffset: extra offset to animate the vertical position of the toast view
    ///   - timeOut: time in seconds to automatically dismiss the toast view after presenting it
    public func presentFromTop(view: UIView, animateOffset: CGFloat, timeOut: Double? = nil) {
        setupToastConstraint(for: view, fromBottom: false)

        addSwipeGestureRecognizer(direction: .up)

        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = self.transform.translatedBy(x: 0, y: self.frame.height + animateOffset)
        })

        // Dismissal animation
        if let timeOut = timeOut {
            dismissToast(after: timeOut)
        }
    }

    public func presentFromBottom(view: UIView, animateOffset: CGFloat, timeOut: Double? = nil) {
        setupToastConstraint(for: view)

        addSwipeGestureRecognizer(direction: .down)

        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = self.transform.translatedBy(x: 0, y: -(self.frame.height + animateOffset))
        })

        if let timeOut = timeOut {
            dismissToast(after: timeOut)
        }
    }

    public func dismissToast(after delay: Double = 0.0) {
        // Uses asyncAfter instead of animate delay because then it can be dismissed by swipe before the timeout if needed
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            UIView.animate(withDuration: self.animationDuration, delay: 0, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform.identity
            }, completion: { _ in
                self.removeFromSuperview()
            })
        }
    }

    // MARK: - Private methods

    private func setupToastConstraint(for view: UIView, fromBottom: Bool = true) {
        view.addSubview(self)

        translatesAutoresizingMaskIntoConstraints = false

        let verticalPositionConstraint: NSLayoutConstraint
        if fromBottom {
            verticalPositionConstraint = topAnchor.constraint(equalTo: view.bottomAnchor)
        } else {
            verticalPositionConstraint = bottomAnchor.constraint(equalTo: view.topAnchor)
        }

        NSLayoutConstraint.activate([
            verticalPositionConstraint,
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        view.layoutIfNeeded()
    }

    private func addSwipeGestureRecognizer(direction: UISwipeGestureRecognizer.Direction) {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        swipeGesture.direction = direction
        addGestureRecognizer(swipeGesture)
    }
}
