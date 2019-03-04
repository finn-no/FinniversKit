//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class DialogueDemoView: UIView {

    private lazy var dialogueView = DialogueView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(dialogueView)
        dialogueView.model = DialogueDefaultData()

        NSLayoutConstraint.activate([
            dialogueView.topAnchor.constraint(equalTo: topAnchor),
            dialogueView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dialogueView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dialogueView.heightAnchor.constraint(equalTo: heightAnchor),
        ])
    }
}
