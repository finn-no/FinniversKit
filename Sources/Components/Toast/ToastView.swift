//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol ToastViewDelegate: class {
    func didTapActionButton(button: UIButton, in toastView: ToastView)
    func didTap(toastView: ToastView)
    func didSwipeDown(on toastView: ToastView)
}

public extension ToastViewDelegate {
    func didTapActionButton(button: UIButton, in toastView: ToastView) {
        // Default nothing happens
    }

    func didTap(toastView: ToastView) {
        // Default nothing happens
    }

    func didSwipeDown(on toastView: ToastView) {
        toastView.dismissToast()
    }
}

public class ToastView: UIView {
    // MARK: - Internal properties

    private let animationDuration: Double = 0.3
    private let imageSizeAllowedMin = CGSize(width: 18, height: 18)
    private let imageSizeAllowedMax = CGSize(width: 26, height: 26)

    private lazy var messageTitle: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.primaryBlue, for: .normal)
        button.titleLabel?.font = .bodyStrong
        button.layer.masksToBounds = true
        button.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .horizontal)
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

    // MARK: - External properties / Dependency injection

    public let style: Style
    public var text: String = "" {
        didSet {
            messageTitle.text = text
            accessibilityLabel = text
        }
    }

    public var image: UIImage? {
        get {
            guard let image = imageView.image else {
                switch style {
                case .error, .errorButton: return UIImage(named: .error)
                case .sucesssWithImage: return UIImage(named: .noImage)
                default: return UIImage(named: .success)
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

    public var buttonText: String = "" {
        didSet {
            actionButton.setTitle(buttonText, for: .normal)
        }
    }

    public weak var delegate: ToastViewDelegate?

    // MARK: - Setup

    public init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        setup()
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(style: .success)
    }

    private func setup() {
        isAccessibilityElement = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        swipeGesture.direction = .down
        gestureRecognizers = [tapGesture, swipeGesture]

        backgroundColor = style.color
        imageView.backgroundColor = style.imageBackgroundColor
        imageView.image = image

        addSubview(imageView)
        addSubview(messageTitle)
        addSubview(actionButton)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(lessThanOrEqualToConstant: imageSizeAllowedMax.width),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: imageSizeAllowedMax.height),
            imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: imageSizeAllowedMin.width),
            imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: imageSizeAllowedMin.height),

            messageTitle.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: .mediumLargeSpacing),
            messageTitle.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            messageTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing)
        ])

        if style == .successButton || style == .errorButton {
            actionButton.isHidden = false

            NSLayoutConstraint.activate([
                messageTitle.trailingAnchor.constraint(lessThanOrEqualTo: actionButton.leadingAnchor, constant: -.mediumLargeSpacing),
                actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
                actionButton.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        } else {
            actionButton.isHidden = true
            messageTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing).isActive = true
        }
    }

    // MARK: - Actions

    @objc private func buttonAction() {
        delegate?.didTapActionButton(button: actionButton, in: self)
    }

    @objc private func tapAction() {
        delegate?.didTap(toastView: self)
    }

    @objc private func swipeAction() {
        delegate?.didSwipeDown(on: self)
    }

    public func presentFromBottom(view: UIView, animateOffset: CGFloat, timeOut: Double? = nil) {
        setupToastConstraint(for: view)

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

    private func setupToastConstraint(for view: UIView) {
        view.addSubview(self)

        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.compatibleBottomAnchor)
        ])

        view.layoutIfNeeded()
    }
}
