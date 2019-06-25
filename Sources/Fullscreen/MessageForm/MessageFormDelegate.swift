import Foundation

public protocol MessageFormDelegate: AnyObject {
    func messageFormDidCancel()
    func messageFormDidFinish(withText text: String, templateState: MessageFormTemplateState)
}

public enum MessageFormTemplateState {
    case custom
    case template
    case modifiedTemplate
}
