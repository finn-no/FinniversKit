//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation
import FinniversKit

public struct NativeAdvertDefaultData: NativeAdvertViewModel {
    public let title = "Du har skjært avokadoen feil i alle år! 50 tegn!"
    public let description: String? = "Vi vet det er overraskende, men klikker du her kan vi vise deg hvordan det skal gjøres!"
    public let mainImageUrl = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Guacomole.jpg/2560px-Guacomole.jpg")
    public let logoImageUrl = URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/1d/Avocado.jpeg")
    public let sponsoredBy: String? = "Avokadosentralen"
    public let ribbonText = "Annonse"
}

public struct NativeAdvertContentDefaultData: NativeAdvertViewModel {
    public let title = "Du har skjært avokadoen feil i alle år! 50 tegn!"
    public let description: String? = "Vi vet ikke helt hvorfor du har gjort det feil, men..."
    public let mainImageUrl = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Guacomole.jpg/2560px-Guacomole.jpg")
    public let logoImageUrl = URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/1d/Avocado.jpeg")
    public let sponsoredBy: String? = ""
    public let ribbonText = "Annonsørinnhold"
}
