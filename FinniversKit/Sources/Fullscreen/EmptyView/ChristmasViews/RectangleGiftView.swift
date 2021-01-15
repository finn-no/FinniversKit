//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class RectangleGiftView: UIImageView, AttachableView {
    var attach: UIAttachmentBehavior?
    private let cornerRadius: CGFloat = 4.0
    private let imageAsset: ImageAsset

    // MARK: - Init

    init(frame: CGRect, image: ImageAsset) {
        self.imageAsset = image
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
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
