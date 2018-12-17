//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FinniversKit

class BottomSheetDemoViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let view = UITableView()
        return view
    }()

    private lazy var viewController: UIViewController = {
        let viewController = UIViewController(nibName: nil, bundle: nil)
        viewController.navigationItem.title = "Bottom Sheet"
        viewController.view.backgroundColor = .milk
        return viewController
    }()

    private lazy var button: Button = {
        let button = Button(style: .callToAction)
        button.setTitle("Present", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
    }
}

private extension BottomSheetDemoViewController {
    @objc func buttonTapped() {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.stone]
        navigationController.navigationBar.isTranslucent = false
        let bottomSheet = BottomSheet(rootViewController: navigationController)
        present(bottomSheet, animated: true)
    }

    @objc func didDoubleTap() {
        State.lastSelectedIndexPath = nil
        dismiss(animated: true)
    }

    func setup() {
        view.backgroundColor = .milk
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .largeSpacing),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.largeSpacing),
            button.bottomAnchor.constraint(equalTo: view.compatibleBottomAnchor, constant: -.largeSpacing),
        ])
    }
}
