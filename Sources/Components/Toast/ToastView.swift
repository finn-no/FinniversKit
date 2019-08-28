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
        action?.action()
    }

    public func presentFromBottom(view: UIView, animateOffset: CGFloat, timeOut: Double? = nil) {
        setupToastConstraint(for: view)

        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut, animations: {
            let coverViewHeight = self.safeAreaCoverView?.frame.height ?? 0
            self.transform = self.transform.translatedBy(x: 0, y: -(self.frame.height + animateOffset + coverViewHeight))
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
                self.removeSafeAreaCoverView()
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
            topAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        setupSafeAreaCoverViewIfNeeded(for: view)
        view.layoutIfNeeded()
    }

    private func setupSafeAreaCoverViewIfNeeded(for view: UIView) {
        let height = view.safeAreaInsets.bottom
        if height > 0 {
            let view = UIView(withAutoLayout: true)
            view.backgroundColor = style.color
            addSubview(view)
            safeAreaCoverView = view

            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalTo: widthAnchor),
                view.heightAnchor.constraint(equalToConstant: height),
                view.topAnchor.constraint(equalTo: bottomAnchor)
                ])
        }
    }

    private func removeSafeAreaCoverView() {
        safeAreaCoverView?.removeFromSuperview()
        safeAreaCoverView = nil
    }
}
