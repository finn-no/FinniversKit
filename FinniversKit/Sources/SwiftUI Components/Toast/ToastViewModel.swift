import Foundation

public class ToastViewModel {
    public var text: String
    public var style: Toast.Style
    public var action: Toast.Action?
    public var timeout: TimeInterval
    public var position: Toast.Position

    public init(
        text: String,
        style: Toast.Style,
        action: Toast.Action? = nil,
        position: Toast.Position = .bottom,
        timeout: TimeInterval = 5
    ) {
        self.text = text
        self.style = style
        self.action = action
        self.position = position
        self.timeout = timeout
    }
}
