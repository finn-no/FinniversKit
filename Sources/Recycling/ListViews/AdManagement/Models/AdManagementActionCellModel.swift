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
    let shouldShowSwitch: Bool
    let shouldShowChevron: Bool
    let shouldShowExternalIcon: Bool
    let image: UIImage

    public init(actionType: AdManagementActionType, title: String, description: String? = nil, showExternalIcon: Bool = false) {
        let typesRequiringSwitch: [AdManagementActionType] = [.start, .stop, .dispose, .undispose]
        let typesRequiringChevron: [AdManagementActionType] = [.edit, .review, .republish]
        // shouldShowExternalIcon will be partly dependant on logic outside the realms of this model
        let imagesForTypes: [AdManagementActionType: UIImage] = [.delete: UIImage(named: .trashcan),
                                                                 .edit: UIImage(named: .edit),
                                                                 .stop: UIImage(named: .hide),
                                                                 .start: UIImage(named: .view)]
        self.actionType = actionType
        self.title = title
        self.description = description
        self.shouldShowSwitch = typesRequiringSwitch.contains(actionType)
        self.shouldShowChevron = typesRequiringChevron.contains(actionType)
        self.shouldShowExternalIcon = actionType == .externalFallback || showExternalIcon
        self.image = imagesForTypes[actionType] ?? UIImage(named: .info)
    }
}
