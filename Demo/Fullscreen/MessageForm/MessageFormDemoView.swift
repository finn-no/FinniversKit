//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class MessageFormDemoView: UIView {
    private lazy var formView: MessageFormView = {
        let view = MessageFormView(viewModel: .default)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(formView)
        formView.fillInSuperview()
    }
}

// MARK: - MessageFormViewDelegate

extension MessageFormDemoView: MessageFormViewDelegate {
    public func messageFormView(_ view: MessageFormView, didEditMessageText text: String) {
        print("Did edit text: \(text)")
    }

    public func messageFormView(
        _ view: MessageFormView,
        didSelectMessageTemplate template: MessageFormTemplate
    ) {
        view.text = template.text
        print("Selected template: \(String(describing: template.id))")
    }
}

// MARK: - Private extensions

private extension MessageFormViewModel {
    static var `default`: MessageFormViewModel {
        return MessageFormViewModel(
            showTemplateToolbar: true,
            transparencyText: "FINN.no forbeholder seg retten til å kontrollere meldinger og stoppe useriøs e-post.",
            messageTemplates: [
                MessageFormTemplate(
                    text: "Hei! Jeg er interessert, når passer det at jeg henter den?",
                    id: "1"
                ),
                MessageFormTemplate(
                    text: "Hei! Jeg er interessert, kan du sende den?",
                    id: "2"
                ),
                MessageFormTemplate(
                    text: "Hei! Jeg er interessert, er du villig til å diskutere prisen?",
                    id: "3"
                ),
        ])
    }
}
