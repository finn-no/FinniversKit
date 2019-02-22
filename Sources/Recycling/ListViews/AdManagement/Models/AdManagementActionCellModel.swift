//
//  Copyright © FINN.no AS. All rights reserved.
//

import Foundation

public enum AdManagementActionType: String, Decodable {
    case preview
    case delete
    case start
    case stop
    case dispose
    case undispose
    case republish
    case edit
    case upsale
    case unknown
    case review
    case externalFallback
}

public struct AdManagementActionCellModel {
    let actionType: AdManagementActionType
    let title: String
    let description: String?
    let hasSwitch: Bool
    let shouldShowChevron: Bool
    let image: UIImage

    public init(actionType: AdManagementActionType, title: String, description: String? = nil) {
        let typesRequiringSwitch: [AdManagementActionType] = [.start, .stop, .dispose, .undispose]
        let typesRequiringChevron: [AdManagementActionType] = [.edit, .review, .republish]
        let imagesForTypes: [AdManagementActionType: UIImage] = [.delete: UIImage(named: .trashcan),
                                                                 .edit: UIImage(named: .edit),
                                                                 .stop: UIImage(named: .hide),
                                                                 .start: UIImage(named: .view)]

        self.actionType = actionType
        self.title = title
        self.description = description
        self.hasSwitch = typesRequiringSwitch.contains(actionType)
        self.shouldShowChevron = typesRequiringChevron.contains(actionType)
        self.image = imagesForTypes[actionType] ?? UIImage(named: .info)
    }
}
