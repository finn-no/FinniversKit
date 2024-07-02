import UIKit

/// Currently not in use. Replaced with Native UIActivityIndicatorView. Still here in case we decide to go back
public class LoadingIndicatorView: UIActivityIndicatorView {
    public enum State {
        case delayedStart
        case started
        case stopped
    }

    public private(set) var state = State.stopped

    /// Starts the animation of the loading indicator after a short delay, unless it has already been stopped.
    /// - Parameters:
    ///   - after: Seconds to wait until starting animation (approximately)
    public func startAnimating(after delay: Double) {
        guard state == .stopped else { return }
        state = .delayedStart
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) { [weak self] in
            if self?.state == .delayedStart {
                self?.startAnimating()
            }
        }
    }

    public init() {
        super.init(frame: .zero)
        setup()
    }

    public override init(style: UIActivityIndicatorView.Style  = .large) {
        super.init(frame: .zero)
        setup(style: style)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }


    /// Starts the animation of the loading indicator.
    public override func startAnimating() {
        super.startAnimating()
        isHidden = false
        state = .started
    }

    /// Stops the animation of the loading indicator.
    public override func stopAnimating() {
        super.stopAnimating()
        isHidden = true
        state = .stopped
    }

    private func setup(style: UIActivityIndicatorView.Style  = .large) {
        self.style = style
    }
}
