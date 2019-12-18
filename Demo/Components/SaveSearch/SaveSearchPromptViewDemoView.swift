//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class SaveSearchPromptViewDemoView: UIView {

    // MARK: - Private properties

    private lazy var saveSearchPromptView = SaveSearchPromptView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setup() {
        saveSearchPromptView.configure(title: "Ønsker du å bli varslet når det \n kommer nye treff i dette søket?", positiveButtonTitle: "Ja, takk!")
        addSubview(saveSearchPromptView)

        NSLayoutConstraint.activate([
            saveSearchPromptView.widthAnchor.constraint(equalTo: widthAnchor),
            saveSearchPromptView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.17),
            saveSearchPromptView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
