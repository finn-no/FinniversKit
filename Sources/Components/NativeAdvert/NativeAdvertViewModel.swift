//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol NativeAdvertViewModel {
    var title: String { get }
    var description: String? { get }
    var mainImageUrl: URL? { get }
    var logoImageUrl: URL? { get }
    var ribbon: NativeAdvertRibbonViewModel { get }
}
