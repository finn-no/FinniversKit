//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol LoginEntryViewModel {
    var title: String { get }
    var detail: String { get }
    var loginButtonTitle: String { get }
    var registerButtonTitle: String { get }
}

public protocol LoginEntryViewDelegate: AnyObject {
    func loginEntryViewDidSelectLoginButton()
    func loginEntryViewDidSelectRegisterButton()
}

public class LoginEntryView: UIView {
    // MARK: - Public properties

    public var model: LoginEntryViewModel? {
        didSet {
            loginDialogue.model = model
        }
    }

    public weak var delegate: LoginEntryViewDelegate? {
        didSet {
            loginDialogue.delegate = delegate
        }
    }

    // MARK: - Private properties

    private lazy var loginDialogue: LoginEntryDialogueView = {
        let view = LoginEntryDialogueView()
        view.backgroundColor = .milk
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dropShadow(color: .sardine, opacity: 0.3, offset: CGSize(width: 10, height: 0), radius: 24)

        return view
    }()

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Private methods

    private func setup() {
        backgroundColor = .marble
        addSubview(loginDialogue)

        let dialogueConstraints: [NSLayoutConstraint]
        if UIDevice.isIPad() {
            dialogueConstraints = [
                loginDialogue.centerXAnchor.constraint(equalTo: centerXAnchor),
                loginDialogue.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
                loginDialogue.centerYAnchor.constraint(equalTo: centerYAnchor),
            ]
        } else {
            dialogueConstraints = [
                loginDialogue.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
                loginDialogue.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
                loginDialogue.centerYAnchor.constraint(equalTo: centerYAnchor),
            ]
        }

        NSLayoutConstraint.activate(dialogueConstraints)
    }
}
