//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FooterButtonDemoView: UIView {

    // MARK: - Private properties

    private lazy var view: FooterButtonView = {
        let view = FooterButtonView(withAutoLayout: true)
        view.buttonTitle = "Lagre"
        view.delegate = self
        view.layer.shadowRadius = FooterButtonView.maxShadowRadius
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Setup

    private func setup() {
        addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - FooterButtonViewDelegate

extension FooterButtonDemoView: FooterButtonViewDelegate {
    func footerButtonView(_ view: FooterButtonView, didSelectButton button: UIButton) {
        print("Button selected")
    }
}
