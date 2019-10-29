//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol FooterButtonViewDelegate: AnyObject {
    func footerButtonView(_ view: FooterButtonView, didSelectButton button: UIButton)
}

public final class FooterButtonView: DynamicShadowView {
    // MARK: - Internal properties

    public weak var delegate: FooterButtonViewDelegate?

    public var buttonTitle: String? {
        didSet {
            button.setTitle(buttonTitle, for: .normal)
        }
    }

    // MARK: - Private properties

    private let button: UIButton = {
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
        backgroundColor = .bgPrimary
        addSubview(button)

        let insets = UIEdgeInsets(
            top: .mediumLargeSpacing,
            leading: .mediumLargeSpacing,
            bottom: -.largeSpacing - windowSafeAreaInsets.bottom,
            trailing: -.mediumLargeSpacing
        )

        button.fillInSuperview(insets: insets)
    }

    // MARK: - Actions

    @objc private func handleButtonTap() {
        delegate?.footerButtonView(self, didSelectButton: button)
    }
}
