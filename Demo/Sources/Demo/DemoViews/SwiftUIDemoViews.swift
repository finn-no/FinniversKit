//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI
import FinniversKit

public enum SwiftUIDemoViews: String, DemoViews {
    case htmlParser
    case textField
    case textView

    public var viewController: UIViewController {
        if self == .htmlParser {
            return HTMLParserPreviewController()
        }
        return PreviewController(hostingController: hostingController)
    }

    private var hostingController: UIViewController {
        UIHostingController(rootView: previews)
    }

    @ViewBuilder private var previews: some View {
        switch self {
        case .textField:
            FinnTextField_Previews.previews
        case .textView:
            FinnTextView_Previews.previews
        default:
            EmptyView()
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
