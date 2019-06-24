//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

struct MessageFormDemoViewModel: MessageFormViewModel {
    let titleText: String
    let sendButtonText: String
    let cancelButtonText: String
    let transparencyText: String
    let messageTemplates: [String]
}

extension MessageFormDemoViewModel {
    static var `default`: MessageFormDemoViewModel {
        return MessageFormDemoViewModel(titleText: "Send melding",
                                        sendButtonText: "Send",
                                        cancelButtonText: "Avbryt",
                                        transparencyText: "FINN.no forebeholder seg retten til å kontrollere meldinger og stoppe useriøs e-post.",
                                        messageTemplates: [
                                            "Det ser ut som du prøver å selge noe på FINN 📎",
                                            "Hei! Jeg er interessert hvis denne fortsatt er tilgjengelig 🙂",
                                            "Hei! Er prisen diskuterbar? 💰",
                                            "Hei! Jeg kan hente denne i morgen hvis det passer for deg 🚛"
                                        ])
    }
}
