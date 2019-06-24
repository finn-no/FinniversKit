//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

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

        super.init(rootViewController: rootController, draggableArea: .navigationBar)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class MessageFormViewController: UIViewController {

    // MARK: - UI properties

    private lazy var messageFormView = MessageFormView(withAutoLayout: true)
    private lazy var cancelButton = UIBarButtonItem(title: "Avbryt", style: .plain, target: self, action: #selector(cancelButtonTapped))
    private lazy var sendButton = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(sendButtonTapped))

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

        navigationItem.setLeftBarButton(cancelButton, animated: false)
        navigationItem.setRightBarButton(sendButton, animated: false)
    }

    // MARK: - Private methods

    @objc private func cancelButtonTapped() {

    }

    @objc private func sendButtonTapped() {

    }
}
