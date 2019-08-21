//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

protocol RootViewControllerDelegate: AnyObject {
    func rootViewControllerDidPressExpandButton(_ controller: RootViewController)
    func rootViewControllerDidPressCompactButton(_ controller: RootViewController)
    func rootViewControllerDidPressDismissButton(_ controller: RootViewController)
}

class RootViewController: UIViewController {

    // MARK: - Public properties

    weak var delegate: RootViewControllerDelegate?
    var draggableLabelFrame: CGRect {
        return CGRect(
            origin: CGPoint(x: 0, y: 150),
            size: CGSize(width: view.frame.width, height: 44)
        )
    }

    // MARK: - Private properties

    private let showDraggableLabel: Bool

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

    private lazy var draggableLabel: UILabel = {
        let label = UILabel(frame: draggableLabelFrame)
        label.textAlignment = .center
        label.font = UIFont.title2
        label.text = "👆😎👇"
        label.backgroundColor = .salmon
        return label
    }()

    // MARK: - Init

    init(showDraggableLabel: Bool = false) {
        self.showDraggableLabel = showDraggableLabel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .milk
        view.addSubview(expandButton)
        view.addSubview(compactButton)
        view.addSubview(dismissButton)

        if showDraggableLabel {
            view.addSubview(draggableLabel)
        }

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

    @objc private func expandButtonPressed() {
        delegate?.rootViewControllerDidPressExpandButton(self)
    }

    @objc private func compactButtonPressed() {
        delegate?.rootViewControllerDidPressCompactButton(self)
    }

    @objc private func dismissButtonPressed() {
        delegate?.rootViewControllerDidPressDismissButton(self)
    }
}

class BottomSheetMechanicsDemoViewController: UIViewController {
    private lazy var requireConfirmationOnDragSwitch: SwitchView = {
        let switchView = SwitchView(withAutoLayout: true)
        switchView.configure(with:
            SwitchViewDefaultModel(
                title: "Confirm Dismiss",
                detail: "Set if bottom sheets require confirmation before they can be dismissed.",
                initialSwitchValue: true
            )
        )
        switchView.isOn = false
        return switchView
    }()

    private lazy var presentAllDraggableButton: Button = {
        let button = Button(style: .callToAction)
        button.setTitle("Present - everything draggable", for: .normal)
        button.addTarget(self, action: #selector(presentAllDraggableButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var presentNavBarDraggableButton: Button = {
        let button = Button(style: .callToAction)
        button.setTitle("Present - navBar draggable", for: .normal)
        button.addTarget(self, action: #selector(presentNavBarDraggableButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var presentTopAreaDraggableButton: Button = {
        let button = Button(style: .callToAction)
        button.setTitle("Present - topArea draggable", for: .normal)
        button.addTarget(self, action: #selector(presentTopAreaDraggableButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var presentCustomDraggableButton: Button = {
        let button = Button(style: .callToAction)
        button.setTitle("Present - custom draggable", for: .normal)
        button.addTarget(self, action: #selector(presentCustomDraggableButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var bottomSheet: BottomSheet?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .milk
        view.addSubview(requireConfirmationOnDragSwitch)
        view.addSubview(presentAllDraggableButton)
        view.addSubview(presentNavBarDraggableButton)
        view.addSubview(presentTopAreaDraggableButton)
        view.addSubview(presentCustomDraggableButton)

        NSLayoutConstraint.activate([
            requireConfirmationOnDragSwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            requireConfirmationOnDragSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),
            requireConfirmationOnDragSwitch.bottomAnchor.constraint(equalTo: presentAllDraggableButton.topAnchor, constant: -.veryLargeSpacing),

            presentAllDraggableButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            presentAllDraggableButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),
            presentAllDraggableButton.bottomAnchor.constraint(equalTo: presentNavBarDraggableButton.topAnchor, constant: -.largeSpacing),

            presentNavBarDraggableButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            presentNavBarDraggableButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),
            presentNavBarDraggableButton.bottomAnchor.constraint(equalTo: presentTopAreaDraggableButton.topAnchor, constant: -.largeSpacing),

            presentTopAreaDraggableButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            presentTopAreaDraggableButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),
            presentTopAreaDraggableButton.bottomAnchor.constraint(equalTo: presentCustomDraggableButton.topAnchor, constant: -.largeSpacing),

            presentCustomDraggableButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            presentCustomDraggableButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),
            presentCustomDraggableButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.largeSpacing)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        tapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func handleDoubleTap() {
        State.lastSelectedIndexPath = nil
        dismiss(animated: true)
    }

    @objc private func presentAllDraggableButtonPressed() {
        let rootController = RootViewController()
        rootController.delegate = self
        let bottomSheet = BottomSheet(rootViewController: rootController, draggableArea: .everything)
        bottomSheet.delegate = self
        present(bottomSheet, animated: true)
        self.bottomSheet = bottomSheet
    }

    @objc private func presentNavBarDraggableButtonPressed() {
        let rootController = RootViewController()
        rootController.delegate = self
        rootController.title = "👆😎👇"

        let navigationController = UINavigationController(rootViewController: rootController)
        navigationController.navigationBar.isTranslucent = false

        let bottomSheet = BottomSheet(rootViewController: navigationController, draggableArea: .navigationBar)
        bottomSheet.delegate = self
        present(bottomSheet, animated: true)
        self.bottomSheet = bottomSheet
    }

    @objc private func presentTopAreaDraggableButtonPressed() {
        let rootController = RootViewController()
        rootController.delegate = self
        rootController.title = "👆😎👇"

        let navigationController = UINavigationController(rootViewController: rootController)
        navigationController.navigationBar.isTranslucent = false

        // Set draggable height to height of navBar.
        let draggableAreaHeight = navigationController.navigationBar.bounds.height
        let bottomSheet = BottomSheet(rootViewController: navigationController, draggableArea: .topArea(height: draggableAreaHeight))
        bottomSheet.delegate = self
        present(bottomSheet, animated: true)
        self.bottomSheet = bottomSheet
    }

    @objc private func presentCustomDraggableButtonPressed() {
        let rootController = RootViewController(showDraggableLabel: true)
        rootController.delegate = self
        let bottomSheet = BottomSheet(rootViewController: rootController, draggableArea: .customRect(rootController.draggableLabelFrame))
        bottomSheet.delegate = self
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

extension BottomSheetMechanicsDemoViewController: BottomSheetDelegate {
    func bottomSheetShouldDismiss(_ bottomSheet: BottomSheet) -> Bool {
        return !requireConfirmationOnDragSwitch.isOn
    }

    func bottomSheetDidCancelDismiss(_ bottomSheet: BottomSheet) {
        let alertStyle: UIAlertController.Style = UIDevice.isIPad() ? .alert : .actionSheet

        let alertController = UIAlertController(title: "Dismiss?",
                                                message: "Confirmation required",
                                                preferredStyle: alertStyle)
        let cancelAction = UIAlertAction(title: "Don't dismiss", style: .cancel, handler: nil)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: { _ in
            bottomSheet.state = .dismissed
        })

        alertController.addAction(dismissAction)
        alertController.addAction(cancelAction)

        bottomSheet.present(alertController, animated: true)
    }

    func bottomSheet(_ bottomSheet: BottomSheet, didDismissBy action: BottomSheet.DismissAction) {
        // BottomSheet dismissed.
    }
}
