//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import Foundation

public struct TryHeltHjemViewModel {
    public let title: String
    public let description: String
    public let ctaButtonTitle: String
    public let readMoreButtonTitle: String

    public init(title: String, description: String, ctaButtonTitle: String, readMoreButtonTitle: String) {
        self.title = title
        self.description = description
        self.ctaButtonTitle = ctaButtonTitle
        self.readMoreButtonTitle = readMoreButtonTitle
    }
}

extension TryHeltHjemViewModel {
    static let sampleData: TryHeltHjemViewModel = TryHeltHjemViewModel(
        title: "Prøv Helthjem, fra kr 75",
        description: "Nå hjelper vi selger med å sende varen til deg\nenten hjemmefra eller fra butikk",
        ctaButtonTitle: "Finn ut mer her",
        readMoreButtonTitle: "Se alle frakalternativer"
    )
}
