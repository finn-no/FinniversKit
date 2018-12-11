//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

extension BottomSheet {
    public struct Height {
        let compact: CGFloat
        let expanded: CGFloat?

        public static let zero = Height(compact: 0, expanded: 0)

        public init(compact: CGFloat, expanded: CGFloat? = nil) {
            self.compact = compact
            self.expanded = expanded
        }
    }
}

public class BottomSheet: UIViewController {

    // MARK: - Private properties

    private let height: Height

    private let rootViewController: UIViewController
    private let transitionDelegate = BottomSheetTransitioningDelegate()

    private let notchSize = CGSize(width: 25, height: 4)
    private let notch: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .sardine
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let cornerRadius: CGFloat = 16

    // Only necessary if iOS < 11.0
    private let maskLayer = CAShapeLayer()
    // ---------------

    // MARK: - Setup

    public init(rootViewController: UIViewController, height: Height) {
        self.height = height
        self.rootViewController = rootViewController
        super.init(nibName: nil, bundle: nil)
        transitionDelegate.height = height
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
        // No expanded size means bottom sheet should be static
        if height.expanded != nil {
            view.addSubview(notch)
            NSLayoutConstraint.activate([
                notch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                notch.topAnchor.constraint(equalTo: view.topAnchor, constant: .mediumSpacing),
                notch.heightAnchor.constraint(equalToConstant: notchSize.height),
                notch.widthAnchor.constraint(equalToConstant: notchSize.width),
            ])
        }

        addChild(rootViewController)
        view.insertSubview(rootViewController.view, belowSubview: notch)
        rootViewController.didMove(toParent: self)
        rootViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            rootViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: .mediumLargeSpacing + notchSize.height),
            rootViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rootViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
