//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class StarView: UIImageView, AttachableView {
    var attach: UIAttachmentBehavior?

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .blue
        image = UIImage(named: .ornamentStar)
        contentMode = .scaleAspectFit
        isUserInteractionEnabled = true
    }

    // MARK: - Override methods

    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .rectangle
    }
}
