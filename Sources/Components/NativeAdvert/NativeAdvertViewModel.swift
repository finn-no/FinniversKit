//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol NativeAdvertViewModel {
    var title: String? { get }
    var mainImageURL: URL? { get }
    var iconImageURL: URL? { get }
    var sponsoredText: String? { get }
}
