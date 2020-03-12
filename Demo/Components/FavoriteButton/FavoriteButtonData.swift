//
//  FavoriteButtonViewModel.swift
//  Demo
//
//  Created by Graneggen, Nina Røsdal on 12/03/2020.
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

struct FavoriteButtonData: FavoriteButtonViewModel {
    var title: String {
        return isFavorite ? "Lagt til som favoritt" : "Legg til favoritt"
    }

    var subtitle: String? {
        return "3 har lagt til som favoritt"
    }

    var isFavorite: Bool
}
