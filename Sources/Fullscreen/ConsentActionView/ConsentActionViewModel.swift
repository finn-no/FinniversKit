//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Foundation

public protocol ConsentActionViewModel {
    var text: String { get }
    var buttonStyle: Button.Style { get }
    var buttonTitle: String { get }
    var indexPath: IndexPath { get }
}
