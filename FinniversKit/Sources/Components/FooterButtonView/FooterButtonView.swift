//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit
import Warp

public protocol FooterButtonViewDelegate: AnyObject {
    func footerButtonView(_ view: FooterButtonView, didSelectButton button: UIButton)
}

public final class FooterButtonView: TopShadowView {
    // MARK: - Internal properties

    public weak var delegate: FooterButtonViewDelegate?

    public var buttonTitle: String? {
        didSet {
            button.setTitle(buttonTitle, for: .normal)
        }
    }

    public var isEnabled: Bool {
        get { button.isEnabled }
        set { button.isEnabled = newValue }
    }

    // MARK: - Private properties

    private lazy var button: UIButton = {
        let button = Button(style: .callToAction, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .background
        addSubview(button)

        let insets = UIEdgeInsets(
            top: Warp.Spacing.spacing200,
            leading: Warp.Spacing.spacing200,
            bottom: -Warp.Spacing.spacing200,
            trailing: -Warp.Spacing.spacing200
        )

        button.fillInSuperview(insets: insets)
    }

    // MARK: - Actions

    @objc private func handleButtonTap() {
        delegate?.footerButtonView(self, didSelectButton: button)
    }
}
