//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import UIKit

public class RoundedImageView: UIImageView {
    public override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
    }
}
