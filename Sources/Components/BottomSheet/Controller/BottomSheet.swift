//
//  BottomSheet.swift
//  bottom-sheets
//
//  Created by Granheim Brustad , Henrik on 09/10/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit

public class BottomSheet: UIViewController {

    // MARK: - Public properties

    public var rootViewController: UIViewController

    // MARK: - Private properties

    private let transitionDelegate = BottomSheetTransitioningDelegate()

    private let notch: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .sardine
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Only necessary if iOS < 11.0
    private let maskLayer = CAShapeLayer()
    // ---------------

    // MARK: - Setup

    public init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        super.init(nibName: nil, bundle: nil)
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
                                    cornerRadii: CGSize(width: 16, height: 16)).cgPath
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
            view.layer.cornerRadius = 16
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        view.addSubview(notch)

        addChild(rootViewController)
        view.insertSubview(rootViewController.view, belowSubview: notch)
        rootViewController.didMove(toParent: self)
        rootViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            notch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notch.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            notch.heightAnchor.constraint(equalToConstant: 4),
            notch.widthAnchor.constraint(equalToConstant: 25),

            rootViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            rootViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rootViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

