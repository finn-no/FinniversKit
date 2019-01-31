//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class PianoDemoView: UIView {
    private lazy var pianoView = PianoView()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(pianoView)
        pianoView.fillInSuperview()
    }
}
