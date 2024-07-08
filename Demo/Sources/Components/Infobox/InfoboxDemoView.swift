//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit
import Warp

public class InfoboxDemoView: UIView, Demoable {
    private lazy var stackView = UIStackView(axis: .vertical, spacing: Warp.Spacing.spacing300, distribution: .equalSpacing, withAutoLayout: true)
    private lazy var scrollView = UIScrollView(withAutoLayout: true)

    private var infoboxConfigurations: [(style: InfoboxView.Style, model: InfoboxViewModel)] = [
        (style: .small(backgroundColor: .backgroundInfoSubtle), model: InfoboxDefaultData()),
        (style: .normal(backgroundColor: .backgroundInfoSubtle, primaryButtonIcon: UIImage(named: .webview)), model: InfoboxOpenBrowserData()),
        (style: .warning, model: InfoboxWarningData()),
        (style: .warning, model: InfoboxNoButtons()),
    ]

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        let infoboxes = infoboxConfigurations.map(createInfoBox(style:model:))
        stackView.addArrangedSubviews(infoboxes)

        scrollView.addSubview(stackView)
        stackView.fillInSuperview(margin: Warp.Spacing.spacing200)

        addSubview(scrollView)
        scrollView.fillInSuperview()

        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -Warp.Spacing.spacing200 * 2)
        ])
    }

    private func createInfoBox(style: InfoboxView.Style, model: InfoboxViewModel) -> InfoboxView {
        let view = InfoboxView(style: style, withAutoLayout: true)
        view.model = model
        return view
    }
}
