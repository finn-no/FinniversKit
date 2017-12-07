//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika

public class EmptyViewPlayground: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        backgroundColor = .green

        let emptyView = UIView(withAutoLayout: true)
        emptyView.backgroundColor = .red

        addSubview(emptyView)
        emptyView.fillInSuperview(insets: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

