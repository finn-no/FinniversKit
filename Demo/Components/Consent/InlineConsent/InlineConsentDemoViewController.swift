//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class InlineConsentDemoViewController: UIViewController {

    private lazy var dismiss: Button = {
        let button = Button(style: .destructive)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Dismiss", for: .normal)
        button.addTarget(self, action: #selector(handleDismissTap), for: .touchUpInside)
        return button
    }()

    private lazy var presentDialogue: Button = {
        let button = Button(style: .default)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Present Dialogue", for: .normal)
        button.addTarget(self, action: #selector(handlePresentDialogueTap), for: .touchUpInside)
        return button
    }()

    private lazy var top: UIView = {
        let top = UIView(withAutoLayout: true)
        top.backgroundColor = .milk
        return top
    }()

    private lazy var bottom: UIView = {
        let bottom = UIView(withAutoLayout: true)
        bottom.backgroundColor = .toothPaste
        return bottom
    }()

    private lazy var bottomDialogue: UIView = {
        let bottomDialogue = UIView(withAutoLayout: true)
        bottomDialogue.backgroundColor = .toothPaste
        return bottomDialogue
    }()

    private lazy var frontPageView: FrontpageViewDemoView = {
        let frontPageView = FrontpageViewDemoView(withAutoLayout: true)
        return frontPageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    // MARK: - Setup

    func setup() {
        setupTop()

        view.addSubview(top)
        view.addSubview(bottom)

        bottom.isExclusiveTouch = false

        NSLayoutConstraint.activate([
            top.topAnchor.constraint(equalTo: view.topAnchor),
            top.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            top.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            top.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),

            bottom.topAnchor.constraint(equalTo: top.bottomAnchor),
            bottom.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottom.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottom.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            ])

        bottom.addSubview(frontPageView)
        frontPageView.fillInSuperview()
    }

    func setupTop() {
        top.addSubview(dismiss)
        top.addSubview(presentDialogue)

        NSLayoutConstraint.activate([
            dismiss.topAnchor.constraint(equalTo: top.topAnchor, constant: .largeSpacing + 10),
            dismiss.leadingAnchor.constraint(equalTo: top.leadingAnchor, constant: .largeSpacing),
            dismiss.trailingAnchor.constraint(equalTo: top.trailingAnchor, constant: -.largeSpacing),

            presentDialogue.topAnchor.constraint(equalTo: dismiss.topAnchor, constant: .largeSpacing + 20),
            presentDialogue.leadingAnchor.constraint(equalTo: top.leadingAnchor, constant: .largeSpacing),
            presentDialogue.trailingAnchor.constraint(equalTo: top.trailingAnchor, constant: -.largeSpacing),
            ])
    }

    // MARK: - Actions

    @objc private func handleDismissTap() {
        State.lastSelectedIndexPath = nil
        dismiss(animated: true)
    }

    @objc private func handlePresentDialogueTap() {
        addDialogueViewController()
    }
}

extension InlineConsentDemoViewController {

    private func addDialogueViewController() {
        let dialogue = DialogueViewController()
        dialogue.delegate = self
        addChild(dialogue)
        bottom.addSubview(dialogue.view)
        dialogue.didMove(toParent: self)

        NSLayoutConstraint.activate([
            dialogue.view.topAnchor.constraint(equalTo: bottom.topAnchor, constant: .largeSpacing + 10),
            dialogue.view.leadingAnchor.constraint(equalTo: bottom.leadingAnchor, constant: .largeSpacing),
            dialogue.view.trailingAnchor.constraint(equalTo: bottom.trailingAnchor, constant: -.largeSpacing),
            dialogue.view.heightAnchor.constraint(equalTo: bottom.heightAnchor, multiplier: 0.4),
            ])
    }

    private func removeDialogueViewController() {
        guard let dialogue = children.last else {
            return
        }

        dialogue.willMove(toParent: nil)
        dialogue.view.removeFromSuperview()
        dialogue.removeFromParent()
    }
}

extension InlineConsentDemoViewController: DialogueViewControllerDelegate {
    func dialogueViewControllerDelegateDidSelectPrimaryButton() {
        removeDialogueViewController()
    }
}
