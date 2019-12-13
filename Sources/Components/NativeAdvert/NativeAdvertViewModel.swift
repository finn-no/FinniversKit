//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol NativeAdvertViewModel {
    var title: String { get }
    var mainImageUrl: URL? { get }
    var logoImageUrl: URL? { get }
    var sponsoredBy: String? { get }
    var ribbonText: String { get }
}
