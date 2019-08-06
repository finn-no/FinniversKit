import FinniversKit

class DemoMessageTemplateStore: MessageTemplateStoreProtocol {

    var customTemplates: [MessageFormTemplate] = []
    private var nextCustomId: Int = 0

    init() {
        addTemplate(withText: "multi\n\nline\n\n\ntemplate")
        addTemplate(withText: "Jeg husker ikke hvor jeg la lommeboka mi, kan jeg ikke bare få den gratis?\n\nMvh, Stian Kurk")
        addTemplate(withText: "Kan du kjøre den hjem til meg gratis?")
    }

    func addTemplate(withText text: String, completionHandler: @escaping (Bool) -> Void) {
        addTemplate(withText: text)
        completionHandler(true)
    }

    func removeTemplate(_ template: MessageFormTemplate, completionHandler: @escaping (Bool) -> Void) {
        customTemplates.removeAll(where: { $0.id == template.id })
        completionHandler(true)
    }

    func updateTemplate(_ template: MessageFormTemplate, withText text: String, completionHandler: @escaping (Bool) -> Void) {
        guard let index = customTemplates.firstIndex(where: { $0.id == template.id }) else {
            completionHandler(false)
            return
        }

        customTemplates.remove(at: index)
        let newTemplate = MessageFormTemplate(text: text, id: template.id)
        customTemplates.insert(newTemplate, at: index)
        completionHandler(true)
    }

    private func addTemplate(withText text: String) {
        let id = "custom_template_\(nextCustomId)"
        nextCustomId += 1

        let template = MessageFormTemplate(text: text, id: id)
        customTemplates.insert(template, at: 0)
    }
}
