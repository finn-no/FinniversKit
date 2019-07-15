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

    private lazy var scrollView = UIScrollView(withAutoLayout: true)

    private lazy var contentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .marble
        return view
    }()

    private lazy var loginDialogue: LoginEntryDialogueView = {
        let view = LoginEntryDialogueView(withAutoLayout: true)
        view.backgroundColor = .milk
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
        addSubview(scrollView)
        scrollView.fillInSuperview()

        scrollView.addSubview(contentView)
        contentView.addSubview(loginDialogue)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(
                equalTo: loginDialogue.widthAnchor, constant: .largeSpacing, priority: .defaultLow
            ),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
        ])

        let dialogueConstraints: [NSLayoutConstraint]
        if UIDevice.isIPad() {
            dialogueConstraints = [
                loginDialogue.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                loginDialogue.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                loginDialogue.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.45),
            ]
        } else {
            dialogueConstraints = [
                loginDialogue.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
                loginDialogue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
                loginDialogue.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ]
        }

        NSLayoutConstraint.activate(dialogueConstraints)
    }
}
