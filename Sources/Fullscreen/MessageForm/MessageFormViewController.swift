//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public class MessageFormBottomSheet: BottomSheet {

    // MARK: - Private properties

    private let messageFormViewController = MessageFormViewController()

    // MARK: - Init

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public required init() {
        let navigationController = UINavigationController(rootViewController: messageFormViewController)
        navigationController.navigationBar.isTranslucent = false

        super.init(rootViewController: navigationController, draggableArea: .navigationBar)
    }
}

class MessageFormViewController: UIViewController {

    // MARK: - UI properties

    private lazy var messageFormView = MessageFormView(withAutoLayout: true)

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public required init() {
        super.init(nibName: nil, bundle: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        title = "Send melding"
        view.addSubview(messageFormView)
        messageFormView.fillInSuperview()
    }
}
