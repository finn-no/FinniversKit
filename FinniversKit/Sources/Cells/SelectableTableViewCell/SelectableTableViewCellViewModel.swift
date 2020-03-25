//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol SelectableTableViewCellViewModel: BasicTableViewCellViewModel {
    var isSelected: Bool { get }
}
