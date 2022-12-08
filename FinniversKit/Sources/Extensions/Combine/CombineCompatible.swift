import Combine

/// Found on https://www.avanderlee.com/swift/custom-combine-publisher.
/// Extending the `UIControl` types to be able to produce a `UIControl.Event` publisher.
public protocol CombineCompatible { }

extension UIControl: CombineCompatible { }

public extension CombineCompatible where Self: UIControl {
    func publisher(for events: UIControl.Event) -> UIControlPublisher<Self> {
        UIControlPublisher(control: self, events: events)
    }
}
