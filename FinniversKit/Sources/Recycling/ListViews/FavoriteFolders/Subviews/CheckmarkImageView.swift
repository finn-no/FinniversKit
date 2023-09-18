//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public extension UIImageView {
    static var checkmarkImageView: UIImageView {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .btnPrimary
        imageView.image = UIImage(named: .check)
        imageView.tintColor = .bgPrimary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}

// MARK: - Internal extensions

extension UIImageView {
    convenience init(imageName: ImageAsset, withAutoLayout: Bool) {
        self.init(withAutoLayout: withAutoLayout)
        self.image = UIImage(named: imageName)
    }
    
    convenience init(image: UIImage, withAutoLayout: Bool) {
        self.init(withAutoLayout: withAutoLayout)
        self.image = image
    }
}
