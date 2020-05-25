//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import Foundation

public protocol BapAdViewActions: AnyObject {
    func addToFavorites()
    func sendMessage()
    func showMap()
    func navigateToAuthorProfile()
    func presentContactOptions()
    func presentFullScreenGallery()

    func readMoreAboutHeltHjem()
    func shipmentAlternatives()

    func loanPrice()
    func reportAd()
}
