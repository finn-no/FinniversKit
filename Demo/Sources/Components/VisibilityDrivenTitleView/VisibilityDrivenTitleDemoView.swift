//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit
import Warp

class VisibilityDrivenTitleDemoView: UIView, Demoable {

    var dismissKind: DismissKind { .button }

    // MARK: - Private properties

    private lazy var titleView: VisibilityDrivenTitleView = {
        let view = VisibilityDrivenTitleView(withAutoLayout: true)
        view.title = "Now you see me"
        view.font = UIFont.title3
        view.setIsVisible(true)
        return view
    }()

    private lazy var visibilitySwitch: UISwitch = {
        let visibilitySwitch = UISwitch(withAutoLayout: true)
        visibilitySwitch.isOn = true
        visibilitySwitch.addTarget(self, action: #selector(switchDidChange), for: .valueChanged)
        return visibilitySwitch
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Private methods

    private func setup() {
        titleView.layer.borderColor = .text
        titleView.layer.borderWidth = 0.5

        addSubview(titleView)
        addSubview(visibilitySwitch)

        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            titleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200),
            titleView.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing400),
            titleView.heightAnchor.constraint(equalToConstant: 50),

            visibilitySwitch.centerXAnchor.constraint(equalTo: centerXAnchor),
            visibilitySwitch.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: Warp.Spacing.spacing400)
        ])
    }

    @objc private func switchDidChange(_ visibilitySwitch: UISwitch) {
        titleView.setIsVisible(visibilitySwitch.isOn)
    }
}
