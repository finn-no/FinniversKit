//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit
import Warp

public class SwitchViewDemoView: UIView, Demoable {
    private lazy var demoSwitch1 = SwitchView(withAutoLayout: true)
    private lazy var demoSwitch2 = SwitchView(withAutoLayout: true)
    private lazy var demoSwitch3 = SwitchView(style: .customStyle, withAutoLayout: true)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [demoSwitch1, demoSwitch2, demoSwitch3])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Warp.Spacing.spacing100
        return stackView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        demoSwitch1.configure(with: SwitchViewDefaultModel.demoViewModel1)
        demoSwitch2.configure(with: SwitchViewDefaultModel.demoViewModel2)
        demoSwitch3.configure(with: SwitchViewDefaultModel.demoViewModel3)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing200),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200),
        ])
    }
}

private extension SwitchViewStyle {
    static var customStyle = SwitchViewStyle(
        titleLabelStyle: .bodyStrong,
        titleLabelTextColor: .text,
        detailLabelStyle: .caption,
        detailLabelTextColor: .text
    )
}
