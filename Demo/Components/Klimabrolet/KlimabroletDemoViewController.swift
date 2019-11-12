//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit
import Sparkle

class KlimabroletDemoViewController: BaseDemoViewController<UIView> {
    private lazy var klimabroletView: KlimabroletView = {
        let view = KlimabroletView(withAutoLayout: true)
        view.configure(with: KlimabroletData.ViewModel())
        view.delegate = self
        return view
    }()

    private lazy var klimabroletViewController: UIViewController = {
        let controller = UIViewController()
        controller.view.addSubview(klimabroletView)
        controller.setNeedsStatusBarAppearanceUpdate()
        klimabroletView.fillInSuperview()

        return controller
    }()

    private lazy var eventListViewController: KlimabroletEventsDemoViewController = {
        let controller = KlimabroletEventsDemoViewController(style: .plain)
        controller.delegate = self
        return controller
    }()

    private lazy var innerNavigationController: UINavigationController = {
        let navigation = NavigationController(rootViewController: klimabroletViewController)
        navigation.view.translatesAutoresizingMaskIntoConstraints = false
        navigation.setNavigationBarHidden(true, animated: false)
        navigation.view.layer.cornerRadius = 20
        navigation.view.clipsToBounds = true
        navigation.delegate = self

        return navigation
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        playgroundView.backgroundColor = .black

        addChild(innerNavigationController)
        innerNavigationController.didMove(toParent: self)
        view.addSubview(innerNavigationController.view)

        NSLayoutConstraint.activate([
            innerNavigationController.view.widthAnchor.constraint(equalToConstant: 320),
            innerNavigationController.view.heightAnchor.constraint(equalToConstant: 536),
            innerNavigationController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            innerNavigationController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func close() {
        SparkleState.lastSelectedIndexPath = nil
        dismiss(animated: true, completion: nil)
    }
}

extension KlimabroletDemoViewController: KlimabroletViewDelegate {
    func klimabroletViewDidSelectReadMore(_ view: KlimabroletView) {
        guard let url = KlimabroletData.campaignURL else {
            return
        }

        UIApplication.shared.open(url)
    }

    func klimabroletViewDidSelectAccept(_ view: KlimabroletView) {
        innerNavigationController.pushViewController(eventListViewController, animated: true)
    }

    func klimabroletViewDidSelectDecline(_ view: KlimabroletView) {
        close()
    }

    func klimabroletViewDidSelectClose(_ view: KlimabroletView) {
        close()
    }
}

extension KlimabroletDemoViewController: KlimabroletEventsDemoViewControllerDelegate {
    func eventList(_ eventListViewController: KlimabroletEventsDemoViewController, didSelect event: KlimabroletData.Event) {
        guard let url = event.url else {
            return
        }

        UIApplication.shared.open(url)
    }

    func eventListDidSelectClose(_ eventListViewController: KlimabroletEventsDemoViewController) {
        close()
    }
}

extension KlimabroletDemoViewController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool
    ) {
        let needsNavigationBarHidden = viewController == klimabroletViewController
        innerNavigationController.setNavigationBarHidden(needsNavigationBarHidden, animated: true)
    }
}
