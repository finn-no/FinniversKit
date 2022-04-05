//
//  Copyright © 2022 FINN AS. All rights reserved.
//

// Found on https://www.avanderlee.com/swift/custom-combine-publisher.

import Combine

/// Extending the `UIControl` types to be able to produce a `UIControl.Event` publisher.
protocol CombineCompatible { }
extension UIControl: CombineCompatible { }
extension CombineCompatible where Self: UIControl {
    func publisher(for events: UIControl.Event) -> UIControlPublisher<Self> {
        return UIControlPublisher(control: self, events: events)
    }
}
