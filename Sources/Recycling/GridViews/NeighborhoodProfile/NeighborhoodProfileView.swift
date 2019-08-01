//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public final class NeighborhoodProfileView: UIView {

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .red
    }
}
