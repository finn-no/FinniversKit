//
//  Copyright © 2017 FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol Identifiable {
    static var reuseIdentifier: String { get }
}

public extension Identifiable {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}
