//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol AdConfirmationLinkViewModel {
    var title: String? { get set }
    var description: String? { get set }
    var linkTitle: String { get set }
}

public protocol AdConfirmationLinkViewDelegate: AnyObject {
    func adConfirmationLinkView(_ view: AdConfirmationLinkView, buttonWasTapped sender: UIButton)
}

public class AdConfirmationLinkView: UIView {
    private lazy var titleLabel: UILabel? = {
        return UILabel()
    }()

    private lazy var descriptionLabel: UILabel? = {
        return UILabel()
    }()

    private lazy var linkButton: Button = {
        let button = Button(style: .link)
        button.setTitle(model.linkTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var model: AdConfirmationLinkViewModel

    init(model: AdConfirmationLinkViewModel) {
        self.model = model
        super.init(frame: .zero)

        self.translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(linkButton)
        NSLayoutConstraint.activate([
            linkButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            linkButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
