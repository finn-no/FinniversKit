//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

public struct DialogueDefaultData: DialogueViewModel {

    public let title = "Slå på anbefalinger"
    public let detail = "Vi viser deg relevante FINN-annonser og tilpasser FINN etter din bruk. For å gjøre dette lagrer vi info om hva du ser på hos oss."
    public var link = "Mer om personlig tilpasning"
    public let primaryButtonTitle = "Aktiver personlige anbefalinger"
}

public protocol DialogueViewControllerDelegate: AnyObject {
    func dialogueViewControllerDelegateDidSelectPrimaryButton()
}

class DialogueViewController: UIViewController {

    public weak var delegate: DialogueViewControllerDelegate?

    private lazy var dialogueView: DialogueView = {
        let dialogueView = DialogueView(withAutoLayout: true)
        dialogueView.model = DialogueDefaultData()
        dialogueView.delegate = self
        return dialogueView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(dialogueView)

        NSLayoutConstraint.activate([
            dialogueView.topAnchor.constraint(equalTo: view.topAnchor),
            dialogueView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dialogueView.widthAnchor.constraint(equalTo: view.widthAnchor),
            dialogueView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
    }
}

extension DialogueViewController: DialogueViewDelegate {
    func dialogueViewDidSelectLink() {}
    func dialogueViewDidSelectPrimaryButton() {
        delegate?.dialogueViewControllerDelegateDidSelectPrimaryButton()
    }
}
