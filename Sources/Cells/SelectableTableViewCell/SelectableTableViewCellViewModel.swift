//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import Bootstrap

public protocol SelectableTableViewCellViewModel: BasicTableViewCellViewModel {
    var isSelected: Bool { get }
}
