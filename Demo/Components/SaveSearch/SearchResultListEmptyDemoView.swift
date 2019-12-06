//
//  EmptySearchResultListDemoView.swift
//  Demo
//
//  Created by Graneggen, Nina Røsdal on 06/12/2019.
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

class SearchResultListEmptyDemoView {
    
    let viewModels: [SaveSearchPromptView.State: SaveSearchPromptViewModel] = [
        .initial: SaveSearchPromptViewModel(title: "Ønsker du å bli varslet når det \n kommer nye treff i dette søket?", positiveButtonTitle: "Ja, takk!"),
        .accept: SaveSearchPromptViewModel(title: "Søket ble lagret")
    ]
    
}
