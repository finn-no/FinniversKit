//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation
import FinniversKit

public struct NativeAdvertDefaultData: NativeAdvertViewModel {
    public let title: String
    public let description: String? = "Vi vet det er overraskende, men klikker du her kan vi vise deg hvordan det skal gjøres!"
    public let mainImageUrl: URL? =  URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Guacomole.jpg/2560px-Guacomole.jpg")
    public let logoImageUrl: URL? = URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/1d/Avocado.jpeg")
    public let ribbon: NativeAdvertRibbonViewModel

    public static let native = NativeAdvertDefaultData(
        title: "Denne annonsen er av typen `native`. Er 50 tegn...",
        ribbon: NativeAdvertRibbonViewModel(type: "Annonse", company: "Avokadosentralenerbest")
    )

    public static let content = NativeAdvertDefaultData(
        title: "Denne annonsen er av typen `content`. Er 50 tegn..",
        ribbon: NativeAdvertRibbonViewModel(type: "Annonsørinnhold", company: "Avokadosentralen")
    )
}
