//
//  AdConfirmationObjectView.swift
//  FinniversKit
//
//  Created by Saleh-Jan, Robin on 29/10/2019.
//  Copyright © 2019 FINN AS. All rights reserved.
//

protocol AdConfirmationObjectView {
    var imageUrl: URL? { get set }
    var title: String { get set }
    var body: String? { get set }
}
