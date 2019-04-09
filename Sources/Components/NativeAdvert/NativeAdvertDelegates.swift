//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol NativeAdvertViewDelegate: AnyObject {
    func nativeAdvertViewDidSelectSettingsButton()
}

public protocol NativeAdvertImageDelegate: AnyObject {
    func nativeAdvertView(setImageWithURL url: URL, onImageView imageView: UIImageView)
}
