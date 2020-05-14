//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class SwitchViewDemoView: UIView {
    private lazy var demoSwitch1 = SwitchView(withAutoLayout: true)
    private lazy var demoSwitch2 = SwitchView(withAutoLayout: true)
    private lazy var demoSwitch3 = SwitchView(style: .customStyle, withAutoLayout: true)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [demoSwitch1, demoSwitch2, demoSwitch3])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = .spacingS
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
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
        ])
    }
}

private extension SwitchViewStyle {
    static var customStyle = SwitchViewStyle(
        titleLabelStyle: .bodyStrong,
        titleLabelTextColor: .textPrimary,
        detailLabelStyle: .caption,
        detailLabelTextColor: .textPrimary
    )
}
