//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

protocol RootViewControllerDelegate: class {
    func rootViewControllerDidPressExpandButton(_ controller: RootViewController)
    func rootViewControllerDidPressCompactButton(_ controller: RootViewController)
    func rootViewControllerDidPressDismissButton(_ controller: RootViewController)
}

class RootViewController: UIViewController {

    weak var delegate: RootViewControllerDelegate?

    private lazy var expandButton: Button = {
        let button = Button(style: .callToAction)
        button.setTitle("Expand", for: .normal)
        button.addTarget(self, action: #selector(expandButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var compactButton: Button = {
        let button = Button(style: .callToAction)
        button.setTitle("Compact", for: .normal)
        button.addTarget(self, action: #selector(compactButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var dismissButton: Button = {
        let button = Button(style: .callToAction)
        button.setTitle("Dismiss", for: .normal)
        button.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .milk
        view.addSubview(expandButton)
        view.addSubview(compactButton)
        view.addSubview(dismissButton)
        NSLayoutConstraint.activate([
            expandButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            expandButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),
            expandButton.topAnchor.constraint(equalTo: view.topAnchor, constant: .mediumSpacing),

            compactButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            compactButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),
            compactButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),

            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),
            dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.veryLargeSpacing),
        ])
    }

    @objc func expandButtonPressed() {
        delegate?.rootViewControllerDidPressExpandButton(self)
    }

    @objc func compactButtonPressed() {
        delegate?.rootViewControllerDidPressCompactButton(self)
    }

    @objc func dismissButtonPressed() {
        delegate?.rootViewControllerDidPressDismissButton(self)
    }
}

class BottomSheetMechanicsDemoViewController: UIViewController {

    private lazy var presentButton: Button = {
        let button = Button(style: .callToAction)
        button.setTitle("Present", for: .normal)
        button.addTarget(self, action: #selector(presentButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var bottomSheet: BottomSheet?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .milk
        view.addSubview(presentButton)
        NSLayoutConstraint.activate([
            presentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            presentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),
            presentButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.veryLargeSpacing),
        ])
    }

    @objc func presentButtonPressed() {
        let rootController = RootViewController()
        rootController.delegate = self
        let bottomSheet = BottomSheet(rootViewController: rootController)
        present(bottomSheet, animated: true)
        self.bottomSheet = bottomSheet
    }
}

extension BottomSheetMechanicsDemoViewController: RootViewControllerDelegate {
    func rootViewControllerDidPressExpandButton(_ controller: RootViewController) {
        bottomSheet?.state = .expanded
    }

    func rootViewControllerDidPressCompactButton(_ controller: RootViewController) {
        bottomSheet?.state = .compact
    }

    func rootViewControllerDidPressDismissButton(_ controller: RootViewController) {
        bottomSheet?.state = .dismissed
    }
}
