//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import SpriteKit

public class FlappyCatViewDemoView: UIView {
    lazy var flappyCatView: FlappyCatView = {
        let view = FlappyCatView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(flappyCatView)
        flappyCatView.fillInSuperview()
    }
}
