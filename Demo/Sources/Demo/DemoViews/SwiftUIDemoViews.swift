//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI
@testable import FinnUI
@testable import FinniversKit

@available(iOS 13.0, *)
public enum SwiftUIDemoViews: String, DemoViews {
    case buttons
    case settings
    case textField
    case textView
    case basicCellVariations
    case bapAdView
    case myVehiclesListView

    public var viewController: UIViewController {
        PreviewController(hostingController: hostingController)
    }

    private var hostingController: UIViewController {
        UIHostingController(rootView: previews)
    }

    @ViewBuilder private var previews: some View {
        switch self {
        case .buttons:
            ButtonStyleUsageDemoView_Previews.previews
        case .settings:
            SettingsView_Previews.previews
        case .textField:
            FinnTextField_Previews.previews
        case .textView:
            FinnTextView_Previews.previews
        case .basicCellVariations:
            BasicListCell_Previews.previews
        case .bapAdView:
            BapAdView_Previews.previews
        case .myVehiclesListView:
            MyVehiclesListView_Previews.previews
        }
    }
}

private final class PreviewController: DemoViewController<UIView> {
    var hostingController: UIViewController

    init(hostingController: UIViewController) {
        self.hostingController = hostingController
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let childViewController = childViewController else {
            return
        }

        childViewController.addChild(hostingController)
        hostingController.view.frame = childViewController.view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.view.addSubview(hostingController.view)
        hostingController.didMove(toParent: childViewController)
    }
}
