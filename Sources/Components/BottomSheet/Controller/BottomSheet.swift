//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

public protocol BottomSheetDelegate: AnyObject {
    func bottomSheetDidDismiss(_ bottomSheet: BottomSheet)
    func bottomSheetDidBeginDrag(_ bottomSheet: BottomSheet)
}

extension BottomSheetDelegate {
    // Default blank implementation.
    func bottomSheetDidBeginDrag(_ bottomSheet: BottomSheet) {}
}

extension BottomSheet {
    public struct Height {
        public let compact: CGFloat
        public let expanded: CGFloat

        public static var defaultFilterHeight: Height {
            let screenSize = UIScreen.main.bounds.size
            if screenSize.height <= 568 {
                return Height(compact: 510, expanded: 510)
            }
            if screenSize.height >= 812 {
                return Height(compact: 570, expanded: screenSize.height - 64)
            }
            return Height(compact: 510, expanded: screenSize.height - 64)
        }

        public static let zero = Height(compact: 0, expanded: 0)

        public init(compact: CGFloat, expanded: CGFloat) {
            self.compact = compact
            self.expanded = expanded
        }
    }

    public enum State {
        case expanded
        case compact
        case dismissed
    }
}

public class BottomSheet: UIViewController {
    public enum DraggableArea {
        case everything
        case navigationBar
        case topArea(height: CGFloat)
        case customRect(CGRect)
    }

    // MARK: - Public properties

    public weak var delegate: BottomSheetDelegate?

    public var state: State {
        get { return transitionDelegate.presentationController?.state ?? .dismissed }
        set { transitionDelegate.presentationController?.state = newValue }
    }

    var draggableRect: CGRect? {
        switch draggableArea {
        case .everything:
            return nil
        case .navigationBar:
            guard let navigationController = rootViewController as? UINavigationController else { return nil }
            let navBarFrame = navigationController.navigationBar.bounds
            let draggableBounds = CGRect(origin: navBarFrame.origin, size: CGSize(width: navBarFrame.width, height: navBarFrame.height + notchHeight))
            return draggableBounds
        case .topArea(let height):
            let rootControllerWidth = rootViewController.view.bounds.width
            return CGRect(origin: .zero, size: CGSize(width: rootControllerWidth, height: notchHeight + height))
        case .customRect(let customRect):
            return CGRect(origin: CGPoint(x: customRect.minX, y: customRect.minY + notchHeight), size: customRect.size)
        }
    }

    // MARK: - Private properties

    private let rootViewController: UIViewController
    private let transitionDelegate: BottomSheetTransitioningDelegate

    private let draggableArea: DraggableArea
    private let notchHeight: CGFloat = 20
    private let notch = Notch(withAutoLayout: true)
    private let cornerRadius: CGFloat = 16

    // Only necessary if iOS < 11.0
    private let maskLayer = CAShapeLayer()
    private let bottomSafeAreaInset: CGFloat

    // MARK: - Setup

    public init(rootViewController: UIViewController,
                appWindow: UIWindow? = UIApplication.shared.delegate?.window ?? nil,
                height: Height = .defaultFilterHeight,
                draggableArea: DraggableArea = .everything
                ) {
        self.rootViewController = rootViewController
        self.transitionDelegate = BottomSheetTransitioningDelegate(height: height)
        self.draggableArea = draggableArea
        if #available(iOS 11.0, *) {
            self.bottomSafeAreaInset = appWindow?.safeAreaInsets.bottom ?? 0
        } else {
            self.bottomSafeAreaInset = 0
        }
        super.init(nibName: nil, bundle: nil)
        transitionDelegate.presentationControllerDelegate = self
        transitioningDelegate = transitionDelegate
        modalPresentationStyle = .custom
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Only necessary if iOS < 11.0
    // ------------
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            return
        } else {
            let path = UIBezierPath(roundedRect: view.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
            maskLayer.path = path
            view.layer.mask = maskLayer
        }
    }
    // ------------

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.clipsToBounds = true
        if #available(iOS 11.0, *) {
            view.layer.cornerRadius = cornerRadius
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        view.addSubview(notch)

        addChild(rootViewController)
        view.insertSubview(rootViewController.view, belowSubview: notch)
        rootViewController.didMove(toParent: self)
        rootViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            notch.heightAnchor.constraint(equalToConstant: notchHeight),
            notch.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notch.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notch.topAnchor.constraint(equalTo: view.topAnchor),

            rootViewController.view.topAnchor.constraint(equalTo: notch.bottomAnchor),
            rootViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rootViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomSafeAreaInset)
        ])
    }
}

// MARK: - BottomSheetDismissalDelegate

extension BottomSheet: BottomSheetPresentationControllerDelegate {
    func bottomSheetPresentationController(_ presentationController: BottomSheetPresentationController, didDismissPresentedViewController presentedViewController: UIViewController) {
        delegate?.bottomSheetDidDismiss(self)
    }

    func bottomSheetPresentationControllerDidBeginDrag(_ presentationController: BottomSheetPresentationController) {
        delegate?.bottomSheetDidBeginDrag(self)
    }
}

// MARK: - Notch

private class Notch: UIView {

    // MARK: - private properties

    private let notchSize = CGSize(width: 25, height: 4)
    private let notch: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .sardine
        view.layer.cornerRadius = 2
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(notch)

        NSLayoutConstraint.activate([
            notch.centerXAnchor.constraint(equalTo: centerXAnchor),
            notch.centerYAnchor.constraint(equalTo: centerYAnchor),
            notch.heightAnchor.constraint(equalToConstant: notchSize.height),
            notch.widthAnchor.constraint(equalToConstant: notchSize.width)
        ])
    }
}
