//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import UIKit

public class BroadcastDemoView: UIView {
    lazy var singleLineBroadcastView: BroadcastView = {
        let view = BroadcastView(message: "Broadcast message")

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var multilineBroadcastView: BroadcastView = {
        let view = BroadcastView(message: "Longer broadcast message that spans over several lines.")

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

private extension BroadcastDemoView {
    func setup() {
        addSubview(singleLineBroadcastView)
        addSubview(multilineBroadcastView)

        NSLayoutConstraint.activate([
            singleLineBroadcastView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            singleLineBroadcastView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            singleLineBroadcastView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            multilineBroadcastView.topAnchor.constraint(equalTo: singleLineBroadcastView.bottomAnchor, constant: .mediumSpacing),
            multilineBroadcastView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            multilineBroadcastView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
        ])
    }
}
