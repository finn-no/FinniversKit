import Foundation

public protocol MessageTemplateStoreProtocol {
    /// Return the list of custom templates. The returned list is expected to be unchanged throughout
    /// the store's lifecycle and ONLY change after calls to `addTemplate(withText:)` and `removeTemplate(_)`.
    var customTemplates: [MessageFormTemplate] { get }

    /// Called when the user wants to add a custom template to their list.
    /// Return 'true' if persisting the template was successful, 'false' on failure.
    func addTemplate(withText text: String) -> Bool

    /// Called when the user wants to remove a previously added custom template from their list.
    /// Return 'true' if the template was successfully removed, 'false' on failure.
    func removeTemplate(_ template: MessageFormTemplate) -> Bool
}
