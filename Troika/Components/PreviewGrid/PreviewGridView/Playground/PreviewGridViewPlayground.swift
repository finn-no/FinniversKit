//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika

public class PreviewGridViewPlayground: UIView, Injectable {
    lazy var delegateDataSource: PreviewGridDelegateDataSource = {
        return PreviewGridDelegateDataSource()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    public func setup() {

        let view = PreviewGridView(delegate: delegateDataSource, dataSource: delegateDataSource)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
