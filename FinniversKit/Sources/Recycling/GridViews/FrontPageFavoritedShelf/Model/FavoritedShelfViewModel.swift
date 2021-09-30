//
//  FavoritedShelfViewModel.swift
//  FinniversKit
//
//  Created by Suthananth Arulanantham on 04/09/2021.
//  Copyright © 2021 FINN AS. All rights reserved.
//

import Foundation

public struct FavoritedShelfViewModel: Hashable {
    public var adId: String
    public var imagePath: String?
    public var title: String
    public var price: String
    public var subtitle: String
    public var statusText: String?
    
    public init(adId: String, imagePath: String?, title: String, price: String, subtitle: String, statusText: String? = nil) {
        self.adId = adId
        self.imagePath = imagePath
        self.title = title
        self.price = price
        self.subtitle = subtitle
        self.statusText = statusText
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(adId + title)
    }
}
