//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

enum ChristmasOrnamentColor {
    case red, blue
}

class ChristmasOrnamentView: UIImageView, AttachableView {
    var attach: UIAttachmentBehavior?
    private let ornamentColor: ChristmasOrnamentColor

    // MARK: - Init

    init(frame: CGRect, ornamentColor: ChristmasOrnamentColor) {
        self.ornamentColor = ornamentColor
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    // MARK: - Setup

    private func setup() {
        switch ornamentColor {
        case .red:
            image = UIImage(named: .ornamentCircleRed)
        case .blue:
            image = UIImage(named: .ornamentCircleBlue)
        }

        contentMode = .scaleAspectFit
        isUserInteractionEnabled = true
    }

    // MARK: - Override methods

    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
}
