//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

extension FavoriteActionViewModel {
    static let `default` = FavoriteActionViewModel(
        headerImage: createImage(),
        headerTitle: "Ærverdig herskapelig villa, med praktfull beliggende strandtomt (6500 kvm), helt i vannkanten. Perle, finnes ikke maken!",
        addNoteText: "Legg til notat",
        deleteText: "Slett favoritten fra listen"
    )

    private static func createImage() -> UIImage? {
        let urlString = "https://i.pinimg.com/736x/72/14/22/721422aa64cbb51ccb5f02eb29c22255--gray-houses-colored-doors-on-houses.jpg"

        guard let url = URL(string: urlString) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }

        return UIImage(data: data)
    }
}
