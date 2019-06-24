//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public class MessageFormBottomSheet: BottomSheet {

    // MARK: - Private properties

    private let messageFormViewController = MessageFormViewController()
    private let rootController: UINavigationController!

    // MARK: - Init

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public required init() {
        rootController = UINavigationController(rootViewController: messageFormViewController)
        rootController.navigationBar.isTranslucent = false

        super.init(rootViewController: rootController, height: .messageFormHeight, draggableArea: .navigationBar)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Private extensions

private extension BottomSheet.Height {
    static var messageFormHeight: BottomSheet.Height {
        let screenSize = UIScreen.main.bounds.size

        if screenSize.height <= 568 {
            return BottomSheet.Height(compact: 510, expanded: 510)
        }

        let height = screenSize.height - 64

        return BottomSheet.Height(compact: height, expanded: height)
    }
}
