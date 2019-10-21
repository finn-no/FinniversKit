//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

public protocol BottomSheetDelegate: AnyObject {
    /// Called by the BottomSheet *throughout* actions intended to dismiss the BottomSheet.
    /// The action performed by the user may not end in dismissal. The delegate should
    /// be consistent in the returned value.
    func bottomSheetShouldDismiss(_ bottomSheet: BottomSheet) -> Bool

    /// Called by the BottomSheet after the user has performed an action that would normally
    /// cause the BottomSheet to be dismissed, but `bottomSheetShouldDismiss(:)` prevented this
    /// from happening.
    func bottomSheetDidCancelDismiss(_ bottomSheet: BottomSheet)

    func bottomSheet(_ bottomSheet: BottomSheet, didDismissBy action: BottomSheet.DismissAction)
}

public protocol BottomSheetDragDelegate: AnyObject {
    func bottomSheetDidBeginDrag(_ bottomSheet: BottomSheet)
}

extension BottomSheet {
    public struct Height: Equatable {
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

    public enum DismissAction {
        case tap
        case drag
        case none
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

    public let rootViewController: UIViewController
    public weak var delegate: BottomSheetDelegate?
    public weak var dragDelegate: BottomSheetDragDelegate?

    public var state: State {
        get { transitionDelegate.presentationController?.state ?? .dismissed }
        set { transitionDelegate.presentationController?.state = newValue }
    }

    public var height: Height {
        get { transitionDelegate.height }
        set { transitionDelegate.height = newValue }
    }

    public var isNotchHidden: Bool {
        get { notch.isHidden }
        set { notch.isHidden = newValue }
    }

    public let dimView: UIView

    let notch: UIView = Notch(withAutoLayout: true)

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

    private let transitionDelegate: BottomSheetTransitioningDelegate
    private let draggableArea: DraggableArea
    private let notchHeight: CGFloat = 20
    private let cornerRadius: CGFloat = 16

    // MARK: - Setup

    public init(rootViewController: UIViewController,
                height: Height = .defaultFilterHeight,
                draggableArea: DraggableArea = .everything) {
        self.rootViewController = rootViewController
        self.transitionDelegate = BottomSheetTransitioningDelegate(height: height)
        self.dimView = transitionDelegate.dimView
        self.draggableArea = draggableArea
        super.init(nibName: nil, bundle: nil)
        transitionDelegate.presentationControllerDelegate = self
        transitioningDelegate = transitionDelegate
        modalPresentationStyle = .custom
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = rootViewController.view.backgroundColor ?? .bgPrimary
        view.clipsToBounds = true
        view.layer.cornerRadius = cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
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
            rootViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - BottomSheetDismissalDelegate

extension BottomSheet: BottomSheetPresentationControllerDelegate {
    func bottomSheetPresentationControllerShouldDismiss(_ presentationController: BottomSheetPresentationController) -> Bool {
        return delegate?.bottomSheetShouldDismiss(self) ?? true
    }

    func bottomSheetPresentationControllerDidCancelDismiss(_ presentationController: BottomSheetPresentationController) {
        delegate?.bottomSheetDidCancelDismiss(self)
    }

    func bottomSheetPresentationController(_ presentationController: BottomSheetPresentationController, didDismissPresentedViewController presentedViewController: UIViewController, by action: BottomSheet.DismissAction) {
        delegate?.bottomSheet(self, didDismissBy: action)
    }

    func bottomSheetPresentationControllerDidBeginDrag(_ presentationController: BottomSheetPresentationController) {
        dragDelegate?.bottomSheetDidBeginDrag(self)
    }
}

// MARK: - Notch

private class Notch: UIView {

    // MARK: - private properties

    private let notchSize = CGSize(width: 25, height: 4)
    private let notch: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .textDisabled //DARK
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
