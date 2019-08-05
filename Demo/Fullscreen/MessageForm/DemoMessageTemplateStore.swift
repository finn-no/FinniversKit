import FinniversKit

class DemoMessageTemplateStore: MessageTemplateStoreProtocol {

    var customTemplates: [MessageFormTemplate] = []
    private var nextCustomId: Int = 0

    init() {
        addTemplate(withText: "This is a custom template. There are many like it, but this one is mine.")
        addTemplate(withText: "Jeg husker ikke hvor jeg la lommeboka mi, kan jeg ikke bare få den gratis?")
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

    private func addTemplate(withText text: String) {
        let id = "custom_template_\(nextCustomId)"
        nextCustomId += 1

        let template = MessageFormTemplate(text: text, id: id)
        customTemplates.insert(template, at: 0)
    }
}
