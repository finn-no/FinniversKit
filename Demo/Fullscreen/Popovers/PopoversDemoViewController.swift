//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class PopoversDemoViewController: BaseDemoViewController<UIView> {
    private let demoViews: [FullscreenDemoViews] = [
        .favoriteFolderActionSheet,
        .favoriteAdSortingSheet,
        .favoriteAdActionSheet,
        .favoriteAdCommentSheet
    ]

    private lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.delegate = self
        view.dataSource = self
        return view
    }()

    private let button: UIButton = {
        let button = Button(style: .callToAction)
        button.setTitle("Present", for: .normal)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        let stackView = UIStackView(arrangedSubviews: [pickerView, button])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = .mediumLargeSpacing

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func handleButtonTap() {
        let demoView = demoViews[pickerView.selectedRow(inComponent: 0)]
        let viewController = demoView.viewController

        (viewController as? BottomSheet)?.isNotchHidden = true
        viewController.modalPresentationStyle = .popover
        viewController.popoverPresentationController?.backgroundColor = .bgPrimary
        viewController.popoverPresentationController?.delegate = self
        viewController.popoverPresentationController?.permittedArrowDirections = .any
        viewController.popoverPresentationController?.sourceView = button
        viewController.popoverPresentationController?.sourceRect = button.bounds

        present(viewController, animated: true)
    }
}

// MARK: - UIPickerViewDataSource

extension PopoversDemoViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { demoViews.count }
}

// MARK: - UIPickerViewDataSource

extension PopoversDemoViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        demoViews[row].rawValue
    }
}

// MARK: - UIPopoverPresentationControllerDelegate

extension PopoversDemoViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
