//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import UIKit

protocol DemoViews: CaseIterable {
    static var items: [Self] { get }
    var viewController: UIViewController { get }
}

extension DemoViews where Self: RawRepresentable, RawValue == String {
    static var items: [Self] {
        allCases.sorted { $0.rawValue < $1.rawValue }
    }
}
