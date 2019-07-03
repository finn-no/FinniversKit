//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol RemoteImageTableViewCellViewModel: BasicTableViewCellViewModel {
    var imageUrl: String { get }
    var cornerRadius: CGFloat { get }
    var imageSize: CGFloat { get }
}
