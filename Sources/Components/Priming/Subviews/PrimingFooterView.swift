//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

protocol PrimingFooterViewDelegate: AnyObject {
    func primingFooterViewDidSelectButton(_ view: PrimingFooterView)
}

final class PrimingFooterView: DynamicShadowView {
    // MARK: - Internal properties

    weak var delegate: PrimingFooterViewDelegate?

    var buttonTitle: String? {
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        delegate?.primingFooterViewDidSelectButton(self)
    }
}
