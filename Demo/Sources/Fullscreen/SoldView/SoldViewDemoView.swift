//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

class SoldViewDemoView: UIView, Demoable {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let image = UIImage(named: .sold)
        let viewModel = SoldViewModel(image: image, text: "Solgt!", button: "Ferdig")
        let soldView = SoldView(viewModel: viewModel)

        addSubview(soldView)

        NSLayoutConstraint.activate([
            soldView.centerXAnchor.constraint(equalTo: centerXAnchor),
            soldView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
