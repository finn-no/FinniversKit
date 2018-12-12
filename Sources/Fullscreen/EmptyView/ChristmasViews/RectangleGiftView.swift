//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class RectangleGiftView: UIImageView, AttachableView {
    var attach: UIAttachmentBehavior?
    private let cornerRadius: CGFloat = 4.0
    private let imageAsset: FinniversImageAsset

    // MARK: - Init

    public init(frame: CGRect, image: FinniversImageAsset) {
        self.imageAsset = image
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    // MARK: - Setup

    private func setup() {
        image = UIImage(named: imageAsset)
        contentMode = .scaleAspectFit
        isUserInteractionEnabled = true
    }

    // MARK: - Override methods

    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .rectangle
    }
}
