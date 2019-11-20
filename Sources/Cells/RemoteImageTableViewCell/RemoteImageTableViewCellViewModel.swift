//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Bootstrap

public protocol RemoteImageTableViewCellViewModel: BasicTableViewCellViewModel {
    var imagePath: String? { get }
    var cornerRadius: CGFloat { get }
    var imageViewWidth: CGFloat { get }
}
