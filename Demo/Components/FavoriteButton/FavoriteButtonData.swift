//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

struct FavoriteButtonData: FavoriteButtonViewModel {
    var title: String {
        return isFavorite ? "Lagt til som favoritt" : "Legg til favoritt"
    }

    var subtitle: String? {
        return isFavorite ? "4 har lagt til som favoritt" : "3 har lagt til som favoritt"
    }

    var isFavorite: Bool
}
