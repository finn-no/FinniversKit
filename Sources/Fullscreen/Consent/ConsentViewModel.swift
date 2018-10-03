//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Foundation

public protocol ConsentViewModel {
    var title: String? { get }
    var state: Bool { get set }
    var text: String { get }
    var buttonTitle: String { get }
    var buttonStyle: Button.Style { get }
    var indexPath: IndexPath { get }
}
