import Foundation

public protocol MessageTemplateStoreProtocol {
    /// Return the list of custom templates. The returned list is expected to be unchanged throughout
    /// the store's lifecycle and ONLY change after calls to `addTemplate(withText:)` and `removeTemplate(_)`.
    var customTemplates: [MessageFormTemplate] { get }

    /// Called on the main thread  when the user wants to add a custom template to their list.
    /// Call the completion handler on the main thread with `true` if persisting the template was successful, `false` on failure.
    func addTemplate(withText text: String, completionHandler: @escaping (Bool) -> Void)

    /// Called on the main thread  when the user wants to remove a previously added custom template from their list.
    /// Call the completion handler on the main thread with `true` if the template was successfully removed, `false` on failure.
    func removeTemplate(_ template: MessageFormTemplate, completionHandler: @escaping (Bool) -> Void)

    /// Called on the main thread when the user wants to edit a custom template in their list.
    /// Call the completion handler on the main thread with `true` if updating the template was successful, `false` on failure.
    func updateTemplate(_ template: MessageFormTemplate, withText text: String, completionHandler: @escaping (Bool) -> Void)
}
