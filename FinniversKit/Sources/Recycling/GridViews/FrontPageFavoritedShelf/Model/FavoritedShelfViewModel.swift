//
//  FavoritedShelfViewModel.swift
//  FinniversKit
//
//  Created by Suthananth Arulanantham on 04/09/2021.
//  Copyright © 2021 FINN AS. All rights reserved.
//

import Foundation

public protocol FavoritedShelfViewModel {
    var adId: String { get }
    var imagePath: String? { get }
    var title: String { get }
    var price: String { get }
    var subtitle: String { get }
}
